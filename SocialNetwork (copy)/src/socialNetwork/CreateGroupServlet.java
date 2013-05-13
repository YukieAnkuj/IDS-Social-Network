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




public class CreateGroupServlet extends HttpServlet{
    private static final Logger log = Logger.getLogger(CreateGroupServlet.class.getName());

    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

    	
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
        // Getting info from form
        String groupName = req.getParameter("groupName");   
        String description = req.getParameter("description");
        String userEmailcreator = req.getParameter("userEmail");

        Entity group = new Entity ("GroupProfile", groupName);
        group.setProperty("groupName", groupName);
        group.setProperty("description", description);
        
        datastore.put(group);
        
        String relationKey = groupName;
        relationKey.concat("&").concat(userEmailcreator);
        Entity groupRelation = new Entity ("GroupRelation", relationKey);
        groupRelation.setProperty("groupName", groupName);
        groupRelation.setProperty("userEmail", userEmailcreator);
        
    	System.out.println("GroupRelation com: groupName: " + groupName + "   userEmail: " + userEmailcreator);
        
        // Putting the entity in the database

        datastore.put(groupRelation);
        
        resp.sendRedirect("/manageGroups.jsp");
        

    }

}
