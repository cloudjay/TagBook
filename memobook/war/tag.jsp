<%@include file="header.jsp" %>
<%@include file="print.jsp" %>
<%@include file="filter.jsp" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Tagged books</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes" />
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="apple-touch-startup-image" href="/startup.png">
    <link rel="stylesheet" type="text/css" href="view.css" media="Screen">
    <link media="handheld, only screen and (max-width: 480px), only screen and (max-device-width: 480px)" href="mobile.css" type="text/css" rel="stylesheet" />
<%@include file="header_jquery.jsp"%>
<%@include file="print_js.jsp"%>
    <script type="text/javascript" src="view.js"></script>
<%@include file="google_analytics.jsp"%>
  </head>

  <body id="main_body" onload="update_count();">
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
      pageContext.setAttribute("user", user);
%>
    <div id="sign">
    </div>
<%
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key memobookKey = KeyFactory.createKey("Memobook", user.getEmail());
    Query query = new Query("Memo", memobookKey);

    int filterCount = 0;
    String[] tags = request.getParameter("findtag").split("[\\s,]");
    List<Entity> memos = new ArrayList<Entity>();    
  	filterCount += addTagsFilter(tags, query);
  	
    if (filterCount > 0)
	    memos = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
    %>
    <img class="top" src="/img/top.png" alt="">
	<div class="searchform">
		<div class="search_query">
			<div class="form_description">
				<%@include file="filter_input.html" %>
				<h2><% out.print(request.getParameter("findtag")); %></h2> <div id="book_count">&#1161;</div>
			</div>
<%  if (memos.isEmpty()) {
        %>  <p>No results.</p><%
    } else {
    	StringWriter str = new StringWriter();
		printList(new PrintWriter(str), memos);
		%><%=str%><%
    }%>
		</div>
	</div>
	<img id="bottom" src="/img/bottom.png" alt="">
<%  } else { // if (user != null) %>
    <div id="sign">Google <a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a></div>
<%  } %>
	<div>
		<form action="/"><INPUT type="image" src="/img/prev.png" alt="prev"/></form>
	</div>
  </body>
</html>