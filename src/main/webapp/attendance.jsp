<%@ page import="java.time.LocalDate" %>
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Attendance Management | HR Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/attendance.css">
</head>
<body>
    <div class="sidebar">
        <%@ include file="sidebar.jsp" %>
    </div>

    <div class="main-content">
        <div class="header">
            <h1><i class="fas fa-calendar-check"></i> Daily Attendance</h1>
            <div class="breadcrumb">
                <a href="home.jsp">Home</a> / <span>Attendance</span>
            </div>
            <div class="date-filter">
                <form method="get" action="attendance.jsp">
                    <label for="date"><i class="fas fa-calendar-alt"></i> Select Date:</label>
                    <input type="date" id="date" name="date" value="<%= LocalDate.now().toString() %>">
                    <button type="submit" class="filter-btn"><i class="fas fa-filter"></i> Filter</button>
                </form>
            </div>
        </div>

        <div class="content">
            <div class="card">
                <div class="card-header">
                    <h2>Today's Attendance (<%= LocalDate.now().toString() %>)</h2>
                    <div class="attendance-summary">
                        <div class="summary-item present">
                            <i class="fas fa-user-check"></i>
                            <span id="presentCount">0</span> Present
                        </div>
                        <div class="summary-item absent">
                            <i class="fas fa-user-times"></i>
                            <span id="absentCount">0</span> Absent
                        </div>
                        <div class="summary-item total">
                            <i class="fas fa-users"></i>
                            <span id="totalCount">0</span> Total
                        </div>
                    </div>
                </div>

                <div class="table-container">
                    <table class="attendance-table">
                        <thead>
                            <tr>
                                <th>Employee ID</th>
                                <th>Employee Name</th>
                                <th>Department</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            LocalDate selectedDate = request.getParameter("date") != null ? 
                                LocalDate.parse(request.getParameter("date")) : LocalDate.now();
                            String dateStr = selectedDate.toString();

                            Statement stmtEmp = con.createStatement();
                            ResultSet rsEmp = stmtEmp.executeQuery(
                                "SELECT e.emp_id, e.first_name, e.last_name, e.department " +
                                "FROM employees e ORDER BY e.first_name"
                            );

                            PreparedStatement psCheck = con.prepareStatement(
                                "SELECT status FROM attendance WHERE emp_id = ? AND date = ?"
                            );

                            int presentCount = 0;
                            int absentCount = 0;
                            int totalCount = 0;

                            while (rsEmp.next()) {
                                totalCount++;
                                int empId = rsEmp.getInt("emp_id");
                                String fullName = rsEmp.getString("first_name") + " " + rsEmp.getString("last_name");
                                String department = rsEmp.getString("department");

                                psCheck.setInt(1, empId);
                                psCheck.setString(2, dateStr);
                                ResultSet rsCheck = psCheck.executeQuery();

                                String status = null;
                                if (rsCheck.next()) {
                                    status = rsCheck.getString("status");
                                    if ("Present".equals(status)) presentCount++;
                                    else if ("Absent".equals(status)) absentCount++;
                                }
                        %>
                            <tr>
                                <td><%= empId %></td>
                                <td>
                                    <div class="employee-info">
                                        <div class="avatar">
                                            <%= rsEmp.getString("first_name").charAt(0) %><%= rsEmp.getString("last_name").charAt(0) %>
                                        </div>
                                        <div class="name"><%= fullName %></div>
                                    </div>
                                </td>
                                <td>
                                    <span class="department <%= department != null ? department.toLowerCase() : "" %>">
                                        <%= department %>
                                    </span>
                                </td>
                                <td class="status-cell">
                                    <% if (status != null) { %>
                                        <span class="status <%= status.toLowerCase() %>">
                                            <i class="fas <%= "Present".equals(status) ? "fa-check-circle" : "fa-times-circle" %>"></i>
                                            <%= status %>
                                        </span>
                                    <% } else { %>
                                        <span class="status pending">
                                            <i class="fas fa-clock"></i>
                                            Pending
                                        </span>
                                    <% } %>
                                </td>
                                <td class="actions-cell">
                                    <% if (status == null) { %>
                                        <form method="post" action="saveAttendance.jsp" class="attendance-form">
                                            <input type="hidden" name="emp_id" value="<%= empId %>">
                                            <input type="hidden" name="date" value="<%= dateStr %>">
                                            <button type="submit" name="status" value="Present" class="present-btn">
                                                <i class="fas fa-check"></i> Present
                                            </button>
                                            <button type="submit" name="status" value="Absent" class="absent-btn">
                                                <i class="fas fa-times"></i> Absent
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <form method="post" action="updateAttendance.jsp" class="attendance-form">
                                            <input type="hidden" name="emp_id" value="<%= empId %>">
                                            <input type="hidden" name="date" value="<%= dateStr %>">
                                            <button type="submit" name="status" value="Present" class="present-btn <%= "Present".equals(status) ? "active" : "" %>">
                                                <i class="fas fa-check"></i> Present
                                            </button>
                                            <button type="submit" name="status" value="Absent" class="absent-btn <%= "Absent".equals(status) ? "active" : "" %>">
                                                <i class="fas fa-times"></i> Absent
                                            </button>
                                        </form>
                                    <% } %>
                                </td>
                            </tr>
                        <%
                                rsCheck.close();
                            }
                            rsEmp.close();
                            psCheck.close();
                            stmtEmp.close();
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Update summary counts
        document.addEventListener('DOMContentLoaded', function() {
            const presentCount = <%= presentCount %>;
            const absentCount = <%= absentCount %>;
            const totalCount = <%= totalCount %>;
            
            document.getElementById('presentCount').textContent = presentCount;
            document.getElementById('absentCount').textContent = absentCount;
            document.getElementById('totalCount').textContent = totalCount;
            
            // Add confirmation for absent marks
            const absentButtons = document.querySelectorAll('.absent-btn');
            absentButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    if (!confirm('Mark this employee as absent?')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>