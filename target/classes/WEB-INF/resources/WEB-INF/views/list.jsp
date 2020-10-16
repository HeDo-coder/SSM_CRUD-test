<%--
  Created by IntelliJ IDEA.
  User: he_do
  Date: 2020/10/10
  Time: 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <button class="btn btn-info">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
            <%--显示表格数据--%>
        <div class="row"></div>
            <div class="col-md-12">
                <table class="table table-hover">
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                    <%--使用c：foreach把里面的数据都便利出来,将取出来的信息就填充到下面的tr中--%>
                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <th>${emp.empId}</th>
                            <th>${emp.empName}</th>
                            <th>${emp.gender == "M" ? "男" : "女"}</th>
                            <th>${emp.email}</th>
                            <th>${emp.department.deptName}</th>
                            <th>
                                <button class="btn btn-info btn-sm">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> 编辑
                                </button>
                                <button class="btn btn-danger btn-sm">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除
                                </button>
                            </th>
                        </tr>
                    </c:forEach>

                </table>
            </div>
            <%--显示分页信息--%>
        <div class="row"></div>
            <%--分页文字信息--%>
            <div class="col-md-6"></div>
            当前 ${pageInfo.pageNum} 页,总共 ${pageInfo.pages} 页,总共 ${pageInfo.total} 条记录。
            <%--分页条信息--%>
            <div class="col-md-6"></div>
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH}/emps?pn=1">首页</a></li>
                    <%--判断是否有上一页，如果有就显示，如果没有就不显示了--%>
                    <c:if test="${pageInfo.hasPreviousPage}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                        <%--将便利取出来的每页和当前页码进行判断，如果一样，就是高亮显示，如果不是，就是普通显示--%>
                        <c:if test="${page_Num == pageInfo.pageNum}">
                            <li class="active"><a href="#">${page_Num}</a></li>
                        </c:if>
                        <c:if test="${page_Num != pageInfo.pageNum}">
                            <%--点击页码跳转到对应的链接--%>
                            <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                        </c:if>
                    </c:forEach>
                    <%--对下一页进行判断，如果还有下一页，就可以点击下一页，如果没有就不显示了--%>
                    <c:if test="${pageInfo.hasNextPage}">
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum + 1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li>
                        <a href="${APP_PATH}/emps?pn=${pageInfo.pages}">末页</a>
                    </li>
                </ul>
            </nav>
        <div></div>
    </div>

</body>
</html>
