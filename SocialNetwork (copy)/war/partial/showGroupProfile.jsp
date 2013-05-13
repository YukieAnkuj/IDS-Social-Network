<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>


	<div class="groupProfile">
	
	<p>________________________________</p>
	 
	 	<p>Group Profile</p>
	 	<p>${fn:escapeXml(group_name)}</p>
		<p>Description:</p>
		<p>${fn:escapeXml(group_description)}</p>

</body>
</html>