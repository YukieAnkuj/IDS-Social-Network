
		<div class="post">
				<%
		    // Run query to get the posts of this groupProfile
		    Filter targetGroupPosts = new FilterPredicate("boardGroupName", FilterOperator.EQUAL, groupName);
			System.out.println("Inside group page, groupName: " + groupName);
		    
		    Query queryPost = new Query("GroupPost").setFilter(targetGroupPosts).addSort("date", Query.SortDirection.DESCENDING);


		    List<Entity> posts = datastore.prepare(queryPost).asList(FetchOptions.Builder.withLimit(5));
		    
		    if (posts.isEmpty()) {
		        %>
		        <h2>No posts</h2>
		        <%
		    } else {
		        %>
		        <h2>Posts</h2>
		        <%
		        for (Entity post : posts) {
		            pageContext.setAttribute("post_content", post.getProperty("content"));
		            pageContext.setAttribute("post_userName", post.getProperty("userNamePoster"));
		            pageContext.setAttribute("post_date", post.getProperty("date"));
		                %>
			            <p><span>${fn:escapeXml(post_content)}</p>
			            <h3><span>by</span> ${fn:escapeXml(post_userName)}<date>(${fn:escapeXml(post_date)})</date></h3>
			            
			            
		            <%
		        }
		    }
		    
	
		%>



		
		
		</div>
