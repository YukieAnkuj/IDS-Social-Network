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

  <body>
		
	 	<p>Search users: </p>
	 	<%
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			
			
	 		Query query = new Query("UserProfile");
	 		List<Entity> users = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	 		if (users.isEmpty()) {
	 			%>
	 				<p>No users registered</p>
	 			<%
	 		}
	 		else {
	 			%>
 					<p>Users:</p>
 					<table>

 				<%
 				for (Entity userProfile: users) {
 					pageContext.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
 					pageContext.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));
 					pageContext.setAttribute("userProfile_key", userProfile.getKey());
 	 				
 				%>
 					<tr>
						<td>First name: </td>
						<td>${fn:escapeXml(userProfile_firstName)}</td>
						<td>Last name:</td>
						<td>${fn:escapeXml(userProfile_lastName)}</td>
						<td>Email:</td>
						<td>${fn:escapeXml(userProfile_key)}</td>
						<td><form><input type="submit" name="requestFriendship" value="Request Friendship"></form></td>
					</tr>
 				<%
 				
 				}
 			%>
 				</table> 
 				<a href="socialNetwork.jsp">Your profile</a>
 			<%
	 		}
	 	
	 	%>
  				
  </body>
</html>