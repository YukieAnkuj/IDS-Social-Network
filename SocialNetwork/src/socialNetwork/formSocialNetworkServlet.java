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




public class formSocialNetworkServlet extends HttpServlet{
    private static final Logger log = Logger.getLogger(formSocialNetworkServlet.class.getName());

    public void doGet(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        // Getting info from form
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String userName = firstName.concat(" ").concat(lastName);
        
        String userEmail = user.getEmail();
        Entity userProfile = new Entity("UserProfile", userEmail);
        
        // Defining this entity
        userProfile.setProperty("firstName", firstName);
        userProfile.setProperty("lastName", lastName);
        userProfile.setProperty("userName", userName);
        userProfile.setProperty("email", userEmail);
        
        // Putting the entity in the database
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(userProfile);
        
        resp.sendRedirect("/userPage.jsp");
        

        
    }

}
