<%@page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Social Network</title>
</head>
<body>
	
	<div class="interestList">
		<p>. . . . . . . . . . . . . . . . . . </p>
	 	<p>NEW Interests</p>
		<table>
			<% 	
				// Looking InterestRelation entity related to this user
				
				Filter targetUserInterest = new FilterPredicate("userEmail", FilterOperator.EQUAL,targetEmail);
				
				Query queryInterest = new Query("InterestRelation").setFilter(targetUserInterest);
				

				/* create the list of entities*/
			 	List<Entity> interests = datastore.prepare(queryInterest).asList(FetchOptions.Builder.withLimit(20));
				if (interests.isEmpty()) {
					%>
						<p> No interests</p>
					<%
				}
				else {
	 				for (Entity interest: interests) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("interestName", interest.getProperty("interestName"));
	 	 				
					%>
						<tr>
							<td>${fn:escapeXml(interestName)}</td>
						</tr>
					<%
	 				}
				}
			%>

		</table> 
		</div>
	</div>

</body>
</html>