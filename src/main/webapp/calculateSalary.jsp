<%@ page import="java.sql.*, java.time.LocalDate, java.time.YearMonth" %>
<%@ include file="dbconfig.jsp" %>

<%
    YearMonth currentMonth = YearMonth.now();
    int year = currentMonth.getYear();
    int month = currentMonth.getMonthValue();
    String monthYear = currentMonth.toString();
    int totalDaysInMonth = currentMonth.lengthOfMonth();
    String firstDate = currentMonth.atDay(1).toString();
    String lastDate = currentMonth.atEndOfMonth().toString();

    PreparedStatement ps = con.prepareStatement(
        "SELECT e.emp_id, e.first_name, e.last_name, e.department, e.salary, " +
        "COUNT(a.status) AS days_present " +
        "FROM employees e " +
        "LEFT JOIN attendance a ON e.emp_id = a.emp_id AND a.status = 'Present' AND a.date BETWEEN ? AND ? " +
        "GROUP BY e.emp_id " +
        "ORDER BY e.first_name"
    );
    ps.setString(1, firstDate);
    ps.setString(2, lastDate);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Salary Report | HR Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/calsal.css">
    
</head>
<body>
 <div class="sidebar">
        <!-- Include your sidebar navigation from previous pages -->
        <%@ include file="sidebar.jsp" %>
    </div>
        <div class="main-content">
    
    <div class="container">
        <div class="header">
            <h1>Salary Report</h1>
            <p>For <%= currentMonth.getMonth() %> <%= year %></p>
        </div>
        
        <div class="month-selector">
            <input type="month" id="monthSelect" value="<%= monthYear %>">
            <button onclick="filterByMonth()">
                <i class="fas fa-filter"></i> Filter
            </button>
        </div>
        
        <div class="summary-cards">
            <div class="summary-card">
                <h3>Total Employees</h3>
                <p id="totalEmployees">0</p>
            </div>
            <div class="summary-card">
                <h3>Total Payroll</h3>
                <p id="totalPayroll">0.00</p>
            </div>
            <div class="summary-card">
                <h3>Working Days</h3>
                <p><%= totalDaysInMonth %></p>
            </div>
        </div>
        
        <table class="salary-table">
            <thead>
                <tr>
                    <th>Employee</th>
                    <th>Basic Salary</th>
                    <th>Attendance</th>
                    <th>Per Day</th>
                    <th>Payable</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                int employeeCount = 0;
                double totalPayroll = 0;
                
                while (rs.next()) {
                    employeeCount++;
                    int empId = rs.getInt("emp_id");
                    String firstName = rs.getString("first_name");
                    String lastName = rs.getString("last_name");
                    String department = rs.getString("department");
                    double basicSalary = rs.getDouble("salary");
                    int daysPresent = rs.getInt("days_present");
                    
                    double perDaySalary = basicSalary / totalDaysInMonth;
                    double totalSalary = perDaySalary * daysPresent;
                    totalPayroll += totalSalary;
                    
                    int attendancePercent = (int) Math.round((daysPresent * 100.0) / totalDaysInMonth);
            %>
                <tr>
                    <td>
                        <div class="employee-info">
                            <div class="avatar">
                                <%= firstName.charAt(0) %><%= lastName.charAt(0) %>
                            </div>
                            <div>
                                <div class="name"><%= firstName %> <%= lastName %></div>
                                <div class="department"><%= department %></div>
                            </div>
                        </div>
                    </td>
                    <td class="salary-amount">
                        <%= String.format("%,.2f", basicSalary) %>
                    </td>
                    <td>
                        <div class="attendance-progress">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= attendancePercent %>%"></div>
                            </div>
                            <div class="attendance-count">
                                <%= daysPresent %>/<%= totalDaysInMonth %>
                            </div>
                        </div>
                    </td>
                    <td class="salary-amount">
                        <%= String.format("%,.2f", perDaySalary) %>
                    </td>
                    <td class="salary-amount highlight">
                        <%= String.format("%,.2f", totalSalary) %>
                    </td>
                    <td>
                        <form action="generateSalarySlip.jsp" method="get" target="_blank">
                            <input type="hidden" name="emp_id" value="<%= empId %>">
                            <input type="hidden" name="month_year" value="<%= monthYear %>">
                            <button type="submit" class="action-btn">
                                <i class="fas fa-print"></i> Slip
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                }
                rs.close();
                ps.close();
                con.close();
            %>
            </tbody>
        </table>
    </div>
    </div>
    <script>
        // Update summary counts
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('totalEmployees').textContent = <%= employeeCount %>;
            document.getElementById('totalPayroll').textContent = '$<%= String.format("%,.2f", totalPayroll) %>';
        });
        
        function filterByMonth() {
            const monthValue = document.getElementById('monthSelect').value;
            window.location.href = 'salaryReport.jsp?month=' + monthValue;
        }
    </script>
</body>
</html>