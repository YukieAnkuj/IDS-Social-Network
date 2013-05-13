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

	 	<div class="search"><h2>Search users: </h2>
	 	<%
			
	 		Query query = new Query("UserProfile");
	 		List<Entity> users = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
	 		if (users.isEmpty()) {
	 			%>
	 				<p>No users registered</p>
	 			<%
	 		}
	 		else {
	 			%>
 		
 					<table>

 				<%
 				// other user is any user that isn't the one logged in
 				for (Entity otherUserProfile: users) {
 					pageContext.setAttribute("otherUserProfile_firstName", otherUserProfile.getProperty("firstName"));
 					pageContext.setAttribute("otherUserProfile_lastName", otherUserProfile.getProperty("lastName"));
 					pageContext.setAttribute("otherUserProfile_email", otherUserProfile.getProperty("email"));
 	 				if (!otherUserProfile.getKey().toString().equalsIgnoreCase(loggedUserKey.toString())) {
 				%>
 					<tr>
						<td><h3>First name: </h3></td>
						<td><p>${fn:escapeXml(otherUserProfile_firstName)}</p></td>
						<td><h3>Last name:</h3></td>
						<td><p>${fn:escapeXml(otherUserProfile_lastName)}</p></td>
						<td><h3>Email:</h3></td>
						<td><p>${fn:escapeXml(otherUserProfile_email)}</p></td>
				<%
					
				String friendEmail = otherUserProfile.getProperty("email").toString();

					
					Filter targetFriend = new CompositeFilter(CompositeFilterOperator.AND, Arrays.<Filter>asList(
							new FilterPredicate("firstPersonEmail",FilterOperator.EQUAL, loggedUserEmail),
							new FilterPredicate("secondPersonEmail",FilterOperator.EQUAL, friendEmail)));
				
					
					Query queryFriend = new Query("FriendshipRelation").setFilter(targetFriend);	
			
	
					// create the list of entities
				 	List<Entity> friendships = datastore.prepare(queryFriend).asList(FetchOptions.Builder.withLimit(2));
					if (!friendships.isEmpty()) {
						%>
							<td><p>Already a friend</p></td>
							</tr>
 						<%
					}
					else {
						// Allows to request friendship for those that aren't friends
				%>

						<td><p><a href=requestFriendship.jsp?id1=${fn:escapeXml(loggedUser_email)}&id2=${fn:escapeXml(otherUserProfile_email)}>Request Friendship</a></p></td>
					</tr>
 				<%
 					}
 	 				}
 				}
 			%>
 				</table>
 			<%
	 		
    	}
	 	%>
	 	</div>

	</div> <!-- Closing left panel -->
	

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
