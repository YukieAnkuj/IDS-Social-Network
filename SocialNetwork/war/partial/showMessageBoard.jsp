
		<div class="post">
			
				<%
		    // Run query to get the posts of this userProfile
		    Filter targetUserPosts = new FilterPredicate("boardEmail", FilterOperator.EQUAL,userProfileEmail);
			System.out.println("Inside user page, username: " +userProfile.getProperty("userName"));
		    
		    Query queryPost = new Query("Post").setFilter(targetUserPosts).addSort("date", Query.SortDirection.DESCENDING);


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
