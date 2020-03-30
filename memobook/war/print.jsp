<%@include file="header.jsp" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*" %>
<%@page import="org.json.*" %>

<%!
public String propertyToLinks(Object p) {
	String links = "";
	@SuppressWarnings("unchecked")
	ArrayList<String> tagList = (ArrayList<String>)p;
	int count = 0;
	for (String t : tagList)
	{
		if (count == 0)
			links += "[";
		else
			links += ", ";	
		links += "<a style=\"color: black;\" href=\"/tag.jsp?findtag=" + t + "\">" + t + "</a>";
		count++;
	}
	links += "]";
	return links;
}

public void printList(PrintWriter out, List<Entity> memos, boolean showCover) {
	out.println("\t\t\t<ul id=\"booklist\">");
	for (Entity memo : memos) {
		String titleStr = "";
		String finDateStr = "";
		String ratingStr = "";
		if (memo.hasProperty("rating")) {
			Long r = (Long)memo.getProperty("rating");
			if (r != null)
				ratingStr = r.toString();
		}
		if (memo.hasProperty("DateEnd")) {
			Date d = (Date)memo.getProperty("DateEnd");
			finDateStr = String.valueOf(d.getTime());
		}
		if (memo.hasProperty("title"))
			titleStr = (String)memo.getProperty("title");
		
		out.println("<div class=\"card\" data-rating=\""+ ratingStr +"\" "
			+"data-fdate=\""+ finDateStr +"\" "
			+"data-title=\""+ titleStr +"\" id='"+memo.getProperty("isbn")+"'>");

		out.println("<table><tr>");
		if (showCover) {
			out.println("<td style=\"width: 100px;\">");
		try {
		String recv;
		String recvbuff = "";
		URL jsonpage = new URL("https://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=ttbncc17012351008&itemIdType=ISBN13&output=JS&ItemId=" + memo.getProperty("isbn"));
		URLConnection urlcon = jsonpage.openConnection();
		BufferedReader buffread = new BufferedReader(new InputStreamReader(urlcon.getInputStream(), "UTF8"));
		while ((recv = buffread.readLine()) != null)
			recvbuff += recv;
		buffread.close();		
		JSONObject jsonObj = new JSONObject(recvbuff);
		// JSONObject channel = (JSONObject)jsonObj.get("channel");
		// JSONArray array = channel.getJSONArray("item");
		JSONArray array = jsonObj.getJSONArray("item");
		JSONObject item = array.getJSONObject(0);
		String coverURL = item.getString("cover");
		out.println("<img src='"+coverURL+"'/><br/>");
		} catch (JSONException e) {
			//out.println(e);
		} catch (MalformedURLException e){
			//out.println(e);
		} catch (IOException e) {
			//out.println(e);
		} finally {
		}	
			out.println("</td>");
		}
		out.println("<td>");
		
		if (memo.hasProperty("author"))
			out.print(memo.getProperty("author")+". ");
		if (memo.hasProperty("title"))
			out.print("<em>"+titleStr+"</em>. ");
		if (memo.hasProperty("publisher"))
			out.print(memo.getProperty("publisher")+". ");
		
		out.println("ISBN <a class=\"isbnlink\" href=\"http://aladin.kr/p/"+memo.getProperty("isbn")+"\">"
							+memo.getProperty("isbn")+"</a><br/>");
		if (memo.hasProperty("tag"))
			out.println("<i class='material-icons' style='font-size:medium;vertical-align:text-bottom'>label_outline</i>"+propertyToLinks(memo.getProperty("tag"))+"<br/>");
		if (memo.hasProperty("DateStart"))
		{
			Date d = (Date)memo.getProperty("DateStart");
			SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
			out.println(f.format(d)+" ");
		}
		if (memo.hasProperty("DateEnd"))
		{
			Date d = (Date)memo.getProperty("DateEnd");
			SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
			out.println("~ "+f.format(d));
		}
		if (memo.hasProperty("DateEnd") || memo.hasProperty("DateStart"))
			out.println("<br/>");
		if (memo.hasProperty("rating")) {
			out.print("<div>");
			Long r = (Long)memo.getProperty("rating");
			for (int i=0; i<5; ++i) {
				out.print("<input name='");
				out.print(memo.getProperty("isbn"));
				out.print("-star' type='radio' class='star' disabled='disabled' ");
				out.print("value='"+((i+1)*2)+"' ");
				if (r.intValue() == (i+1)*2)
					out.print("checked='checked'");
				out.println("/>");
			}
			out.println("</div>");
		}
		if (memo.hasProperty("check1"))
			out.println("<div class='book-red'></div>");
		if (memo.hasProperty("check2"))
			out.println("<div class='book-green'></div>");
		if (memo.hasProperty("check3"))
			out.println("<div class='book-purple'></div>");	
		
		out.println("</td></tr></table>");		
		
		if (memo.hasProperty("memo"))
			out.println("<div class=\"memotext\"><pre>"+
						memo.getProperty("memo") +
						"</pre></div>");
		else
			out.println("<br/>");

		
		String titleAlert = (String)memo.getProperty("title");
		
		// Tweet button		
/* 		String memoTweet = (String)memo.getProperty("memo");
		if (memoTweet == null)
			memoTweet = "";
		memoTweet = memoTweet.replace("'","");
		memoTweet = memoTweet.replace("\"","");
		out.println("<a href='https://twitter.com/share' class='twitter-share-button' data-url='http://aladin.kr/p/"
					+ memo.getProperty("isbn") +"' data-text='"
					+ titleAlert
					+ " / " + memo.getProperty("author")
					+ ". " + memoTweet
					+"' data-lang='en' data-related='viciousfreak' data-count='none'>Tweet</a>");
 */		
		// Edit button
/* 		out.println("<form method=\"get\" action=\"/\">"+
		"<button>Edit</button>"+
		"<input type=\"hidden\" value="+ memo.getProperty("isbn") +" name=\"isbn\"/>"+
		"</form>");
 */		
		// Delete button
/* 		titleAlert = titleAlert.replace("'","");
		out.println("<button style='position:absolute;left:50px;bottom:2px' "+ 
			"onclick='confirm_delete(\"" + 
				titleAlert +"\","+
				memo.getProperty("isbn")+
			")'>Delete</button>");
 */		
		out.println("<div class=\"card-action grey lighten-4\">");
		out.println("<a style=\"color: black;\" href=\"/?isbn="+ memo.getProperty("isbn") +"\">Edit</a>");
		out.println("<a style=\"color: black; cursor: pointer;\" onclick='confirm_delete(\"" + 
				titleAlert +"\","+
				memo.getProperty("isbn")+
			")'>Delete</a>");
		out.println("</div>");
		
		out.println("</div>");		
	}
	out.print("\t\t\t</ul>");	
}
%>