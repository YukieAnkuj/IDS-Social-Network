package socialNetwork;


import java.io.*;
import javax.servlet.jsp.*;
import javax.servlet.jsp.tagext.*;


public class firstTag implements Tag, Serializable{
	private PageContext pc = null;
	private Tag parent = null;
	private String name = null;
	
	public void setPageContext(PageContext p) {
		pc = p;
	}
	
	public void setParent(Tag t) {
		parent = t;
	}
	
	public Tag getParent() {
		return parent;
	}
	
	public void setName (String s) {
		name = s;
	}
	
	public String getName() {
		return name;
	}
	
	public int doStartTag()throws JspException {
		try {
			if (name != null) {
				pc.getOut().write("Hello "+ name+ "!");
			} else {
				pc.getOut().write("You didn't enter your name");
				pc.getOut().write(", what are you afraid of ?");
			}
			
		} catch (IOException e) {
			throw new JspTagException("An IOException occurred.");
		}
		return SKIP_BODY;
	}
	
	public int doEndTag() throws JspException {
		return EVAL_PAGE;
	}
	
	public void release() {
		pc = null;
		parent = null;
		name = null;
	}
	
}
