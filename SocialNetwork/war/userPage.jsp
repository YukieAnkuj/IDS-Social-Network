
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

<html>

  <body>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
    	String loggedUserEmail = user.getEmail();
      	pageContext.setAttribute("user", user);
      	pageContext.setAttribute("loggedUser_email",loggedUserEmail);
      

%>
<div class="header"><p>This is the Header</p>
	 <p>Hello, ${fn:escapeXml(user.nickname)}! (You can
	 <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
</div>
<div class="menu"><p>________________________________</p>
	 <p>This is the Menu</p>
	 <a href="userPage.jsp?email=${fn:escapeXml(loggedUser_email)}">Home</a>
	 <a href="searchUsers.jsp">Search people</a>
	 <a href="">Search groups</a>
	 </div>


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
	 <div class="profile">
	<p>${fn:escapeXml(userProfile_email)}</p>
 	 				
  	
	<p>________________________________</p>
	 
	 	<p>Profile</p>
		<table>
			<tr>
				<td>First name: </td>
				<td>${fn:escapeXml(userProfile_firstName)}</td>
			</tr>
			<tr>
				<td>Last name:</td>
				<td>${fn:escapeXml(userProfile_lastName)}</td>
			</tr>
		</table> 
	</div>
	<div class="friendsList">
		<p>________________________________</p>
	 	<p>Friends</p>
		<table>
			<% 	
				// Looking friendshipRelation entity related to this user
				String targetEmail = userProfileEmail; 
				System.out.println("This email: "+userProfileEmail);
				Filter targetUser = new FilterPredicate("firstPersonEmail", FilterOperator.EQUAL,targetEmail);
				
				Query query = new Query("FriendshipRelation").setFilter(targetUser);
				

				/* create the list of entities*/
			 	List<Entity> friendships = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
				if (friendships.isEmpty()) {
					%>
						<p> No friends</p>
					<%
				}
				else {
	 				for (Entity friendship: friendships) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("friend_id", friendship.getProperty("secondPersonEmail"));
	 	 				
					%>
						<tr>
							<td>Friend email: </td>
							<td><a href="userPage.jsp?email=${fn:escapeXml(friend_id)}">${fn:escapeXml(friend_id)}</a></td>
						</tr>
					<%
	 				}
				}
			%>

		</table> 
		</div>
		
		<div class="editForm">		
			<%
				if (loggedUserEmail.equalsIgnoreCase(userProfileEmail)) {
			%>
		 	<p>________________________________</p>
		 	<a href="userForm.jsp">Change your profile</a>
		 	<%
				}
		 	%>
	 	</div>
	 	
	 	
	 	
	<%
	
	} catch (EntityNotFoundException e) {
	 // TODO Auto-generated catch block
	 %><div class="noProfile">
	 	<p>You have no profile, please fill the form</p>
	 	<a href="userForm.jsp">User Form</a>
	 	</div>
	 <%
	 //e.printStackTrace();
	}

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
