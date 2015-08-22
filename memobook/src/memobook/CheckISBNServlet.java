package memobook;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Query.Filter;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.datastore.Query.FilterPredicate;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

/*
 * Check Datastore and return if it has ISBN record
 */
public class CheckISBNServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		resp.setContentType("text/xml");
    	PrintWriter out = resp.getWriter();
    	out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();
	    String isbn  = req.getParameter("isbn");
	    if (isbn.length() == 0)
	    	return;
	    Key key = KeyFactory.createKey("Memobook", user.getEmail());

	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    Filter isbnFilter = new FilterPredicate("isbn", FilterOperator.EQUAL, isbn);    
	    Query query       = new Query("Memo", key).setFilter(isbnFilter);
	    Iterable<Entity> memos = datastore.prepare(query).asIterable();
	    if (memos.iterator().hasNext())
	    	out.println("<has_isbn>true</has_isbn>");
	    else
	    	out.println("<has_isbn>false</has_isbn>");
	}
}
