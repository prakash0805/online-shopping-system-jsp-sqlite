<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
String message = "";

if("POST".equalsIgnoreCase(request.getMethod())){
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{
        Class.forName("org.sqlite.JDBC");
        String dbPath = application.getRealPath("/") + "database/shopping.db";
        con = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        Statement stmt = con.createStatement();
        stmt.executeUpdate(
            "CREATE TABLE IF NOT EXISTS users (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT," +
            "name TEXT NOT NULL," +
            "email TEXT UNIQUE NOT NULL," +
            "password TEXT NOT NULL)"
        );

        ps = con.prepareStatement("SELECT * FROM users WHERE email=? AND password=?");
        ps.setString(1, email);
        ps.setString(2, password);
        rs = ps.executeQuery();

        if(rs.next()){
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", rs.getString("name"));
            response.sendRedirect("Home.jsp");
            return;
        }else{
            message = "Invalid Email or Password!";
        }
    }catch(Exception e){
        message = e.getMessage();
    }finally{
        try{ if(rs != null) rs.close(); }catch(Exception e){}
        try{ if(ps != null) ps.close(); }catch(Exception e){}
        try{ if(con != null) con.close(); }catch(Exception e){}
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Login pannu machi</title>

<style>

@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@200;400;500;600;700;800;900&display=swap");

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;

    /* Background image with gradient overlay */
    background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8)),
                url("https://i.pinimg.com/originals/d7/b9/8c/d7b98cc80898e8823455a127945719af.jpg") no-repeat center center;
    background-size: cover;
}

.wrapper {
    width: 420px;
    background: rgba(0, 0, 0, 0.5);   /* dark glass */
    border: 2px solid transparent;
    backdrop-filter: blur(15px);
    border-radius: 16px;
    padding: 30px;
    color: #fff;
    position: relative;
    z-index: 1;
}

/* Neon gradient border glow */
.wrapper::before {
    content: "";
    position: absolute;
    top: -2px; left: -2px; right: -2px; bottom: -2px;
    border-radius: 18px;
    background: linear-gradient(135deg, #ff9a9e, #fad0c4, #fbc2eb, #a6c1ee);
    background-size: 300% 300%;
    animation: glowBorder 6s ease infinite;
    z-index: -1;
}

@keyframes glowBorder {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

.btn {
    width: 100%;
    height: 45px;
    background: #fff;
    border: none;
    border-radius: 40px;
    font-size: 16px;
    font-weight: bold;
    color: #333;
    cursor: pointer;
    position: relative;
    z-index: 1;
    transition: transform 0.2s ease, box-shadow 0.3s ease;
}

/* Pulsing glow behind button */
.btn::before {
    content: "";
    position: absolute;
    top: -5px; left: -5px; right: -5px; bottom: -5px;
    border-radius: 45px;
    background: radial-gradient(circle, rgba(255,255,255,0.6) 0%, transparent 70%);
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: -1;
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(255,255,255,0.6);
}

.btn:hover::before {
    opacity: 1;
    animation: pulseGlow 1.5s infinite;
}

@keyframes pulseGlow {
    0%   { transform: scale(1); opacity: 0.6; }
    50%  { transform: scale(1.2); opacity: 0.9; }
    100% { transform: scale(1); opacity: 0.6; }
}


.wrapper h1 {
    font-size: 30px;
    text-align: center;
    width: 100%;
    margin-bottom: 20px;
}

.wrapper .input-box {
    position: relative;
    height: 50px;
    margin: 30px 0;
}

.input-box input {
    width: 100%;
    height: 100%;
    background: transparent;
    border: 2px solid rgba(255, 255, 255, 0.2);
    border-radius: 48px;
    font-size: 16px;
    padding: 20px 45px 20px 20px;
    color: #fff;
    outline: none;
}

.input-box input::placeholder {
    color: #fff;
}

.input-box i {
    position: absolute;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 22px;
    color: #fff;
}

.remember-forgot {
    display: flex;
    justify-content: space-between;
    font-size: 14px;
    margin: 15px 0;
    color: #fff;
}

.remember-forgot label input {
    accent-color: #fff;
    margin-right: 3px;
}

.remember-forgot a {
    font-size: 14px;
    color: #fff;
    text-decoration: none;
}

.remember-forgot a:hover {
    text-decoration: underline;
}

.btn {
    width: 100%;
    height: 45px;
    background: #fff;
    border: none;
    outline: none;
    border-radius: 40px;
    font-size: 16px;
    font-weight: 600;
    color: #333;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.3s ease;
    position: relative;
    z-index: 1;
}

/* Glow effect behind button */
.btn::before {
    content: "";
    position: absolute;
    top: -5px;
    left: -5px;
    right: -5px;
    bottom: -5px;
    border-radius: 45px;
    background: radial-gradient(circle, rgba(255,255,255,0.6) 0%, transparent 70%);
    opacity: 0;
    transition: opacity 0.3s ease;
    z-index: -1;
}

.btn:hover {
    transform: scale(1.05);
    box-shadow: 0 0 15px rgba(255,255,255,0.6);
}

.btn:hover::before {
    opacity: 1;
    animation: pulseGlow 1.5s infinite;
}

@keyframes pulseGlow {
    0%   { transform: scale(1); opacity: 0.6; }
    50%  { transform: scale(1.2); opacity: 0.9; }
    100% { transform: scale(1); opacity: 0.6; }
}


.register-link {
    text-align: center;
    margin: 20px 0 15px;
}

.register-link p {
    color: #fff;
    font-size: 14px;
}

.register-link a {
    color: #fff;
    text-decoration: none;
    font-weight: 600;
}

.register-link a:hover {
    text-decoration: underline;
}



</style>
</head>

<body>
<div class="wrapper">
    <form method="post">
        <h1>User Login</h1>

        <% if(!message.equals("")){ %>
            <div class="msg"><%= message %></div>
        <% } %>

        <div class="input-box">
            <input type="email" name="email" placeholder="Enter Email" required>
        </div>

        <div class="input-box">
            <input type="password" name="password" placeholder="Enter Password" required>
        </div>

        <div class="remember-forgot">
            <label><input type="checkbox"> Remember me</label>
            <a href="#">Forgot password?</a>
        </div>

        <button type="submit" class="btn">Login</button>

        <div class="register-link">
            Don't have an account? <a href="Register.jsp">Register</a>
        </div>
    </form>
</div>
</body>
</html>
