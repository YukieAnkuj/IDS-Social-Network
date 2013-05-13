
	<div class="membersList">
	 	<h2>Members</h2>
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
					%>
						<ul>
					<%
	 				for (Entity member: members) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("memberEmail", member.getProperty("userEmail"));
	 					//TODO get the person's name instead of email
					%>
						
						<li>Member email: <a href="userPage.jsp?email=${fn:escapeXml(memberEmail)}">${fn:escapeXml(memberEmail)}</a></li>
					<%
	 				}
					%>
						</ul>
					<%
					
				}
			%>
		<ul><li>
		<a href="addMembers.jsp?group=${fn:escapeXml(group_name)}">Add members</a>
		</li></ul>
		</div>
