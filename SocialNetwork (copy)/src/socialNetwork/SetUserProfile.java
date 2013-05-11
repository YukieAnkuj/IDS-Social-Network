package socialNetwork;


import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;

public class SetUserProfile implements Tag, Serializable{
	private PageContext pc = null;
	private Tag parent = null;
	private User user = null;
	private String userEmail = null;
	
	
	public void setPageContext(PageContext p) {
		pc = p;
	}
	
	public void setParent(Tag t) {
		parent = t;
	}
	
	public Tag getParent() {
		return parent;
	}
	
	public int doStartTag()throws JspException {
		// define the email of this userpage
		userEmail = pc.getAttribute("userProfile_email").toString();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		Key userProfileKey = KeyFactory.createKey("UserProfile", userEmail);
		try {
			 
			 Entity userProfile = datastore.get(userProfileKey);
			 System.out.println("fui chamado");
			 pc.setAttribute("userProfile_firstName", userProfile.getProperty("firstName"));
			 pc.setAttribute("userProfile_lastName", userProfile.getProperty("lastName"));
			 

			 /* -------------------- Specific code ---------------------- */
			 pc.setAttribute("userProfile_userName", userProfile.getProperty("userName"));
			 String targetEmail = userEmail;
				
		} catch (EntityNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		return SKIP_BODY;
	}
	
	public int doEndTag() throws JspException {
		return EVAL_PAGE;
	}
	
	public void release() {
		pc = null;
		parent = null;
		userEmail = null;
	}
	
}
