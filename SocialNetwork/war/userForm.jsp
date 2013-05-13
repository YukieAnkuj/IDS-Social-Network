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
	 %>
	 <%
	 List<String> interestList = new ArrayList<String>(Arrays.asList("fashion","movies","music","games"
			 														,"books","sports","tv","science","politics"));

	 %>
	<div id="leftPanel">
	<div class="formClass">
	<h2>Fill the form</h2>

	  <form action="/userForm" method="get">
	    <p>First name:<input type="text" name="firstName"> </p>
	    <p>Last name:<input type="text" name="lastName" > </p>
		
	    <p><br><input type="radio" name="sex" value="male">Male</p>
	    <p><input type="radio" name="sex" value="female">Female</p>

	    <p><br>Choose your interests:</p>
	    	<% for(int i = 0; i < interestList.size(); i++) {
	    		pageContext.setAttribute("interestName", interestList.get(i));
	    	%>
	    		<input type="checkbox" name="interest" value="${fn:escapeXml(interestName)}">${fn:escapeXml(interestName)}<br>
	    	<%
	    		}
	    	%>	    
	    <input type="submit" class="buttonStyle" value="Submit" >
	  </form>

	</div>
	</div> <!-- Closing left Panel -->
	 
	 <div id="rightPanel"></div>
	 	
	<%

%>

<%
    } else {
%>

	<%@include file="partial/login.jsp" %>

<%
    }
%>

<%@include file="partial/footer.jsp" %>	 

</div> <!-- Closing main wrap -->
</div> <!--  main panel -->
  
  </body>
</html>