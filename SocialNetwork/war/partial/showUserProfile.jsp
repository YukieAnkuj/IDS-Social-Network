
	  <div class="about">
	
	 
	 	<h2>${fn:escapeXml(userProfile_email)}</h2>
		<table>
			<tr>
				<td><h3>First name: </h3></td>
				<td><p>${fn:escapeXml(userProfile_firstName)}</p></td>
			</tr>
			<tr>
				<td><h3>Last name:</h3></td>
				<td><p>${fn:escapeXml(userProfile_lastName)}</p></td>
			</tr>
			<tr>
				<td><h3>UserName:</h3></td>
				<td><p>${fn:escapeXml(userProfile_userName)}</p></td>
			</tr>
		</table>
	</div>
