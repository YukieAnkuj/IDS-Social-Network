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
import java.util.Date;
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

        String users = "users";
        Key usersKey = KeyFactory.createKey("Users", users);

        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        
        Entity userProfile = new Entity ("UserProfile", usersKey);
        userProfile.setProperty("firstName", firstName);
        userProfile.setProperty("lastName", lastName);
        
        DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        datastore.put(userProfile);
        
        
        log.info("Received as first name: " + firstName);
        log.info("Received as last name: " + lastName);

        resp.sendRedirect("/socialNetwork.jsp");
    }

}
