<%@ page language="java" import="java.sql.*" %>
<%
    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hr_management", "root", "T#9758@qlph");
        application.setAttribute("dbConnection", con);
    } catch (Exception e) {
        out.println("Database connection error: " + e.getMessage());
    }
%>


<%--
    Connection con = null;
    try {
        // Load Oracle JDBC Driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establish connection to Oracle 10g XE
        // Format: jdbc:oracle:thin:@hostname:port:SID
        con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", "system", "system");

        // Store connection in application scope
        application.setAttribute("dbConnection", con);
        //out.println("Oracle DB connection established successfully.");
    } catch (Exception e) {
        out.println("Database connection error: " + e.getMessage());
    }
--%>
