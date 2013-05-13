
	
	<div class="interests">
	 	<h2>Interests</h2>
	 	<ul>
			<% 	
				// Looking InterestRelation entity related to this user
				
				Filter targetUserInterest = new FilterPredicate("userEmail", FilterOperator.EQUAL,targetEmail);
				
				Query queryInterest = new Query("InterestRelation").setFilter(targetUserInterest);
				

				/* create the list of entities*/
			 	List<Entity> interests = datastore.prepare(queryInterest).asList(FetchOptions.Builder.withLimit(20));
				if (interests.isEmpty()) {
					%>
						<li> No interests</li>
					<%
				}
				else {
	 				for (Entity interest: interests) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("interestName", interest.getProperty("interestName"));
	 	 				
					%>
							<li>${fn:escapeXml(interestName)}</li>
					<%
	 				}
				}
			%>
		</ul>
		</div>

