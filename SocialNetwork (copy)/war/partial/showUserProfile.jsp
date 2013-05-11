<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
	<div class="profile">
	
	<p>________________________________</p>
	 
	 	<p>NEW Profile</p>
	 	<p>${fn:escapeXml(userProfile_email)}</p>
		<table>
			<tr>
				<td>First name: </td>
				<td>${fn:escapeXml(userProfile_firstName)}</td>
			</tr>
			<tr>
				<td>Last name:</td>
				<td>${fn:escapeXml(userProfile_lastName)}</td>
			</tr>
			<tr>
				<td>UserName:</td>
				<td>${fn:escapeXml(userProfile_userName)}</td>
			</tr>
		</table>

</body>
</html>