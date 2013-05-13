<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
	<div class="membersList">
		<p>________________________________</p>
	 	<p>Members</p>
		<table>
			<% 	
				// Looking friendshipRelation entity related to this user
				Filter targetGroup = new FilterPredicate("groupName", FilterOperator.EQUAL,groupName);
				System.out.println("GroupRelation com: groupName: " + groupName);
		       
				Query query = new Query("GroupRelation").setFilter(targetGroup);
	
				/* create the list of entities*/
			 	List<Entity> members = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
				if (members.isEmpty()) {
					%>
						<p> No members</p>
					<%
				}
				else {
	 				for (Entity member: members) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("memberEmail", member.getProperty("userEmail"));
	 					//TODO get the person's name instead of email
					%>
						<tr>
							<td>Member email: </td>
							<td><a href="userPage.jsp?email=${fn:escapeXml(memberEmail)}">${fn:escapeXml(memberEmail)}</a></td>
						</tr>
					<%
	 				}
				}
			%>

		</table> 
		</div>

</body>
</html>