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
	
	try {
	 
	 Entity userProfile = datastore.get(userProfileKey);

	 pageContext.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
	 pageContext.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));


	 /* -------------------- Specific code ---------------------- */
	 %>
	 <div class="searchInterest"><p>Search interests:</p>
	 	<%
	 		Filter targetUserInterest = new FilterPredicate("userEmail", FilterOperator.EQUAL, loggedUserEmail);
	 		Query queryInterest = new Query("InterestRelation").setFilter(targetUserInterest);
	 		List<Entity> interests = datastore.prepare(queryInterest).asList(FetchOptions.Builder.withLimit(20));
			if (interests.isEmpty()) {
				%>
					<p> No interests</p>
				<%
			}
			else {
				%>
				<table>
				<%
 				for (Entity interest: interests) {
 					// Get the friend's email to print it later
 					String interestName = interest.getProperty("interestName").toString();
 					pageContext.setAttribute("interestName", interestName);
 	 				
				%>
					<tr>
						<td>${fn:escapeXml(interestName)}:</td>
					</tr>
				<%
					// Create a new filter/query to find the users with same interest
					Filter otherUserInterest = new CompositeFilter(CompositeFilterOperator.AND, Arrays.<Filter>asList(
													new FilterPredicate("interestName", FilterOperator.EQUAL, interestName),
													new FilterPredicate("userEmail", FilterOperator.NOT_EQUAL,loggedUserEmail)));
		 			Query queryOtherUserInterest = new Query ("InterestRelation").setFilter(otherUserInterest);
		 			
		 			// create the list of entities with same interest
				 	List<Entity> sameInterestRelations = datastore.prepare(queryOtherUserInterest).asList(FetchOptions.Builder.withLimit(20));
				 	for (Entity interestRelation: sameInterestRelations) {
				 		
				 		if (sameInterestRelations.isEmpty()) {
				 			%>
				 				<tr><td>No other users</td></tr>
				 			<%
				 		} else {
				 		// Find the other user profile
				 		Key otherUserKey = KeyFactory.createKey("UserProfile", interestRelation.getProperty("userEmail").toString());
				 		Entity otherUser = datastore.get(otherUserKey);
				 		
				 		// set this other user's username to the page context
				 		pageContext.setAttribute("otherUserProfile_userName", otherUser.getProperty("userName").toString());
	
				 		// print the userName
				 		%>
				 			<tr><td>User name: </td>
				 				<td>${fn:escapeXml(otherUserProfile_userName)}</td>
				 		<%			
				 		
				 		// check if is already a friend
				 		String friendEmail = otherUser.getProperty("email").toString(); 
				 		pageContext.setAttribute("otherUserProfile_email", friendEmail);
					 	
				 		Filter targetFriend = new CompositeFilter(CompositeFilterOperator.AND, Arrays.<Filter>asList(
								new FilterPredicate("firstPersonEmail",FilterOperator.EQUAL, loggedUserEmail),
								new FilterPredicate("secondPersonEmail",FilterOperator.EQUAL, friendEmail)));
						Query queryFriend = new Query("FriendshipRelation").setFilter(targetFriend);
						
						
						// create the list of entities
					 	List<Entity> friendships = datastore.prepare(queryFriend).asList(FetchOptions.Builder.withLimit(2));
						if (!friendships.isEmpty()) {
							%>
								<td>Already a friend</td>
								</tr>
	 						<%
						}
						else {
							// Allows to request friendship for those that aren't friends
						%>

							<td><a href=requestFriendship.jsp?id1=${fn:escapeXml(loggedUser_email)}&id2=${fn:escapeXml(otherUserProfile_email)}>Request Friendship</a></td>
						</tr>
	 					<%
						} //end of else of InterestRelations list
	 					} 		
				 	}	 		
				 	}
				%>
				</table>
				<%
 				}

					
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
