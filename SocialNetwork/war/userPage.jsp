
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
	
	try {
	 
	 Entity userProfile = datastore.get(userProfileKey);

	 pageContext.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
	 pageContext.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));
	 

	 /* -------------------- Specific code ---------------------- */
	 pageContext.setAttribute("userProfile_userName", userProfile.getProperty("userName"));
	 String targetEmail = userProfileEmail;
	 %>
	 <div class="profile">
	
 	 				
  	
	<p>________________________________</p>
	 
	 	<p>Profile</p>
	 	<p>${fn:escapeXml(userProfile_email)}</p>
		<table>
			<tr>
				<td>First name: </td>
				<td>${fn:escapeXml(userProfile_firstName)}</td>
			</tr>
			<tr>
				<td>Last name:</td>
				<td>${fn:escapeXml(userProfile_lastName)}</td>
			</tr>
			<tr>
				<td>UserName:</td>
				<td>${fn:escapeXml(userProfile_userName)}</td>
			</tr>
		</table>
	<div class="interestList">
		<p>. . . . . . . . . . . . . . . . . . </p>
	 	<p>Interests</p>
		<table>
			<% 	
				// Looking InterestRelation entity related to this user
				
				Filter targetUserInterest = new FilterPredicate("userEmail", FilterOperator.EQUAL,targetEmail);
				
				Query queryInterest = new Query("InterestRelation").setFilter(targetUserInterest);
				

				/* create the list of entities*/
			 	List<Entity> interests = datastore.prepare(queryInterest).asList(FetchOptions.Builder.withLimit(20));
				if (interests.isEmpty()) {
					%>
						<p> No interests</p>
					<%
				}
				else {
	 				for (Entity interest: interests) {
	 					pageContext.setAttribute("interestName", interest.getProperty("interestName"));
	 	 				
					%>
						<tr>
							<td>${fn:escapeXml(interestName)}</td>
						</tr>
					<%
	 				}
				}
			%>

		</table> 
		</div>
	</div>
	<div class="friendsList">
		<p>________________________________</p>
	 	<p>Friends</p>
		<table>
			<% 	
				// Looking friendshipRelation entity related to this user
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
		
		<div class="messageBoard">
			<p>________________________________</p>
				<%
		    // Run query to get the posts of this userProfile
		    Filter targetUserPosts = new FilterPredicate("boardEmail", FilterOperator.EQUAL,userProfileEmail);
			System.out.println("Inside user page, username: " +userProfile.getProperty("userName"));
		    
		    Query queryPost = new Query("Post").setFilter(targetUserPosts).addSort("date", Query.SortDirection.DESCENDING);


		    List<Entity> posts = datastore.prepare(queryPost).asList(FetchOptions.Builder.withLimit(5));
		    
		    if (posts.isEmpty()) {
		        %>
		        <p>No posts.</p>
		        <%
		    } else {
		        %>
		        <p>Posts:</p>
		        <%
		        for (Entity post : posts) {
		            pageContext.setAttribute("post_content", post.getProperty("content"));
		            pageContext.setAttribute("post_userName", post.getProperty("userNamePoster"));
		            pageContext.setAttribute("post_date", post.getProperty("date"));
		                %>
		                <p><b>${fn:escapeXml(post_userName)}</b> wrote:</p>
			            <p>${fn:escapeXml(post_content)}</p>
			            <p>(${fn:escapeXml(post_date)})</p>
			            <p>. . . . . . . . . . . . . . .</p>
		            <%
		        }
		    }
		    
		    // Finding the userName of the logged user
	    	Entity loggedUser = datastore.get(loggedUserKey);
	    	pageContext.setAttribute("loggedUser_userName", loggedUser.getProperty("userName"));
	    		
		%>

		    <form action="/postForm" method="post">
		      <div><textarea name="content" rows="3" cols="60"></textarea></div>
		      <div><input type="submit" value="Post message" /></div>
		      <input type="hidden" name="userNameBoard" value="${fn:escapeXml(userProfile_userName)}"/>
		      <input type="hidden" name="userNamePoster" value="${fn:escapeXml(loggedUser_userName)}"/>
		      <input type="hidden" name="boardEmail" value="${fn:escapeXml(userProfile_email)}"/>
			</form>

		
		
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
