<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%
String msg = "";

if("POST".equalsIgnoreCase(request.getMethod())){

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // simple hardcoded admin login
    if(username.equals("admin") && password.equals("admin123")){

        session.setAttribute("admin", username);
        response.sendRedirect("AdminDashboard.jsp");
        return;

    } else {
        msg = "Invalid Admin Credentials!";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login</title>

<style>

body{
    margin:0;
    height:100vh;
    display:flex;
    justify-content:center;
    align-items:center;
    background:#2c3e50;
    font-family:Arial;
}

.box{
    width:350px;
    padding:30px;
    background:white;
    border-radius:12px;
    text-align:center;
}

input{
    width:100%;
    padding:10px;
    margin:10px 0;
}

button{
    width:100%;
    padding:10px;
    background:#27ae60;
    color:white;
    border:none;
    cursor:pointer;
}

.msg{
    color:red;
    margin-bottom:10px;
}

</style>

</head>

<body>

<div class="box">

    <h2>Admin Login</h2>

    <% if(!msg.equals("")) { %>
        <div class="msg"><%= msg %></div>
    <% } %>

    <form method="post">

        <input type="text" name="username" placeholder="Admin Username" required>

        <input type="password" name="password" placeholder="Password" required>

        <button type="submit">Login</button>

    </form>

</div>

</body>
</html>
```
