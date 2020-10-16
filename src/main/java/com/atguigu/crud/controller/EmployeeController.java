package com.atguigu.crud.controller;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sun.org.apache.xpath.internal.operations.Mod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author HeDo
 * @create 2020-10-10-11:19
 * 处理员工CRUD请求
 */

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /*单个/批量删除二合一
    *批量删除：1-2-3
    *单个删除：1
    *
    * */
    @ResponseBody
    @RequestMapping(value = "/emp/{ids}",method = RequestMethod.DELETE)
    public Msg deleteEmp(@PathVariable("ids")String ids){
        //批量删除
        if (ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            //组装id的集合
            for (String string : str_ids){
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deletBatch(del_ids);
        }else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }

        return Msg.success();
    }

    /*如果直接发送ajax=PUT形式的请求
    * 封装的数据除了empId,全是null
    *
    *问题：
    * 求请求题中有数据但是employee对象中封装不上数据：
    * update tbl_emp where emp_id = 1014
    *
    * 原因：
    * Tomcat：
    * 1.将请求体中的数据，封装成一个map，
    * 2.request.getParameter("empName")就会从这个map中取值
    * 3.SpringMVC封装每个POJO对象的时候，会把POJO中每个属性的值，request.getParameter（“email”）;
    *
    *
    * AJAX发送PUT请求引发的血案：
    *   Put请求，请求体中的数据request.getParameter("gender")拿不到
    *   Tomcat一看是PUT请求就不会封装请求体中的数据为map，只有POST形式的请求才封装请求体
    * org.apache.catalina.connector.Request -- parseParameters()
    * 解决方案：
    * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
    * 1.配置上HttpPutFormContentFilter；
    * 2.它的作用：将请求体中的数据解析包装成一个map
    * 3.request被重新包装，request.setParameter（）被重写，就会从自己封装的map中读取数据
    * */
    //员工更新方法
    @ResponseBody
    @RequestMapping(value = "/emp/{empId}",method = RequestMethod.PUT)
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println("请求体中的值："+request.getParameter("gender"));
        System.out.println("将要更新的员工数据："+employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }


    //根据id查询员工
    @RequestMapping(value = "/emp/{id}",method = RequestMethod.GET)
    @ResponseBody
    //@PathVariable注解制定从路径中取出参数id的值
    public Msg getEmp(@PathVariable("id") Integer id){

        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp",employee);
    }


    //检查用户名是否可用
    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("empName")String empName){
        //先判断用户名是否是合法的表达式；
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        //如果匹配失败，直接返回失败
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","用户名必须是6-16为数字和字母的组合或者2-5位的中文");
        }
        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }
    }

    /*
    1.支持JSR303校验
    2.导入Hibernate-Validator
    */
    //员工保存
    @RequestMapping(value = "/emp",method = RequestMethod.POST)
    @ResponseBody
    //@Valid注解代表这里封装的对象里面的数据要进行校验
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            //校验失败应该返回失败，在模态框中显示校验失败的信息
            Map<String,Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名："+fieldError.getField());
                System.out.println("错误信息："+fieldError.getDefaultMessage());
                map.put(fieldError.getField(),fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }

    }

    //需要导入jackson包，负责将我们的对象转化为Json字符串
    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn",defaultValue = "1") Integer pn){
        //这不是一个分页查询；
        //引入PageHelper分页插件
        //在查询之前只需要调用,传入页码以及每页分页的大小
        PageHelper.startPage(pn,5);
        //startPage后紧跟着的查询就是一个分页查询
        List<Employee> emps = employeeService.getALL();
        //用PageInfo对结果进行包装查询后的结果，只需要将PageInfo交给页面就行了
        //PageInfo封装了详细的分页信息，包括我们查询出来的数据,后面的参数5是传入连续显示的页数连续显示5页
        PageInfo page = new PageInfo(emps,5);
        return Msg.success().add("pageInfo",page);
    }

    /*查询员工数据（分页查询）*/
    /*注释掉下面方法，采用新的ajax的方法*/
    //@RequestMapping("/emps")
    //参数传入第几页的页码，如果没有的话就默认传入第一页
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        //这不是一个分页查询；
        //引入PageHelper分页插件
        //在查询之前只需要调用,传入页码以及每页分页的大小
        PageHelper.startPage(pn,5);
        //startPage后紧跟着的查询就是一个分页查询
        List<Employee> emps = employeeService.getALL();
        //用PageInfo对结果进行包装查询后的结果，只需要将PageInfo交给页面就行了
        //PageInfo封装了详细的分页信息，包括我们查询出来的数据,后面的参数5是传入连续显示的页数连续显示5页
        PageInfo page = new PageInfo(emps,5);
        model.addAttribute("pageInfo",page);
        return "list";
    }
}
