package memobook;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.Calendar;
import java.util.HashSet;
import java.util.TreeSet;

import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PropertyProjection;

public class FinishYearServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		resp.setContentType("text/xml");
    	PrintWriter out = resp.getWriter();
    	out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?><years>");
    	
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    UserService	userService	= UserServiceFactory.getUserService();
	    User		user		= userService.getCurrentUser();
	    Key			key			= KeyFactory.createKey("Memobook", user.getEmail());
	    Query		query		= new Query("Memo", key);
	    query.addProjection(new PropertyProjection("DateEnd", Date.class));
	    query.setDistinct(true);
	    
	    HashSet<Integer> yearSet = new HashSet<Integer>();
	    for (Entity memo : datastore.prepare(query).asIterable()) {
	    	Date d = (Date)memo.getProperty("DateEnd");
	    	if (d == null)
	    		continue;
	    	Calendar c = Calendar.getInstance();
	    	c.setTime(d);
	    	yearSet.add(c.get(Calendar.YEAR));
	    }
	    TreeSet<Integer> sortedSet = new TreeSet<Integer>(yearSet);
	    
	    for (Integer i : sortedSet.descendingSet())
	    	out.println("<year>"+i.toString()+"</year>");
	    out.println("</years>");
	}
}
