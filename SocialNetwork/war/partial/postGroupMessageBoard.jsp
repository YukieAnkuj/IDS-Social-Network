
				<%
		    // Finding the userName of the logged user
		    Key loggedUserKey = KeyFactory.createKey("UserProfile", loggedUserEmail);
	    	Entity loggedUser = datastore.get(loggedUserKey);
	    	pageContext.setAttribute("loggedUser_userName", loggedUser.getProperty("userName"));
	    		    		
		%>
		  <div class="postMessage">
		  	<h2>Post a message</h2>
			
		    <form action="/groupPostForm" method="post">
		      <div><textarea name="content" rows="6" cols="30" placeholder="Write a message..."></textarea></div>
		      <div><input type="submit" value="Post message"  class="buttonStyle"/></div>
		      <input type="hidden" name="boardGroupName" value="${fn:escapeXml(group_name)}"/>
		      <input type="hidden" name="userNamePoster" value="${fn:escapeXml(loggedUser_userName)}"/>
			</form>
			
		  </div>
  