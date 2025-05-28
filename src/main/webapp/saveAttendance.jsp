<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ include file="dbconfig.jsp" %>

<%
    // Get employee ID and status from the form
    int empId = Integer.parseInt(request.getParameter("emp_id"));
    String status = request.getParameter("status");

    // Get today's date
    LocalDate today = LocalDate.now();
    java.sql.Date sqlDate = java.sql.Date.valueOf(today);

    try {
        // Use INSERT ... ON DUPLICATE KEY UPDATE to ensure one record per day per employee
        String sql = "INSERT INTO attendance (emp_id, date, status) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE status = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, empId);
        ps.setDate(2, sqlDate);
        ps.setString(3, status);
        ps.setString(4, status);

        ps.executeUpdate();
        ps.close();
    } catch (Exception e) {
        out.println("Error saving attendance: " + e.getMessage());
    } finally {
        if (con != null) con.close();
    }

    // Redirect back to the attendance page
    response.sendRedirect("attendance.jsp");
%>
