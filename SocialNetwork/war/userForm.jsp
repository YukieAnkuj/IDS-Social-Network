<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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
	<%@include file="header.jsp" %>
	<%@include file="menu.jsp" %>

	
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
	 %>
	 <%
	 List<String> interestList = new ArrayList<String>(Arrays.asList("fashion","movies","music","games"
			 														,"books","sports","tv","science","politics"));

	 %>

	<div class="form"><h1>Fill the form</h1>

	  <form action="/userForm" method="get">
	    <div>First name: <input type="text" name="firstName"></div>
	    <div>Last name: <input type="text" name="lastName" /></div>
	    <div><input type="radio" name="sex" value="male">Male
	    	 <input type="radio" name="sex" value="female">Female</div>
	    <div class="interestForm"><p>Choose your interests:</p> 
	    	<% for(int i = 0; i < interestList.size(); i++) {
	    		pageContext.setAttribute("interestName", interestList.get(i));
	    	%>
	    		<input type="checkbox" name="interest" value=${fn:escapeXml(interestName)}>${fn:escapeXml(interestName)}<br>
	    	<%
	    		}
	    	%>
		</div>
	    <div><input type="submit" value="Submit" /></div>
	  </form></div>	
	 	
	 	
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