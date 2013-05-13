				<%
		    // Run query to get the posts of this userProfile

		    // Finding the userName of the logged user
	    	Entity loggedUser = datastore.get(loggedUserKey);
	    	pageContext.setAttribute("loggedUser_userName", loggedUser.getProperty("userName"));
	    		
		%>
		  <div class="postMessage">
		  	<h2>Post a message</h2>
			
			<form action="/postForm" method="post">
		      <textarea name="content" rows="6" cols="30" placeholder="Write a message..."></textarea>
		      <div class="blank"></div><input type="submit" class="buttonStyle"   value="Post message" />
		      <input type="hidden" name="userNameBoard" value="${fn:escapeXml(userProfile_userName)}"/>
		      <input type="hidden" name="userNamePoster" value="${fn:escapeXml(loggedUser_userName)}"/>
		      <input type="hidden" name="boardEmail" value="${fn:escapeXml(userProfile_email)}"/>
			</form>
			
		  </div>
