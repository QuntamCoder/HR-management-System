<%@ page import="java.sql.*, java.time.YearMonth" %>
<%@ include file="dbconfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Salary Slip | HR Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/salarySlip.css">
</head>
<body>
<div class="sidebar">
        <%@ include file="sidebar.jsp" %>
    </div>
        <div class="main-content">
        <div class="payslip-container">
        <%
            String empIdParam = request.getParameter("emp_id");
            String monthYear = request.getParameter("month_year");
            
            if (empIdParam == null || monthYear == null) {
        %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <h3>Invalid employee ID or month</h3>
            <p>Please provide valid employee ID and month to generate salary slip</p>
        </div>
        <%
            } else {
                int empId = Integer.parseInt(empIdParam);
                YearMonth ym = YearMonth.parse(monthYear);
                String firstDate = ym.atDay(1).toString();
                String lastDate = ym.atEndOfMonth().toString();
                int totalDaysInMonth = ym.lengthOfMonth();

                PreparedStatement ps = con.prepareStatement(
                    "SELECT e.first_name, e.last_name, e.department, e.designation, e.salary, " +
                    "(SELECT COUNT(*) FROM attendance a WHERE a.emp_id = e.emp_id AND a.status = 'Present' " +
                    "AND a.date BETWEEN ? AND ?) AS days_present " +
                    "FROM employees e WHERE e.emp_id = ?"
                );
                ps.setString(1, firstDate);
                ps.setString(2, lastDate);
                ps.setInt(3, empId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String fullName = rs.getString("first_name") + " " + rs.getString("last_name");
                    String department = rs.getString("department");
                    String designation = rs.getString("designation");
                    double basicSalary = rs.getDouble("salary");
                    int daysPresent = rs.getInt("days_present");
                    double perDaySalary = basicSalary / totalDaysInMonth;
                    double totalSalary = perDaySalary * daysPresent;
                    java.sql.Date generatedOn = new java.sql.Date(System.currentTimeMillis());
        %>
        <div class="payslip-header">
            <div class="company-logo">
                <img src="images/company-logo.png" alt="Company Logo">
            </div>
            <div class="company-info">
                <h1>Your Company Name</h1>
                <p>123 Business Park, City - 100001</p>
                <p>PAN: ABCDE1234F | GSTIN: 12ABCDE3456F7Z8</p>
            </div>
        </div>

        <div class="payslip-title">
            <h2>Salary Slip for <%= ym.getMonth() %> <%= ym.getYear() %></h2>
            <div class="payslip-number">
                <span>Payslip #: <%= String.format("PS%03d%02d%04d", empId, 
                      ym.getMonthValue(), ym.getYear()) %></span>
            </div>
        </div>

        <div class="employee-details">
            <div class="detail-section">
                <h3>Employee Information</h3>
                <div class="detail-grid">
                    <div class="detail-item">
                        <span class="detail-label">Employee ID:</span>
                        <span class="detail-value"><%= empId %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Name:</span>
                        <span class="detail-value"><%= fullName %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Department:</span>
                        <span class="detail-value"><%= department %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Designation:</span>
                        <span class="detail-value"><%= designation %></span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">Bank Account:</span>
                        <span class="detail-value">XXXXXX7890 (HDFC Bank)</span>
                    </div>
                </div>
            </div>
            
            <div class="attendance-section">
                <h3>Attendance Summary</h3>
                <div class="attendance-grid">
                    <div class="attendance-item">
                        <span class="attendance-label">Working Days:</span>
                        <span class="attendance-value"><%= totalDaysInMonth %></span>
                    </div>
                    <div class="attendance-item">
                        <span class="attendance-label">Days Present:</span>
                        <span class="attendance-value"><%= daysPresent %></span>
                    </div>
                    <div class="attendance-item">
                        <span class="attendance-label">Days Absent:</span>
                        <span class="attendance-value"><%= totalDaysInMonth - daysPresent %></span>
                    </div>
                    <div class="attendance-progress">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: <%= (daysPresent * 100) / totalDaysInMonth %>%"></div>
                        </div>
                        <span class="progress-text"><%= String.format("%.0f", (daysPresent * 100.0) / totalDaysInMonth) %>% Attendance</span>
                    </div>
                </div>
            </div>
        </div>

        <div class="salary-breakdown">
            <div class="earnings">
                <h3>Earnings</h3>
                <table class="earnings-table">
                    <tr>
                        <td>Basic Salary</td>
                        <td><%= String.format("%,.2f", basicSalary) %></td>
                    </tr>
                    <tr class="total">
                        <td><strong>Gross Earnings</strong></td>
                        <td><strong><%= String.format("%,.2f", basicSalary) %></strong></td>
                    </tr>
                </table>
            </div>
            
            <div class="deductions">
                <h3>Deductions</h3>
                <table class="deductions-table">
                    <tr>
                        <td>Leave Deductions</td>
                        <td><%= String.format("%,.2f", (totalDaysInMonth - daysPresent) * perDaySalary) %></td>
                    </tr>
                    <tr class="total">
                        <td><strong>Total Deductions</strong></td>
                        <td><strong><%= String.format("%,.2f", (totalDaysInMonth - daysPresent) * perDaySalary) %></strong></td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="net-salary">
            <div class="net-amount">
                <span class="net-label">Net Salary Payable:</span>
                <span class="net-value"><%= String.format("%,.2f", totalSalary) %></span>
            </div>
            <div class="payment-method">
                <span class="method-label">Payment Mode:</span>
                <span class="method-value">Bank Transfer</span>
            </div>
        </div>

        <div class="payslip-footer">
            <div class="generated-info">
                <p>Generated on: <%= generatedOn %></p>
                <p>This is a system generated document and does not require signature</p>
            </div>
            <div class="company-stamp">
                <div class="stamp-placeholder">
                    <span>For Your Company Name</span>
                </div>
            </div>
        </div>

        <div class="action-buttons">
            <button onclick="window.print()" class="print-btn">
                <i class="fas fa-print"></i> Print Payslip
            </button>
            <button onclick="downloadPDF()" class="download-btn">
                <i class="fas fa-download"></i> Download PDF
            </button>
        </div>
        <%
                } else {
        %>
        <div class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <h3>Employee not found</h3>
            <p>No employee record found for ID <%= empId %></p>
        </div>
        <%
                }
                rs.close();
                ps.close();
                con.close();
            }
        %>
    </div></div>

    <script>
        function downloadPDF() {
            // In a real implementation, this would generate/download a PDF
            alert("PDF download functionality would be implemented here");
        }
    </script>
</body>
</html>