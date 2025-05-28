<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<%
    String id = request.getParameter("id");
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        ps = con.prepareStatement("SELECT * FROM employees WHERE emp_id=?");
        ps.setInt(1, Integer.parseInt(id));
        rs = ps.executeQuery();
        if (!rs.next()) {
            response.sendRedirect("error.jsp?msg=Employee not found");
            return;
        }
%>

<html>
<head>
    <title>Update Employee</title>
    <link rel="stylesheet" href="css/addemployee.css">
</head>
<body>

<div class="sidebar">
    <%@ include file="sidebar.jsp" %>
</div>
<div class="main-content">
    <div class="header">
        <h1><i class="fas fa-user-edit"></i> Update Employee</h1>
        <div class="breadcrumb">
            <a href="home.jsp">Home</a> / <span>Update Employee</span>
        </div>
    </div>

    <div class="content">
        <form method="post" action="updateEmployeeAction.jsp" class="employee-form">
            <input type="hidden" name="emp_id" value="<%= rs.getInt("emp_id") %>" />
            
            <div class="form-row">
                <div class="form-group">
                    <label for="first_name"><i class="fas fa-user"></i> First Name</label>
                    <input type="text" id="first_name" name="first_name" value="<%= rs.getString("first_name") %>" required>
                </div>
                
                <div class="form-group">
                    <label for="last_name"><i class="fas fa-user"></i> Last Name</label>
                    <input type="text" id="last_name" name="last_name" value="<%= rs.getString("last_name") %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" id="email" name="email" value="<%= rs.getString("email") %>" required>
                </div>
                
                <div class="form-group">
                    <label for="phone_number"><i class="fas fa-phone"></i> Phone Number</label>
                    <input type="tel" id="phone_number" name="phone_number" value="<%= rs.getString("phone_number") %>">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="department"><i class="fas fa-building"></i> Department</label>
                    <select id="department" name="department" required>
                        <option value="">Select Department</option>
                        <option value="HR" <%= rs.getString("department").equals("HR") ? "selected" : "" %>>Human Resources</option>
                        <option value="IT" <%= rs.getString("department").equals("IT") ? "selected" : "" %>>Information Technology</option>
                        <option value="Finance" <%= rs.getString("department").equals("Finance") ? "selected" : "" %>>Finance</option>
                        <option value="Marketing" <%= rs.getString("department").equals("Marketing") ? "selected" : "" %>>Marketing</option>
                        <option value="Operations" <%= rs.getString("department").equals("Operations") ? "selected" : "" %>>Operations</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="designation"><i class="fas fa-briefcase"></i> Designation</label>
                    <input type="text" id="designation" name="designation" value="<%= rs.getString("designation") %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="hire_date"><i class="fas fa-calendar-alt"></i> Hire Date</label>
                    <input type="date" id="hire_date" name="hire_date" value="<%= rs.getDate("hire_date") %>" required>
                </div>
                
                <div class="form-group">
                    <label for="salary"><i class="fas fa-dollar-sign"></i> Salary</label>
                    <input type="number" id="salary" name="salary" value="<%= rs.getDouble("salary") %>" required>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="submit-btn">
                    <i class="fas fa-user-edit"></i> Update Employee
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (ps != null) try { ps.close(); } catch (SQLException e) {}
    }
%>