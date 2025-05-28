
<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>

<%
    int employeeCount = 0;
    try {
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM employees");
        if (rs.next()) {
            employeeCount = rs.getInt(1);
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>


<html>
<head>
    <title>HR Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="css/home.css">
</head>
<body>

    <div class="sidebar">
        <!-- Include your sidebar navigation from previous pages -->
        <%@ include file="sidebar.jsp" %>
    </div>


<div class="main-content">
    <div class="header">
        <h1>Dashboard</h1>
        <div class="search-bar">
            <input type="text" placeholder="Search...">
            <button><i class="fas fa-search"></i></button>
        </div>
    </div>
    
    <div class="content">
        <div class="dashboard-cards">
            <div class="card">
                <div class="card-icon" style="background-color: #4e73df;">
                    <i class="fas fa-users"></i>
                </div>
                <h3>Total Employees</h3>
<p class="count"><%= employeeCount %></p>
                <a href="employees.jsp" class="card-link">View all <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="card">
                <div class="card-icon" style="background-color: #1cc88a;">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3>Attendance</h3>
                <p class="count">5 pending</p>
                <a href="attendance.jsp" class="card-link">Review <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="card">
                <div class="card-icon" style="background-color: #f6c23e;">
                    <i class="fas fa-calendar-day"></i>
                </div>
                <h3>Upcoming Events</h3>
                <p class="count">2 meetings</p>
                <a href="#" class="card-link">View calendar <i class="fas fa-arrow-right"></i></a>
            </div>
            
            <div class="card">
                <div class="card-icon" style="background-color: #e74a3b;">
                    <i class="fas fa-bell"></i>
                </div>
                <h3>Notifications</h3>
                <p class="count">3 new</p>
                <a href="#" class="card-link">Check now <i class="fas fa-arrow-right"></i></a>
            </div>
        </div>
        
        <div class="recent-activity">
            <h2>Recent Activity</h2>
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="activity-details">
                        <p>New employee added: Amol Jadhav</p>
                        <span class="activity-time">2 hours ago</span>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="activity-details">
                        <p>Request for extra mark</p>
                        <span class="activity-time">5 hours ago</span>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="fas fa-birthday-cake"></i>
                    </div>
                    <div class="activity-details">
                        <p>please mam</p>
                        <span class="activity-time">1 day ago</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>