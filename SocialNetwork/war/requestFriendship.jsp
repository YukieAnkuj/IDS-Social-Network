<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
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
	
	%>
	
	
	<%@include file="partial/menu.jsp" %>
	<%@include file="partial/header.jsp" %>
	
	
	
  	<%

    
	    // Getting info from form
	   	ServletRequest req = pageContext.getRequest();
  	
	    String id1 = req.getParameter("id1");

	    String id2 = req.getParameter("id2");
	    
	    String id3, id4;
	    // id3 is in alphabetical order
	    if (id1.compareTo(id2)<0) {
	    	id3 = id1.concat("&").concat(id2);
	    	id4 = id2.concat("&").concat(id1);
	    }
	    else {
	    	id3 = id2.concat("&").concat(id1);
	    	id4 = id1.concat("&").concat(id2);
	    }
	    
	    
	    System.out.println("id3: = " + id3);
	    
	    
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    Entity friendshipRelation = new Entity("FriendshipRelation", id3);
	    Entity friendshipRelation2 = new Entity("FriendshipRelation", id4);
	    
	    // Defining this entity, alphabetical order
	    friendshipRelation.setProperty("firstPersonEmail", id1);
	    friendshipRelation.setProperty("secondPersonEmail", id2);
	    
	    // Defining the symetric
	    friendshipRelation2.setProperty("firstPersonEmail", id2);
	    friendshipRelation2.setProperty("secondPersonEmail", id1);
	    
	    // Putting the entity in the database
	    datastore.put(friendshipRelation);
	    datastore.put(friendshipRelation2);
	    
  	
  	
  	%>
  <div id="leftPanel">
		<div class="noProfile"><h2>Friendship request sent</h2>
		<p><a href="searchUsers.jsp">Go back</a></p>
		</div>
	</div>
	<div id="rightPanel"></div>	
	
	<%@include file="partial/footer.jsp" %>
	
	</div> <!-- Closing main wrap -->
	</div> <!--  main panel -->
  </body>
</html>