<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query.*" %>
<%@ page import="com.google.appengine.api.datastore.Query.Filter" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator" %>
<%@ page import="com.google.appengine.api.datastore.Query.CompositeFilterOperator" %>
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
	
	try {
	 
	 Entity userProfile = datastore.get(userProfileKey);

	 pageContext.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
	 pageContext.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));


	 /* -------------------- Specific code ---------------------- */
	 %>
		<div id="leftPanel">
	 	<div class="search"><h2>Manage groups: </h2>
	 	<%
	
			
	 		Query query = new Query("GroupProfile");
	 		List<Entity> groups = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
	 		if (groups.isEmpty()) {
	 			%>
	 				<h3>No groups registered</h3>
	 			<%
	 		}
	 		else {
	 			%>
 					<table>

 				<%
 				
 				for (Entity groupRelation: groups) {
 					//Filter targetUser = new FilterPredicate("userEmail", FilterOperator.EQUAL, loggedUserEmail);
 					String groupName = groupRelation.getProperty("groupName").toString();
 					String keyString = groupName.concat("&").concat(loggedUserEmail);
	 				Key groupRelationKey = KeyFactory.createKey("GroupRelation", keyString);
	 				pageContext.setAttribute("group_name", groupRelation.getProperty("groupName"));

 					try {
 						// this user is a member is a member
 						Entity testGroupRelation = datastore.get(groupRelationKey);
 						
 		 				%>
 	 					<tr>
 							<td><h3>Group name: </h3></td>
 							<td><p><a href="groupPage.jsp?group=${fn:escapeXml(group_name)}">${fn:escapeXml(group_name)}</a></p></td>
 						
 						</tr>

 						<%
 					}
 					catch (EntityNotFoundException e) {
 						// this user is not a member
						%>
							<!-- <tr><td><p>No groups</p></td></tr> -->
						<%
 					}
	 					
 					
 				}
	 		%></table><br><br><%
    	}
	 	%>
	 	<!-- Show the option to add a group -->
		<p><a href="createGroup.jsp">Create a group</a></p>
		</div>
		
		</div><!--  Close left panel -->
	<%
	
	} catch (EntityNotFoundException e) {
	 // TODO Auto-generated catch block
		 %><div id="leftPanel">
		 	<div class="noProfile">
		 	<h2>You have no profile, please fill the form</h2>
		 	<p><a href="userForm.jsp">User Form</a></p>
		 	</div>
		 	</div> 
		 	<!--  Close left panel -->
		 	
		 <%
	}

%>

<%
    } else {
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
