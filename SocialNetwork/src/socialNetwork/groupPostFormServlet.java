package socialNetwork;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class groupPostFormServlet extends HttpServlet{
    private static final Logger log = Logger.getLogger(formSocialNetworkServlet.class.getName());

    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    	
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
	    // Getting info from form
    	String message = req.getParameter("content");
    	String boardGroupName = req.getParameter("boardGroupName");
    	String userNamePoster = req.getParameter("userNamePoster");
    	Date date = new Date();
    	
    	System.out.println("Post's message: "+ message);

    	//Creating a key for the message -> userName of the board + date
    	String post_id = boardGroupName.concat(date.toString());
    	
    	Entity post = new Entity("GroupPost", post_id);
    	
    	//Setting properties
    	post.setProperty("content", message);
    	post.setProperty("userNamePoster", userNamePoster);
    	post.setProperty("date", date);
    	post.setProperty("boardGroupName", boardGroupName);
    	
	    
	    // Putting the entity in the database
	    datastore.put(post);
	    
	    String url = "/groupPage.jsp?group=";
	    url = url.concat(boardGroupName);
	    resp.sendRedirect(url);
    }

}