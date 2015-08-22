
<!-- Tag cloud start -->

<%@include file="header.jsp" %>
<%@page import="com.google.appengine.labs.repackaged.com.google.common.collect.*" %>
<script type="text/javascript" src="jquery.tagcloud.js"></script>
<script type="text/javascript">
$.fn.tagcloud.defaults = {
		  size: {start: 9, end: 16, unit: 'pt'},
		  color: {start: '#210664', end: '#FF6600'}
		};

		$(function () {
		  $('#tagcloud a').tagcloud();
		});
</script>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    Key			key			= KeyFactory.createKey("Memobook", user.getEmail());
	    Query		query		= new Query("Memo", key);
	    Iterable<Entity> memos	= datastore.prepare(query).asIterable();
	    Multiset<String> ms		= TreeMultiset.create();
	    for (Entity memo : memos) {
	    	@SuppressWarnings("unchecked")
			ArrayList<String> tagSet = (ArrayList<String>)memo.getProperty("tag");
	    	if (tagSet != null)
				for (String s : tagSet)
					ms.add(s);
	    }
	    out.println("<div id=\"tagcloud\">");
	    Set<Multiset.Entry<String>> es = ms.entrySet();
	    for (Multiset.Entry<String> e : es)
	    	out.println("<a data-weight=\""+e.getCount()+"\" href=\"/tag.jsp?findtag="+e.getElement()+"\">"+e.getElement()+"</a>");
		out.println("</div>");
    }
%>
<!-- Tag cloud end -->
