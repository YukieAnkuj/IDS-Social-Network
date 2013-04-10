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


public class postFormServlet extends HttpServlet{
    private static final Logger log = Logger.getLogger(formSocialNetworkServlet.class.getName());

    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
    	
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
	    // Getting info from form
    	String message = req.getParameter("content");
    	String userNameBoard = req.getParameter("userNameBoard");
    	String userNamePoster = req.getParameter("userNamePoster");
    	String boardEmail = req.getParameter("boardEmail");
    	Date date = new Date();
    	
    	System.out.println("Post's message: "+ message);
    	System.out.println("Post's boardEmail: "+ boardEmail);

    	//Creating a key for the message -> userName of the board + date
    	String post_id = boardEmail.concat(date.toString());
    	
    	Entity post = new Entity("Post", post_id);
    	
    	//Setting properties
    	post.setProperty("content", message);
    	post.setProperty("userNameBoard", userNameBoard);
    	post.setProperty("userNamePoster", userNamePoster);
    	post.setProperty("date", date);
    	post.setProperty("boardEmail", boardEmail);
    	
	    
	    // Putting the entity in the database
	    datastore.put(post);
	    
	    String url = "/userPage.jsp?email=";
	    url = url.concat(boardEmail);
	    resp.sendRedirect(url);
    }

}