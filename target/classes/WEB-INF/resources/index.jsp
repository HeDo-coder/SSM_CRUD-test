<%--
  Created by IntelliJ IDEA.
  User: he_do
  Date: 2020/10/10
  Time: 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8"%>
<%--引入jstl标签库核心库--%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="https://cdn.jsdelivr.net/npm/jquery@1.12.4/dist/jquery.min.js"></script>
    <!-- 引入Bootstrap样式 -->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <%--点击新增打开的表单内容--%>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <%--为了SpringMVC封装方便，提交的数据能自动地为我们封装Employee对象，唯一的要求就是表单项的name和JavaBean的属性名一样--%>
                                <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--下拉列表，里面的信息从数据库查出来--%>
                            <select class="form-control" name="dId">
                                <%--部门提交部门id即可--%>
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <%--点击新增打开的表单内容--%>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <%--为了SpringMVC封装方便，提交的数据能自动地为我们封装Employee对象，唯一的要求就是表单项的name和JavaBean的属性名一样--%>
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                                <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--下拉列表，里面的信息从数据库查出来--%>
                            <select class="form-control" name="dId" id="dept_add_select">
                                <%--部门提交部门id即可--%>
                            </select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%--搭建显示页面--%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM_CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row"></div>
    <div class="col-md-4 col-md-offset-8">
        <button class="btn btn-info" id="emp_add_model_btn">新增</button>
        <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
    </div>
    <%--显示表格数据--%>
    <div class="row"></div>
    <div class="col-md-12">
        <table class="table table-hover" id="emps_table">
            <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all"/>
                    </th>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>

            </tbody>

            <%--使用c：foreach把里面的数据都便利出来,将取出来的信息就填充到下面的tr中--%>


        </table>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-6" id="page_info_area">
        </div>
        <%--分页条信息--%>
        <div class="col-md-6" id="page_nav_area">
        </div>
    </div>
</div>
<script type="text/javascript">
    //定义一个全局变量，保存总记录数
    var totalRecord,currentPage;

    //1.页面加载完成后直接发送一个ajax请求要到分页数据
    $(function () {
        //一进来就去首页
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                /*console.log(result);*/
                //1.请求成功后就是在页面解析这个json并显示员工数据
                build_emps_table(result);
                //2.解析并显示分页信息
                build_page_info(result);
                //3.显示分页条
                build_page_nav(result);
            }
        });
    }

    //解析并显示表格数据的方法
    function build_emps_table(result) {
        //每次构建之前都清空table表格
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>")
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == "M" ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-info btn-sm edit_btn").append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            /*为编辑按钮添加一个自定义的属性，表示当前员工的id*/
            editBtn.attr("edit-id",item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            /*为删除按钮添加一个自定义的属性，表示当前员工的id*/
            delBtn.attr("del-id",item.empId);
            //将两个按钮放在同一个单元格中
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            //链式操作可以执行的原因是append（）方法执行完成后还会返回原来的元素
            $("<tr></tr>")
                .append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }
    //解析并显示分页信息的方法
    function build_page_info(result) {
        //每次构建之前都清空info信息
        $("#page_info_area").empty();
        $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + " 页,总共" + result.extend.pageInfo.pages + " 页,总共" + result.extend.pageInfo.total + " 条记录");

        //将总记录数保存在totalRecord全局变量中
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
    }
    //解析并显示分页条的方法,点击分页要能去下一页...
    function build_page_nav(result) {
        //每次构建之前都清空nav信息
        $("#page_nav_area").empty();
        //构建出父元素ul
        var ul = $("<ul></ul>").addClass("pagination");
        //构建子元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        //对是否有前一页进行判断，如果没有的话添加disabled信息
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            //为元素绑定点击翻页事件
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }

        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        //对是否有后一页进行判断，如果没有的话添加disabled信息
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            //为元素绑定点击翻页事件
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
        }


        //添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        //遍历出来页码号
        $.each(result.extend.pageInfo.navigatepageNums,function (inedx,item) {

            var numLi = $("<li></li>").append($("<a></a>").append(item));
            //添加判断，如果取出的页码信息和当前页码一直的话，就添加active标识
            if (result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            //给numLi绑定单击事件,点击页码跳转到对应的页面
            numLi.click(function () {
                to_page(item);
            })
            ul.append(numLi);
        });
        //等都遍历完了，添加下一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把ul添加到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    //情况表单样式及内容
    function reset_form(ele){
        //JQuery没有reset方法，所以要取出dom对象的reset方法
        $(ele)[0].reset();
        //情况表单样式
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }

    //点击新增按钮弹出模态框。
    $("#emp_add_model_btn").click(function () {
        //每次模态框弹出之前清除表单数据，也就是重置数据(表单完整重置：表单的数据以及表单的样式)
        //JQuery没有reset方法，所以要取出dom对象的reset方法
        reset_form("#empAddModel form")
        $("#empAddModel form")[0].reset();
        //发送ajax请求，查出部门信息，显示在下拉列表
        getDepts("#empAddModel select");
        //弹出模态框
        $("#empAddModel").modal({
            backdrop:"static"
        });
    });

    //查出所有的部门信息并显示在下拉列表中
    function getDepts(ele) {
        //每次查询前，先要情况下拉列表的值
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "GET",
            success:function (result) {
                /*console.log(result);*/
                //显示部门信息在下拉列表中
                //$("#dept_add_select").append("")
                $.each(result.extend.depts,function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo(ele)
                });
            }
        });
    }

    //校验表单员工数据的方法
    function validate_add_form(){
        //1.拿到要校验的数据，使用正则表达式
        var empName = $("#empName_add_input").val();
        //正则表达式中的首位斜杠是js中的写法
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if(!regName.test(empName)){
            //alert("用户名可以使2-5位中文或者6-16位英文和数字的组合。")
            show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合。");
            return false;
        }else{
            show_validate_msg("#empName_add_input","success","");
        }

        //校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/;
        if (!regEmail.test(email)){
            //alert("邮箱格式不正确。");
            show_validate_msg("#email_add_input","error","邮箱格式不正确。");
/*            $("#email_add_input").parent().addClass("has-error");
            $("#email_add_input").next("span").text("邮箱格式不正确。");*/
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
            /*$("#email_add_input").parent().addClass("has-success");
            $("#email_add_input").next("span").text("");*/
        }
        //如果一切正常，都校验成功了，再返回true。
        return true;
    }

    //显示校验结果的提示信息
    function show_validate_msg(ele,status,msg){
        //每次显示数据之前应该清空这个元素之前的样式
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        //对状态进行判断
        if ("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if ("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    $("#empName_add_input").change(function () {
        //当输入框中的文本有了改变的时候，应该发送ajax请求，校验用户名是否可用
        var empName = this.value;
        $.ajax({
           url:"${APP_PATH}/checkuser",
            data:"empName="+empName,
            type:"POST",
            success:function (result) {
                if (result.code == 100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    //给btn保存按钮添加一个自定义属性，用来确认当前按钮是否可用
                    $("#emp_save_btn").attr("ajax-va","success");
                }else{
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    //给btn保存按钮添加一个自定义属性，用来确认当前按钮是否可用
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    //点击保存员工的方法
    $("#emp_save_btn").click(function () {
        //1.将模态框中填写的表单数据提交给服务器进行保存
        //先对要提交给服务器的数据进行校验，校验成功后在提交数据
        if (!validate_add_form()){
            return false;
        }
        //判断之前的ajax用户名校验是否成功，如果成功再继续
        if ($(this).attr("ajax-va") == "error"){
            return false;
        }
        //2.发送ajax请求保存员工
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data:$("#empAddModel form").serialize(),
            success:function (result) {
                /*alert(result.msg);*/
                if (result.code == 100){
                    //员工保存成功之后：
                    //1.关闭模态框
                    $("#empAddModel").modal('hide');
                    //2.来到最后一页，显示刚才保存的数据
                    //发送ajax请求，发送ajax请求即可,只要页码参数值是一个特别大的数，大于页码值，就可以正常显示到最后一页
                    to_page(totalRecord);
                }else {
                    //显示失败信息
                    //console.log(result);
                    //有哪个字段的错误信息就显示哪个字段的
                    if (undefined != result.extend.errorFields.email){
                        //显示员工的邮箱错误信息
                        show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                    }
                    if (undefined != result.extend.errorFields.empName) {
                        //显示员工名字的错误信息
                        show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                    }
                }

            }
        });
    });



    //1.我们四按钮创建之前就绑定了click，所以这样是绑定不上的
    //（1）我们可以在常见按钮的时候绑定；（2）绑定点击.live（）方法，即使这个方法是以后再添加进来的也有效
    //但是JQuery新版本没有.live方法，使用on进行替代，on的用法比较特殊
    $(document).on("click",".edit_btn",function () {
        //alert("edit");


        //1.查出部门信息并显示部门列表
        getDepts("#empUpdateModel select");
        //2.查出员工信息，显示员工信息
        getEmp($(this).attr("edit-id"));
        //3.把员工id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        //弹出模态框
        $("#empUpdateModel").modal({
            backdrop:"static"
        });
    });

    //单个删除
    $(document).on("click",".delete_btn",function () {
        //1.弹出确认是否确认删除对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del-id");
        //alert($(this).parents("tr").find("td:eq(1)".text());
        if (confirm("确认删除【"+empName+"】吗？")){
            //确认，发送ajax请求即可
            $.ajax({
               url:"${APP_PATH}/emp/"+empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    //回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    //在点击修改按钮弹出模态框时，里面的内容是显示好的员工信息
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function (result) {
                //console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModel input[name=gender]").val([empData.gender]);
                $("#empUpdateModel select").val([empData.dId]);
            }
        });
    }

    //点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
        //验证邮箱是否合法
        //1.校验邮箱信息
        var email = $("#email_update_input").val();
        var regEmail = /^[a-zA-Z0-9_.-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.[a-zA-Z0-9]{2,6}$/;
        if (!regEmail.test(email)){
            show_validate_msg("#email_add_input","error","邮箱格式不正确。");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
        }

        //2.发送ajax请求，保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            type:"PUT",
            data:$("#empUpdateModel form").serialize(),
            success:function (result) {
                //alert(result.msg);
                //1.关闭对话框
                $("#empUpdateModel").modal("hide");
                //2.回到本页面
                to_page(currentPage);
            }
        });
    });


    //完成全选/全不选功能
    $("#check_all").click(function () {
        //attr获取checked是undefined
        //我们这些原生的属性，推荐不用attr，用prop；attr用来获取自定义
        //prop修改和读取dom原生属性的值
        $(".check_item").prop("checked",$(this).prop("checked"));
    });

    //check_item
    $(document).on("click",".check_item",function () {
        //判断当前选择中的元素是否是5个
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked",flag);
    });


    //点击全部删除，就批量删除
    $("#emp_delete_all_btn").click(function () {
        var del_idstr = "";
        var empNames = " ";
        $.each($(".check_item:checked"),function () {
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            //组装员工id的字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        //去除empNames的多余的“，”
        empNames = empNames.substring(0,empNames.length - 1);
        //去除员工id多余的“-”
        del_idstr = del_idstr.substring(0,del_idstr.length - 1);
        if (confirm("确认删除【"+empNames+"】吗？")){
            //发送ajax请求
            $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    //回到当前页面
                    to_page(currentPage);
                }
            });
        }
    });
</script>

</body>
</html>
