
	<div class="friends">
	 	<h2>Friends</h2>
		
			<% 	
				// Looking friendshipRelation entity related to this user
				System.out.println("This email: "+userProfileEmail);
				Filter targetUser = new FilterPredicate("firstPersonEmail", FilterOperator.EQUAL,targetEmail);
				
				Query query = new Query("FriendshipRelation").setFilter(targetUser);
				

				/* create the list of entities*/
			 	List<Entity> friendships = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
				if (friendships.isEmpty()) {
					%>
						<p>No friends</p>
					<%
				}

				else {
					%>
					 <ul>
					<%
	 				for (Entity friendship: friendships) {
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("friend_id", friendship.getProperty("secondPersonEmail"));
	 	 				
	 					//TODO get the person's name instead of email
					%>
						<li><a href="userPage.jsp?email=${fn:escapeXml(friend_id)}">${fn:escapeXml(friend_id)}</a></li>
					<%
	 				}
					%>
					 </ul>
					<%
				}
			%>

		</div>
