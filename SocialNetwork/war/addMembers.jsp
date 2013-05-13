
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
	
	String groupName = req.getParameter("group");

	
	// define the email of this userpage
	pageContext.setAttribute("group_name", groupName);
	
	
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	
	Key groupNameKey = KeyFactory.createKey("GroupProfile", groupName);

	try {
	 
	Entity groupProfile = datastore.get(groupNameKey);
	pageContext.setAttribute("group_description", groupProfile.getProperty("description"));
	
	

	%>
		<div id="leftPanel">
		<%@include file="partial/showFriendsListGroupForm.jsp" %>					
  		</div>
	<%
	} catch (EntityNotFoundException e) {
	 // TODO Auto-generated catch block
	 %><div id="leftPanel"><div class="noProfile">
	 	<p>This group doesn't exist</p>
	 	</div>
	 	</div>
	 <%
    } }else {
    	%> 
        <div id=leftPanel></div>
    	<%@include file="partial/login.jsp" %>

    <%
        }
    %>
    


<div id="rightPanel"></div>
<%@include file="partial/footer.jsp" %>	 
</div> <!-- Closing main wrap -->
</div> <!--  main panel -->

  
  </body>
</html>
