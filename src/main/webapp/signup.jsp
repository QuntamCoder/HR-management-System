<%@ page import="java.sql.*" %>
<%
    String message = "";
    if(request.getMethod().equalsIgnoreCase("post")){
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hr_management", "root", "T#9758@qlph");

            // Check if username already exists
            PreparedStatement check = con.prepareStatement("SELECT * FROM hr_users WHERE username = ?");
            check.setString(1, username);
            ResultSet rs = check.executeQuery();
            
            if(rs.next()) {
                message = "Username already exists!";
            } else {
                PreparedStatement ps = con.prepareStatement("INSERT INTO hr_users (username, password) VALUES (?, ?)");
                ps.setString(1, username);
                ps.setString(2, password); // In real app, use password hashing!

                int result = ps.executeUpdate();
                if(result > 0){
                    message = "Signup successful. Please <a href='login.jsp'>login</a>.";
                } else {
                    message = "Signup failed!";
                }
            }
            con.close();
        } catch(Exception e){
            message = "Error: " + e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>HR Portal - Sign Up</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/signup.css">
</head>
<body>
    <div class="signup-container">
        <div class="signup-left">
            <div class="signup-header">
                <h1>Create Account</h1>
                <p>Join our HR management system today</p>
            </div>
            
            <div class="signup-form">
                <form method="post" action="signup.jsp" class="form">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div class="input-group">
                            <i class="fas fa-user"></i>
                            <input type="text" id="username" name="username" placeholder="Choose a username" required>
                        </div>
                    </div>
                    
                    
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Create a password" required>
                            <i class="fas fa-eye toggle-password" onclick="togglePassword()"></i>
                        </div>
                        <div class="password-strength">
                            <div class="strength-meter"></div>
                            <span class="strength-text">Password strength</span>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirm-password">Confirm Password</label>
                        <div class="input-group">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="confirm-password" placeholder="Confirm your password" required>
                        </div>
                    </div>
                    
                    <div class="terms">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a></label>
                    </div>
                    
                    <button type="submit" class="signup-button">Create Account <i class="fas fa-user-plus"></i></button>
                    
                    <% if(!message.isEmpty()) { %>
                        <div class="message <%= message.contains("successful") ? "success-message" : "error-message" %>">
                            <i class="fas <%= message.contains("successful") ? "fa-check-circle" : "fa-exclamation-circle" %>"></i> 
                            <%= message %>
                        </div>
                    <% } %>
                </form>
                
                <div class="login-link">
                    Already have an account? <a href="login.jsp">Log in here</a>
                </div>
            </div>
        </div>
        
        <div class="signup-right">
            <div class="company-branding">
                <img src="images/company-logo.png" alt="Company Logo">
                <h2>HR Management System</h2>
                <p>Join thousands of HR professionals managing their workforce efficiently</p>
            </div>
            
            <div class="benefits">
                <div class="benefit-item">
                    <i class="fas fa-users"></i>
                    <h3>Employee Management</h3>
                    <p>Easily manage your entire workforce</p>
                </div>
                <div class="benefit-item">
                    <i class="fas fa-calendar-alt"></i>
                    <h3>Leave Tracking</h3>
                    <p>Streamline leave requests and approvals</p>
                </div>
                <div class="benefit-item">
                    <i class="fas fa-chart-line"></i>
                    <h3>Powerful Analytics</h3>
                    <p>Get insights into your HR operations</p>
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
        
        // Password strength indicator
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            const meter = document.querySelector('.strength-meter');
            const text = document.querySelector('.strength-text');
            
            // Reset
            meter.style.width = '0%';
            meter.style.backgroundColor = '#ddd';
            text.textContent = 'Password strength';
            
            if (password.length > 0) {
                // Very simple strength calculation (in real app use more robust check)
                let strength = 0;
                if (password.length >= 8) strength += 25;
                if (/[A-Z]/.test(password)) strength += 25;
                if (/[0-9]/.test(password)) strength += 25;
                if (/[^A-Za-z0-9]/.test(password)) strength += 25;
                
                meter.style.width = strength + '%';
                
                if (strength < 50) {
                    meter.style.backgroundColor = '#e74c3c';
                    text.textContent = 'Weak';
                } else if (strength < 75) {
                    meter.style.backgroundColor = '#f39c12';
                    text.textContent = 'Moderate';
                } else {
                    meter.style.backgroundColor = '#2ecc71';
                    text.textContent = 'Strong';
                }
            }
        });
    </script>
</body>
</html>