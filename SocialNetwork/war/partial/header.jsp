	<div id="logoWrap"><h1>solitude</h1></div>
	<div id="greeting">	 
	  <p>Hello, ${fn:escapeXml(user.nickname)}! (
	 <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
     </div>
