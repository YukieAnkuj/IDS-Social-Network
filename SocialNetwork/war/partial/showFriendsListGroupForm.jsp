
	<div class="friends">
	 	<h2>Friends</h2>

			<% 	
				// Looking friendshipRelation entity related to this user
				System.out.println("This email: "+loggedUserEmail);
				Filter targetUser = new FilterPredicate("firstPersonEmail", FilterOperator.EQUAL,loggedUserEmail);
				
				Query query = new Query("FriendshipRelation").setFilter(targetUser);
				

				/* create the list of entities*/
			 	List<Entity> friendships = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(20));
				if (friendships.isEmpty()) {
					%>
						<p> No friends to invite</p>
					<%
				}
				else {
					%>
					<ul>
					<form action="/addMembersForm" method="post">
					<%
	 				for (Entity friendship: friendships) {
	 					String friendEmail = friendship.getProperty("secondPersonEmail").toString();
	 					// Get the friend's email to print it later
	 					pageContext.setAttribute("friend_id", friendEmail);
	 					
	 					// see if the person is not already a member
	 					String keyString = groupName.concat("&").concat(friendEmail);
	 					Key groupRelationKey = KeyFactory.createKey("GroupRelation", keyString);
				 		
	 					try {
	 						// friend is a member
	 						Entity groupRelation = datastore.get(groupRelationKey);
	 						
	 					}
	 					catch (EntityNotFoundException e) {
	 						// friend is not a member
	 						%>
							
							<!-- <td>Friend email: </td>  -->
							<li><input type="checkbox" name="userEmail" value="${fn:escapeXml(friend_id)}">${fn:escapeXml(friend_id)}</li>
	
							<%
	 					}
	 					
					%>
						
					<%
	 				}
	 				
	 				%>
	 				<input type="hidden" name="groupName" value="${fn:escapeXml(group_name)}"/>
	 				<input type="submit" value="Add members" />
	 			    </form>
	 			    </ul>
	 			    <%   
				}
			%>

		</div>
