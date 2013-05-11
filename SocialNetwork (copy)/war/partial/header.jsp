
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
	<div class="header"><p>This is the Header</p>
	 <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	 <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
</div>
</body>
</html>