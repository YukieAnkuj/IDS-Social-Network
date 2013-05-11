
<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
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
</div>
</body>
</html>