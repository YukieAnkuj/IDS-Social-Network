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

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	
	Key userProfileKey = KeyFactory.createKey("UserProfile", user.getEmail());
	
	try {
	 
	 Entity userProfile = datastore.get(userProfileKey);

	 pageContext.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
	 pageContext.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));

	 
	 %>
	 	<p>Your profile</p>
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
		
	 	<p>Change your profile</p>
	 	<a href="userForm.jsp">User Form</a>
	 	
	 	
	 	<a href="searchUsers.jsp">Search Users</a>

	 	
	<%
	
	} catch (EntityNotFoundException e) {
	 // TODO Auto-generated catch block
	 %>
	 	<p>You have no profile, please fill the form</p>
	 	<a href="userForm.jsp">User Form</a>
	 <%
	 //e.printStackTrace();
	}
          



%>





<%
    } else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></p>
<%
    }
%>

	 


  
  </body>
</html>