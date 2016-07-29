package memobook;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.*;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import au.com.bytecode.opencsv.*;

public class CsvServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
		resp.setContentType("application/csv");
		resp.setHeader("content-disposition","filename=tagbook.csv");
		resp.setCharacterEncoding("utf-8");
    	PrintWriter out = resp.getWriter();

	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    UserService	userService	= UserServiceFactory.getUserService();
	    User		user		= userService.getCurrentUser();
	    Key			key			= KeyFactory.createKey("Memobook", user.getEmail());
	    Query		query		= new Query("Memo", key);
    	
	    CSVWriter writer = new CSVWriter(out);
	    for (Entity memo : datastore.prepare(query).asIterable()) {
	    	 
			String title	= (String)memo.getProperty("title");
			if (title == null) title = "";		
			String isbn		= (String)memo.getProperty("isbn");
			if (isbn == null) isbn = "";
			String author	= (String)memo.getProperty("author");
			if (author == null) author = "";
			String pub		= (String)memo.getProperty("publisher");
			if (pub == null) pub = "";
			@SuppressWarnings("unchecked")
			ArrayList<String> tagList = (ArrayList<String>)memo.getProperty("tag");
			String tag = "";
			if (tagList != null)
				tag = tagList.toString();
			if (tag == null)
				tag = "";
			String dateStart= "";
			if (memo.hasProperty("DateStart"))
			{
				Date d = (Date)memo.getProperty("DateStart");
				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				dateStart = f.format(d);
			}
			String dateEnd  = "";
			if (memo.hasProperty("DateEnd"))
			{
				Date d = (Date)memo.getProperty("DateEnd");
				SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
				dateEnd = f.format(d);
			}
			String m = (String)memo.getProperty("memo");
			if (m == null) m = "";
			String[] entries = {author, title, pub, isbn, tag, dateStart, dateEnd, m};
			writer.writeNext(entries);
	    }
	    writer.flush();
	    writer.close();
	}
}
