<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">
<%
    // Clear all session data
    session.invalidate();

    // Redirect to home page after logout
    response.sendRedirect("Home.jsp");
%>
```
