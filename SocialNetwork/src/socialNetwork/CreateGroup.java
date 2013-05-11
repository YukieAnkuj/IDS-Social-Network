package socialNetwork;


import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;




public class CreateGroup extends HttpServlet{
    private static final Logger log = Logger.getLogger(CreateGroup.class.getName());

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
        // Getting info from form
        String groupName = req.getParameter("groupName");
        
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String userName = firstName.concat(" ").concat(lastName);
        
        String userEmail = user.getEmail();
        Entity userProfile = new Entity("UserProfile", userEmail);
        
        // getting members
        String[] members = req.getParameterValues("member");
        for (int i = 0; i< members.length; i++) {
        	// For each interest, create a new entity
        	System.out.println("interest Name: " + members[i]);
        	String interestRelID = members[i].concat(userEmail);
        	Entity interestRel = new Entity("InterestRelation",interestRelID);
        	
        	// Defining the entity
        	interestRel.setProperty("interestName", members[i]);
        	interestRel.setProperty("userEmail", userEmail);
        	
        	// Putting in the datastore
        	datastore.put(interestRel);
        }
        
        // Defining this entity
        userProfile.setProperty("firstName", firstName);
        userProfile.setProperty("lastName", lastName);
        userProfile.setProperty("userName", userName);
        userProfile.setProperty("email", userEmail);
        
        // Putting the entity in the database
        datastore.put(userProfile);
        
        resp.sendRedirect("/userPage.jsp");
        

        
    }

}
