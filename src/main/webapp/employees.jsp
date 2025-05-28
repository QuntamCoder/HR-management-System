<%@ page import="java.sql.*" %>
<%@ include file="dbconfig.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Employee List | HR Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/employees.css">
</head>
<body>
    <div class="sidebar">
        <!-- Include your sidebar navigation from previous pages -->
        <%@ include file="sidebar.jsp" %>
    </div>

    <div class="main-content">
        <div class="header">
            <h1><i class="fas fa-users"></i> Employee Management</h1>
            <div class="breadcrumb">
                <a href="home.jsp">Home</a> / <span>Employees</span>
            </div>
            <div class="actions">
                <a href="addemployee.jsp" class="add-btn">
                    <i class="fas fa-user-plus"></i> Add Employee
                </a>
            </div>
        </div>

        <div class="content">
            <div class="card">
                <div class="card-header">
                    <h2>Employee List</h2>
                    <div class="search-filter">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Search employees...">
                        </div>
                        <select id="departmentFilter">
                            <option value="">All Departments</option>
                            <option value="HR">HR</option>
                            <option value="IT">IT</option>
                            <option value="Finance">Finance</option>
                            <option value="Marketing">Marketing</option>
                        </select>
                    </div>
                </div>

                <div class="table-container">
                    <table id="employeeTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Department</th>
                                <th>Designation</th>
                                <th>Hire Date</th>
                                <th>Salary</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                            try {
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT * FROM employees ORDER BY emp_id DESC");

                                while(rs.next()) {
                        %>
                            <tr>
                                <td><%= rs.getInt("emp_id") %></td>
                                <td>
                                    <div class="employee-info">
                                        <div class="avatar">
                                            <%= rs.getString("first_name").charAt(0) %><%= rs.getString("last_name").charAt(0) %>
                                        </div>
                                        <div>
                                            <div class="name"><%= rs.getString("first_name") %> <%= rs.getString("last_name") %></div>
                                            <div class="phone"><%= rs.getString("phone_number") %></div>
                                        </div>
                                    </div>
                                </td>
                                <td><%= rs.getString("email") %></td>
                                <td>
                                    <span class="department <%= rs.getString("department").toLowerCase() %>">
                                        <%= rs.getString("department") %>
                                    </span>
                                </td>
                                <td><%= rs.getString("designation") %></td>
                                <td><%= rs.getDate("hire_date") %></td>
                                <td>$<%= String.format("%,.2f", rs.getDouble("salary")) %></td>
                                <td>
                                    <div class="action-buttons">
                                        <a href="updateEmployee.jsp?id=<%= rs.getInt("emp_id") %>" class="edit-btn" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="deleteEmployee.jsp?id=<%= rs.getInt("emp_id") %>" class="delete-btn" title="Delete" onclick="return confirm('Are you sure you want to delete this employee?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                        <a href="employeeDetails.jsp?id=<%= rs.getInt("emp_id") %>" class="view-btn" title="View">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%
                                }
                            } catch(Exception e) {
                                out.println("<tr><td colspan='8' class='error'>Error: " + e.getMessage() + "</td></tr>");
                            }
                        %>
                        </tbody>
                    </table>
                </div>

                <div class="table-footer">
                    <div class="table-info">
                        Showing <span id="showingCount">0</span> of <span id="totalCount">0</span> employees
                    </div>
                    <div class="pagination">
                        <button id="prevBtn" disabled><i class="fas fa-chevron-left"></i></button>
                        <span id="pageInfo">Page 1</span>
                        <button id="nextBtn"><i class="fas fa-chevron-right"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Simple table filtering and pagination
        document.addEventListener('DOMContentLoaded', function() {
            const table = document.getElementById('employeeTable');
            const rows = table.querySelectorAll('tbody tr');
            const searchInput = document.getElementById('searchInput');
            const departmentFilter = document.getElementById('departmentFilter');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            const pageInfo = document.getElementById('pageInfo');
            const showingCount = document.getElementById('showingCount');
            const totalCount = document.getElementById('totalCount');
            
            let currentPage = 1;
            const rowsPerPage = 10;
            let filteredRows = Array.from(rows);
            
            // Initialize counts
            totalCount.textContent = rows.length;
            updateShowingCount();
            
            // Filter function
            function filterTable() {
                const searchTerm = searchInput.value.toLowerCase();
                const department = departmentFilter.value.toLowerCase();
                
                filteredRows = Array.from(rows).filter(row => {
                    const name = row.cells[1].textContent.toLowerCase();
                    const email = row.cells[2].textContent.toLowerCase();
                    const rowDepartment = row.cells[3].textContent.toLowerCase();
                    
                    const matchesSearch = name.includes(searchTerm) || email.includes(searchTerm);
                    const matchesDepartment = department === '' || rowDepartment.includes(department);
                    
                    return matchesSearch && matchesDepartment;
                });
                
                currentPage = 1;
                renderTable();
            }
            
            // Pagination
            function renderTable() {
                const start = (currentPage - 1) * rowsPerPage;
                const end = start + rowsPerPage;
                const paginatedRows = filteredRows.slice(start, end);
                
                // Hide all rows
                rows.forEach(row => row.style.display = 'none');
                
                // Show filtered rows
                paginatedRows.forEach(row => row.style.display = '');
                
                // Update pagination controls
                prevBtn.disabled = currentPage === 1;
                nextBtn.disabled = end >= filteredRows.length;
                pageInfo.textContent = `Page ${currentPage}`;
                
                // Update counts
                totalCount.textContent = filteredRows.length;
                updateShowingCount();
            }
            
            function updateShowingCount() {
                const start = (currentPage - 1) * rowsPerPage + 1;
                const end = Math.min(start + rowsPerPage - 1, filteredRows.length);
                showingCount.textContent = filteredRows.length > 0 ? `${start}-${end}` : '0';
            }
            
            // Event listeners
            searchInput.addEventListener('input', filterTable);
            departmentFilter.addEventListener('change', filterTable);
            
            prevBtn.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    renderTable();
                }
            });
            
            nextBtn.addEventListener('click', () => {
                if ((currentPage * rowsPerPage) < filteredRows.length) {
                    currentPage++;
                    renderTable();
                }
            });
            
            // Initial render
            renderTable();
        });
    </script>
</body>
</html>