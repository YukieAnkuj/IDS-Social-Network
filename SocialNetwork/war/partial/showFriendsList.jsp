<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
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
	 	 				
	 					//TODO get the person's name instead of email
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

</body>
</html>