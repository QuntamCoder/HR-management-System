<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbconfig.jsp" %>

<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String department = request.getParameter("department");
        String designation = request.getParameter("designation");
        String hireDate = request.getParameter("hire_date");
        String salary = request.getParameter("salary");

        try {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO employees (first_name, last_name, email, phone_number, department, designation, hire_date, salary) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
            );
            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, department);
            ps.setString(6, designation);
            ps.setString(7, hireDate);
            ps.setDouble(8, Double.parseDouble(salary));

            int rows = ps.executeUpdate();
            if (rows > 0) {
                message = "<i class='fas fa-check-circle'></i> Employee added successfully.";
            } else {
                message = "<i class='fas fa-exclamation-circle'></i> Failed to add employee.";
            }
        } catch (Exception e) {
            message = "<i class='fas fa-exclamation-circle'></i> Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add New Employee | HR Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/addemployee.css">
</head>
<body>
    <div class="sidebar">
        <!-- Include your sidebar navigation from previous pages -->
        <%@ include file="sidebar.jsp" %>
    </div>

    <div class="main-content">
        <div class="header">
            <h1><i class="fas fa-user-plus"></i> Add New Employee</h1>
            <div class="breadcrumb">
                <a href="home.jsp">Home</a> / <span>Add Employee</span>
            </div>
        </div>

        <div class="content">
            <form method="post" action="addemployee.jsp" class="employee-form">
                <div class="form-row">
                    <div class="form-group">
                        <label for="first_name"><i class="fas fa-user"></i> First Name</label>
                        <input type="text" id="first_name" name="first_name" placeholder="Enter first name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="last_name"><i class="fas fa-user"></i> Last Name</label>
                        <input type="text" id="last_name" name="last_name" placeholder="Enter last name" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email"><i class="fas fa-envelope"></i> Email</label>
                        <input type="email" id="email" name="email" placeholder="Enter email address" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone_number"><i class="fas fa-phone"></i> Phone Number</label>
                        <input type="tel" id="phone_number" name="phone_number" placeholder="Enter phone number">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="department"><i class="fas fa-building"></i> Department</label>
                        <select id="department" name="department" required>
                            <option value="">Select Department</option>
                            <option value="HR">Human Resources</option>
                            <option value="IT">Information Technology</option>
                            <option value="Finance">Finance</option>
                            <option value="Marketing">Marketing</option>
                            <option value="Operations">Operations</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="designation"><i class="fas fa-briefcase"></i> Designation</label>
                        <input type="text" id="designation" name="designation" placeholder="Enter designation" required>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="hire_date"><i class="fas fa-calendar-alt"></i> Hire Date</label>
                        <input type="date" id="hire_date" name="hire_date" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="salary"><i class="fas fa-dollar-sign"></i> Salary</label>
                        <input type="number" id="salary" name="salary" step="0.01" placeholder="Enter salary" required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-user-plus"></i> Add Employee
                    </button>
                    <button type="reset" class="reset-btn">
                        <i class="fas fa-redo"></i> Reset
                    </button>
                </div>

                <% if(!message.isEmpty()) { %>
                    <div class="message <%= message.contains("successfully") ? "success" : "error" %>">
                        <%= message %>
                    </div>
                <% } %>
            </form>
        </div>
    </div>
</body>
</html>