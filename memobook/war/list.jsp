<%@include file="header.jsp"%>
<%@include file="print.jsp"%>
<%@include file="filter.jsp"%>
<% response.setHeader("Access-Control-Allow-Origin","*"); %>

<!DOCTYPE html>
<html>
  <head>
    <title>List</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes" />
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="apple-touch-startup-image" href="/startup.png">
    <link rel="stylesheet" type="text/css" href="view.css" media="Screen">
    <link media="handheld, only screen and (max-width: 480px), only screen and (max-device-width: 480px)" href="mobile.css" type="text/css" rel="stylesheet" />
    <link type="text/css" rel="stylesheet" href="materialize/css/materialize.css"  media="screen,projection"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<%@include file="header_jquery.jsp"%>
<%@include file="print_js.jsp"%>
    <script type="text/javascript" src="view.js"></script>
<%@include file="google_analytics.jsp"%>
  </head>

<body id="main_body" onload="update_count();">

  <div class="">
  <nav>
      <div class="nav-wrapper grey darken-3">
      <ul class="left">
          <li><a href="/"><i class="material-icons" style="line-height: 60px">view_headline</i></a></li>
          <li><a href="/tagpage"><i class="small material-icons" style="line-height: 60px">label_outline</i></a></li>
      </ul>
      </div>
  </nav>
  </div>

	<%
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		if (user != null) {
			pageContext.setAttribute("user", user);
	%>
	<div id="sign"></div>
	<%
			DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			Key memobookKey = KeyFactory.createKey("Memobook", user.getEmail());
			Query query = new Query("Memo", memobookKey);

			int filterCount = 0;
			String yearStr = request.getParameter("fin_year_select");
			if (yearStr != null) {
				filterCount += addFinYearFilter(yearStr, query);
			}

			List<Entity> memos = datastore.prepare(query).asList(
					FetchOptions.Builder.withDefaults());

			String titleStr = request.getParameter("title");
			if (titleStr != null && titleStr.length() > 0)
				memos = filterProp(memos, "title", titleStr);

			String authorStr = request.getParameter("author");
			if (authorStr != null && authorStr.length() > 0)
				memos = filterProp(memos, "author", authorStr);

			if (request.getParameter("checked1") != null)
				memos = filterProp(memos, "check1", Long.valueOf(1));
			if (request.getParameter("checked2") != null)
				memos = filterProp(memos, "check2", Long.valueOf(1));
			if (request.getParameter("checked3") != null)
				memos = filterProp(memos, "check3", Long.valueOf(1));
	%>
	<div class="resultform">
		<div class="search_query">
			<div class="form_description result_description">
				<h2>List</h2>
				<div id="book_count">&#1161;</div>
				<%@include file="filter_input.html"%>
			</div>
			<%
				if (memos.isEmpty()) {
			%>
			<p>No results.</p>
			<%
				} else {
						StringWriter str = new StringWriter();
						boolean showCover = false;
						if (yearStr != null)
							showCover = true;
						printList(new PrintWriter(str), memos, showCover);
			%><%=str%>
			<%
				}
			%>
		</div>
	</div>
	<%
		} else { // if (user != null)
	%>
	<div id="sign">
		Google <a
			href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
			in</a>
	</div>
	<%
		}
	%>
</body>
</html>