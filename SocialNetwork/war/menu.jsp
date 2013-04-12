
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
  <body>

	<div class="menu"><p>________________________________</p>
	 <p>This is the Menu</p>
	 <a href="userPage.jsp?email=${fn:escapeXml(loggedUser_email)}">Home</a>
	 <a href="searchUsers.jsp">Search people</a>
	 <a href="searchInterest.jsp">Search by similar interest</a>
	 </div>
  
  </body>
</html>
