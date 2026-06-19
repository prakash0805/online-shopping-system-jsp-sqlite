<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%@ page import="java.sql.*" %>

<%
String admin = (String)session.getAttribute("admin");

if(admin == null){
    response.sendRedirect("AdminLogin.jsp");
    return;
}

String id = request.getParameter("id");

if(id == null){
    response.sendRedirect("ViewProducts.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;

try{

    Class.forName("org.sqlite.JDBC");

    String dbPath = application.getRealPath("/") +
                    "database/shopping.db";

    con = DriverManager.getConnection(
            "jdbc:sqlite:" + dbPath);

    ps = con.prepareStatement(
        "DELETE FROM products WHERE id=?"
    );

    ps.setInt(1, Integer.parseInt(id));

    ps.executeUpdate();

    ps.close();

    response.sendRedirect("ViewProducts.jsp");

}catch(Exception e){

    out.println(
        "<h3 style='color:red;text-align:center;'>"
        + e.getMessage() +
        "</h3>"
    );

}finally{

    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>
```
