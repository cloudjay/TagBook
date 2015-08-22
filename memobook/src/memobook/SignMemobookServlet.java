package memobook;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.http.*;
import java.util.Date;
import java.util.Calendar;
import java.util.HashSet;
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

/**
 * @author cloudjay
 * Adds new Entity to Datastore
 */
public class SignMemobookServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    String isbn  = req.getParameter("isbn");
    String title = req.getParameter("title");
    String memo  = req.getParameter("memo");
    String tag   = req.getParameter("tags");
    String author= req.getParameter("author");
    String pub   = req.getParameter("publisher");
    Integer star = new Integer(0);
    String starStr = req.getParameter("star1");
    if (starStr != null)
    	star = Integer.parseInt(req.getParameter("star1"));
    int check1  = 0;
    int check2	= 0;
    int check3	= 0;
    String checkStr = req.getParameter("check1");
    if (checkStr != null && Integer.parseInt(checkStr)==1) check1 = 1;
    checkStr = req.getParameter("check2");
    if (checkStr != null && Integer.parseInt(checkStr)==1) check2 = 1;
    checkStr = req.getParameter("check3");
    if (checkStr != null && Integer.parseInt(checkStr)==1) check3 = 1;
    
    Boolean bDate= true;
    int mm = -1;
    try { mm = Integer.parseInt(req.getParameter("MM"))-1;   } catch (NumberFormatException e) { mm = -1; }
    int dd = 0;
    try { dd = Integer.parseInt(req.getParameter("DD"));    } catch (NumberFormatException e) { dd = 0; }
    int yy = 0;
    try { yy = Integer.parseInt(req.getParameter("YYYY")); } catch (NumberFormatException e) { yy = 0; }
    if (mm < 0 || dd == 0 || yy == 0)
    	bDate = false;

    Boolean bDateEnd= true;
    int mmE = -1;
    try { mmE = Integer.parseInt(req.getParameter("MMe"))-1;   } catch (NumberFormatException e) { mmE = -1; }
    int ddE = 0;
    try { ddE = Integer.parseInt(req.getParameter("DDe"));    } catch (NumberFormatException e) { ddE = 0; }
    int yyE = 0;
    try { yyE = Integer.parseInt(req.getParameter("YYYYe")); } catch (NumberFormatException e) { yyE = 0; }
    if (mmE < 0 || ddE == 0 || yyE == 0)
    	bDateEnd = false;   
    
    if (user == null){
    	resp.setContentType("text/html");
    	PrintWriter out = resp.getWriter();
    	out.println("<script>");
    	out.println("alert('Please login'); window.location='/'");
    	out.println("</script>");
    	return;
    }
    
    if (isbn == null || isbn.length() == 0){
    	resp.setContentType("text/html");
    	PrintWriter out = resp.getWriter();
    	out.println("<script>");
    	out.println("alert('ISBN is required'); window.location='/'");
    	out.println("</script>");
    	return;
    }
    
    Key key = KeyFactory.createKey("Memobook", user.getEmail());
    Entity entity = new Entity("Memo", key);
    
    entity.setProperty("user", user);
    entity.setProperty("isbn", isbn);
    if (title != null && title.length() != 0)
    	entity.setProperty("title", title);
    if (memo != null && memo.length() != 0)
    	entity.setProperty("memo", memo);
    if (author != null && author.length() != 0)
    	entity.setProperty("author", author);
    if (pub != null && pub.length() != 0)
    	entity.setProperty("publisher", pub);
    if (star != null && star.intValue() != 0)
    	entity.setProperty("rating", star);
    if (check1 == 1)
    	entity.setProperty("check1", 1);
    if (check2 == 1)
    	entity.setProperty("check2", 1);
    if (check3 == 1)
    	entity.setProperty("check3", 1);
    if (bDate)
    {
	    Calendar c = Calendar.getInstance();
	    c.set(yy, mm, dd);
	    Date date = c.getTime();
	    entity.setProperty("DateStart", date);	    
    }
    if (bDateEnd)
    {
	    Calendar c = Calendar.getInstance();
	    c.set(yyE, mmE, ddE);
	    Date date = c.getTime();
	    entity.setProperty("DateEnd", date);	    
    }
    
    HashSet<String> tagSet = new HashSet<String>();
    String[] tags = tag.split("[\\s,]");
    for (String t : tags) {
    	if (t.length() != 0 && !t.equals(" "))
    		tagSet.add(t);
    }
    entity.setProperty("tag", tagSet);

    // Delete existing item
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key memobookKey   = KeyFactory.createKey("Memobook", user.getEmail());
    Filter isbnFilter = new FilterPredicate("isbn", FilterOperator.EQUAL, isbn);    
    Query query       = new Query("Memo", memobookKey).setFilter(isbnFilter);
    Iterable<Entity> memos = datastore.prepare(query).asIterable();
    while (memos.iterator().hasNext())
    {
    	Entity ent = memos.iterator().next();
    	datastore.delete(ent.getKey());
    }
    
    datastore.put(entity);
    
    resp.sendRedirect("/memobook.jsp");
    }
}
