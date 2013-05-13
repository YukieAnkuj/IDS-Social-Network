
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ taglib uri="/WEB-INF/tlds/customTags.tld" prefix="custom"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
  <body>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
    	String loggedUserEmail = user.getEmail();
      	pageContext.setAttribute("user", user);
      	pageContext.setAttribute("loggedUser_email",loggedUserEmail);
      

%>
	<%@include file="partial/header.jsp" %>
	<%@include file="partial/menu.jsp" %>

	
	<% 
	String userProfileEmail; // Email of this userPage
	ServletRequest req = pageContext.getRequest();
	
	if (req.getParameterNames().hasMoreElements()) {
		userProfileEmail = req.getParameter("email");
	}
	else {
		userProfileEmail = loggedUserEmail;
	}
	
	// define the email of this userpage
	pageContext.setAttribute("userProfile_email", userProfileEmail);
	
	
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	
	Key userProfileKey = KeyFactory.createKey("UserProfile", userProfileEmail);
	Key loggedUserKey = KeyFactory.createKey("UserProfile", loggedUserEmail);
	

	 /* -------------------- Specific code ---------------------- */
	 String targetEmail = userProfileEmail;
	 %>

	<div class="form"><h1>Create a group</h1>

	  <form action="/groupForm" method="post">
	    <div>Group name: <input type="text" name="groupName"></div>
	    <div><textarea name="description" rows="3" cols="60" placeholder="Write a description..."></textarea></div>
	    <div><input type="hidden" name="userEmail" value="${fn:escapeXml(loggedUser_email)}"/></div>
	    <div><input type="submit" value="Submit" /></div>
	  </form></div>	
	 	
	 	<!--  
	 			    <form action="/postForm" method="post">
		      <div><textarea name="content" rows="3" cols="60"></textarea></div>
		      <div><input type="submit" value="Post message" /></div>
		      <input type="hidden" name="userNameBoard" value="${fn:escapeXml(userProfile_userName)}"/>
		      <input type="hidden" name="userNamePoster" value="${fn:escapeXml(loggedUser_userName)}"/>
		      <input type="hidden" name="boardEmail" value="${fn:escapeXml(userProfile_email)}"/>
			</form>
	 	-->
	<%

%>

<%
    } else {
%> 	<div class="login">
		<p>Hello!
		<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
	</div>
<%
    }
%>

	 


  
  </body>
</html>