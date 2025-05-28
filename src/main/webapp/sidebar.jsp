<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("username");
    if (user == null) {
        response.sendRedirect("login.jsp");
    }
%>

<html>
<head>
    <link rel="stylesheet" href="css/home.css">

</head>
<body>
<div class="sidebar">
    <div class="logo">
        <i class="fas fa-users-cog"></i>
        <span>HR Portal</span>
    </div>
    
    <div class="user-profile">
        <div class="avatar">
            <i class="fas fa-user-circle"></i>
        </div>
        <div class="user-info">
            <span class="username"><%= user %></span>
            <span class="role">Administrator</span>
        </div>
    </div>
    
    <ul class="nav-menu">
        <li class="active">
            <a href="home.jsp">
                <i class="fas fa-home"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li>
            <a href="addemployee.jsp">
                <i class="fas fa-user-plus"></i>
                <span>Add Employee</span>
            </a>
        </li>
        <li>
            <a href="employees.jsp">
                <i class="fas fa-users"></i>
                <span>Employee List</span>
            </a>
        </li>
        <li>
            <a href="attendance.jsp">
                <i class="fas fa-calendar-alt"></i>
                <span>Attendance Management</span>
            </a>
        </li>
        <li>
            <a href="reports.jsp">
                <i class="fas fa-chart-bar"></i>
                <span>Reports</span>
            </a>
        </li>
        <li>
            <a href="calculateSalary.jsp">
                <i class="fas fa-cog"></i>
                <span>Salary Management</span>
            </a>
        </li>
    </ul>
    
    <div class="logout">
        <a href="logout.jsp">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</div>

</body>
</html>
