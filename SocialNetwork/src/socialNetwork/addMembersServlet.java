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




public class addMembersServlet extends HttpServlet{
    private static final Logger log = Logger.getLogger(addMembersServlet.class.getName());

    public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {

    	
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        
        // Getting info from form
        String groupName = req.getParameter("groupName");  
        
        String newMemberEmail[] = req.getParameterValues("userEmail");

        for (int i = 0; i < newMemberEmail.length; i++) {
        	if (!newMemberEmail[i].isEmpty()) {
	        	String groupRelationKey = groupName.concat("&").concat(newMemberEmail[i]);
	        	Entity groupRelation = new Entity ("GroupRelation", groupRelationKey);
	        	
	        	groupRelation.setProperty("groupName", groupName);
	        	groupRelation.setProperty("userEmail", newMemberEmail[i]);
	        	datastore.put(groupRelation);
	
	        	System.out.println("GroupRelation com: groupName: " + groupName + "   userEmail: " + newMemberEmail[i]);
	        }
        }

        
        
        // Putting the entity in the database
        resp.sendRedirect("/groupPage.jsp?group=".concat(groupName));

    }

}
