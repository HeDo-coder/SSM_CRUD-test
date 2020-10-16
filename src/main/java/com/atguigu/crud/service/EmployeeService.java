package com.atguigu.crud.service;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.EmployeeExample;
import com.atguigu.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author HeDo
 * @create 2020-10-10-11:23
 */

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    //查询所有员工
    public List<Employee> getALL() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    //员工保存方法
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }
    /**
     * @param empName
     * @return true:代表当前姓名可用； false:代表当前姓名不可用
     * */
    //检验用户名是否可用,如果记录中相同用户名的数量等于0，就会返回true，代表可用；否则返回false
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    /*按照员工id查询员工*/
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    //员工更新
    public void updateEmp(Employee employee) {
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    //员工删除
    public void deleteEmp(Integer id) {
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deletBatch(List<Integer> ids) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(example);
    }
}
