<%@ page import="java.sql.*" %>
<%
    String error = "";
    if(request.getMethod().equalsIgnoreCase("post")){
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hr_management", "root", "T#9758@qlph");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM hr_users WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                session.setAttribute("username", username);
                response.sendRedirect("home.jsp");
            } else {
                error = "Invalid username or password!";
            }
            con.close();
        } catch(Exception e){
            error = "Error: " + e.getMessage();
        }
    }
%>
<html>
<head>
    <title>HR Portal - Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        <%@ include file="css/login.css" %>
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-left">
            <div class="login-header">
                <h1>Welcome back!</h1>
                <p>Please login to access your HR dashboard</p>
            </div>
            
            <div class="login-form">
                <form method="post" action="login.jsp" class="form">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Enter your username" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
                        </div>
                    </div>
                    
                    <div class="form-options">
                        <div class="remember-me">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Remember me</label>
                        </div>
                        <a href="forgot-password.jsp" class="forgot-password">Forgot password?</a>
                    </div>
                    
                    <button type="submit" class="login-button">Login <i class="fas fa-arrow-right"></i></button>
                    
                    <% if(error != null) { %>
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i> <%= error %>
                        </div>
                    <% } %>
                </form>
                
                <div class="signup-link">
                    Don't have an account? <a href="signup.jsp">Sign up here</a>
                </div>
            </div>
        </div>
        
        <div class="login-right">
            <div class="company-branding">
                <img src="images/company-logo.png" alt="Company Logo">
                <h2>HR Management System</h2>
                <p>Streamline your HR processes with our comprehensive solution</p>
            </div>
            
            <div class="social-login">
                <p>Or login with</p>
                <div class="social-icons">
                    <a href="#" class="social-icon google"><i class="fab fa-google"></i></a>
                    <a href="#" class="social-icon microsoft"><i class="fab fa-microsoft"></i></a>
                    <a href="#" class="social-icon linkedin"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            const password = document.getElementById('password');
            const icon = document.querySelector('.toggle-password');
            if (password.type === 'password') {
                password.type = 'text';
                icon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                password.type = 'password';
                icon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }
    </script>
</body>
</html>