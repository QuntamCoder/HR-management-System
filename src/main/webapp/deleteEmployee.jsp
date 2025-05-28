<%@ include file="dbconfig.jsp" %>
<%
    String id = request.getParameter("id");

    try {
        PreparedStatement ps = con.prepareStatement("DELETE FROM employees WHERE emp_id=?");
        ps.setInt(1, Integer.parseInt(id));
        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("employees.jsp");
        } else {
            out.println("Delete failed.");
        }
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
