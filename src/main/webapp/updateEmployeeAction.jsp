<%@ include file="dbconfig.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("emp_id");
    String firstName = request.getParameter("first_name");
    String lastName = request.getParameter("last_name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone_number");
    String dept = request.getParameter("department");
    String designation = request.getParameter("designation");
    String hireDate = request.getParameter("hire_date");
    String salary = request.getParameter("salary");

    try {
        PreparedStatement ps = con.prepareStatement(
            "UPDATE employees SET first_name=?, last_name=?, email=?, phone_number=?, department=?, designation=?, hire_date=?, salary=? WHERE emp_id=?"
        );
        ps.setString(1, firstName);
        ps.setString(2, lastName);
        ps.setString(3, email);
        ps.setString(4, phone);
        ps.setString(5, dept);
        ps.setString(6, designation);
        ps.setString(7, hireDate);
        ps.setDouble(8, Double.parseDouble(salary));
        ps.setInt(9, Integer.parseInt(id));

        int result = ps.executeUpdate();
        if (result > 0) {
            response.sendRedirect("employees.jsp");
        } else {
            out.println("Update failed.");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
