<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

  <body>

	<h1>Fill the form</h1>

	  <form action="/userForm" method="get">
	    <div>First name: <input type="text" name="firstName"></div>
	    <div>Last name: <input type="text" name="lastName" /></div>
	    <div><input type="radio" name="sex" value="male">Male
	    	 <input type="radio" name="sex" value="female">Female</div>
	    <div><input type="submit" value="Submit" /></div>
	  </form>
  
  
  </body>
</html>