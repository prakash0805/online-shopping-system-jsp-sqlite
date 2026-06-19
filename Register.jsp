<%@ page import="java.sql.*" %>

<%
String message = "";

if("POST".equalsIgnoreCase(request.getMethod())){
    String name = request.getParameter("name");
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

        ps = con.prepareStatement("SELECT * FROM users WHERE email=?");
        ps.setString(1, email);
        rs = ps.executeQuery();

        if(rs.next()){
            message = "Email already registered!";
        }else{
            ps.close();
            ps = con.prepareStatement("INSERT INTO users(name,email,password) VALUES(?,?,?)");
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, password);

            int i = ps.executeUpdate();
            if(i > 0){
                message = "Registration Successful!";
            }else{
                message = "Registration Failed!";
            }
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
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<link rel="stylesheet" href="css/style.css">

<style>
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
    background: linear-gradient(135deg, rgba(235, 21, 189, 0.6), rgba(0,0,0,0.8)),
                url("https://i.pinimg.com/originals/d7/b9/8c/d7b98cc80898e8823455a127945719af.jpg") no-repeat center center;
    background-size: cover;
}

.wrapper {
    width: 420px;
    background: rgba(0, 0, 0, 0.5);
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

.wrapper h2 {
    font-size: 28px;
    text-align: center;
    margin-bottom: 20px;
}

.input-box {
    position: relative;
    height: 50px;
    margin: 20px 0;
}

.input-box input {
    width: 100%;
    height: 100%;
    background: transparent;
    border: 2px solid rgba(255, 255, 255, 0.2);
    border-radius: 48px;
    font-size: 16px;
    padding: 0 45px 0 20px;
    color: #fff;
    outline: none;
}

.input-box input::placeholder {
    color: #fff;
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

.msg {
    text-align: center;
    margin-bottom: 15px;
    color: #ff4d4d;
    font-weight: bold;
}

.login-link {
    text-align: center;
    margin: 20px 0 15px;
    color: #fff;
}

.login-link a {
    color: #ffeaa7;
    text-decoration: none;
    font-weight: 600;
}

.login-link a:hover {
    text-decoration: underline;
}
</style>
</head>

<body>
<div class="wrapper">
    <h2>User Registration</h2>

    <% if(!message.equals("")){ %>
        <div class="msg"><%= message %></div>
    <% } %>

    <form method="post">
        

        <div class="input-box">
            <input type="email" name="email" placeholder="Enter Email" required>
        </div>

        <div class="input-box">
            <input type="password" name="password" placeholder="Enter Password" required>
        </div>

        <button type="submit" class="btn">Register</button>
    </form>

    <div class="login-link">
        Already have an account? <a href="Login.jsp">Login</a>
    </div>
</div>
</body>
</html>
