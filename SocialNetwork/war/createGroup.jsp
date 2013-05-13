
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
<link type="text/css" rel="stylesheet" href="/stylesheets/styles.css" />
<title>Social Network</title>
</head>
  <body>
    <div id="mainWrap">
	<div id="mainPanel">
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
    	String loggedUserEmail = user.getEmail();
      	pageContext.setAttribute("user", user);
      	pageContext.setAttribute("loggedUser_email",loggedUserEmail);
      

%>
	<%@include file="partial/menu.jsp" %>
	<%@include file="partial/header.jsp" %>

	
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
	<div id="leftPanel">
	<div class="formClass"><h2>Create a group</h2>

	  <form action="/groupForm" method="post">
	    <h3>Group name:</h3><input type="text" name="groupName">
	    <textarea name="description" class="textAreaClass" rows="3" cols="60" placeholder="Write a description..."></textarea>
	    <input type="hidden" name="userEmail" value="${fn:escapeXml(loggedUser_email)}"/>
	    <p><br><input type="submit" value="Submit" /></p>
	  </form>
	</div>	

	</div> <!-- End of left Panel -->


<%
    } else {
%> 	
	<div id="leftPanel">
	<%@include file="partial/login.jsp" %>
	</div><!-- End of left panel -->
<%
    }
%>

<div id="rightPanel"></div>

<%@include file="partial/footer.jsp" %>
	 
</div> <!-- Closing main wrap -->
</div> <!--  main panel -->

  
  </body>
</html>