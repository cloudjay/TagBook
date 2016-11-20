<%@include file="header.jsp" %>
<%! @SuppressWarnings("unchecked") %>

<!DOCTYPE html>
<html>
  <head>
    <title>Tag book</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=2.0, user-scalable=yes" />
    <link rel="icon" type="image/png" href="/favicon.png"/>
    <link rel="apple-touch-startup-image" href="/startup.png"/>
    <link rel="apple-touch-icon" href="/apple-touch-icon.png"/>
    <link rel="stylesheet" type="text/css" href="view.css" media="Screen"/>
    <link media="handheld, only screen and (max-width: 480px), only screen and (max-device-width: 480px)" href="mobile.css" type="text/css" rel="stylesheet" />
	<link type="text/css" rel="stylesheet" href="materialize/css/materialize.css"  media="screen,projection"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">    
<%@include file="header_jquery.jsp"%>
    <script type="text/javascript" src="view.js"></script>
    <script type="text/javascript" src="search.js"></script>
    <script type="text/javascript" src="calendar.js"></script>
<%@include file="google_analytics.jsp"%>
  </head>

  <body id="main_body" >
	<!-- >div class="logobox"><div id="logo">
        <a href="/"><i class="material-icons" style="line-height: 60px">view_headline</i></a>
        <a href="/tagpage"><i class="small material-icons">label_outline</i></a>
	</div></div -->
	
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
    Long rating = new Long(0);
    int check1 = 0;
    int check2 = 0;
    int check3 = 0;
    if (request.getParameter("isbn") != null)
    {  // Find and fill page context
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key memobookKey  = KeyFactory.createKey("Memobook", user.getEmail());
        Filter isbnFilter = new FilterPredicate("isbn", FilterOperator.EQUAL, request.getParameter("isbn"));    
        Query query       = new Query("Memo", memobookKey).setFilter(isbnFilter);
        Iterable<Entity> memos = datastore.prepare(query).asIterable();
		if (memos.iterator().hasNext())
		{
			Entity memo = memos.iterator().next();
			if (memo.hasProperty("title"))
				pageContext.setAttribute("title", memo.getProperty("title"));
			if (memo.hasProperty("author"))
				pageContext.setAttribute("author", memo.getProperty("author"));
			if (memo.hasProperty("isbn"))
				pageContext.setAttribute("isbn", memo.getProperty("isbn"));
			if (memo.hasProperty("tag") && memo.getProperty("tag") != null)
			{
				ArrayList<String> tagSet = (ArrayList<String>)memo.getProperty("tag");
				Iterator<String> it = tagSet.iterator();
				String tagString = "";
				while (it.hasNext())
				{
					tagString += it.next();
					tagString += " ";
				}
				if (tagString.length() > 0)
					pageContext.setAttribute("tag", tagString);
			}
			if (memo.hasProperty("memo"))
				pageContext.setAttribute("memo", memo.getProperty("memo"));
			if (memo.hasProperty("publisher"))
				pageContext.setAttribute("publisher", memo.getProperty("publisher"));
			if (memo.hasProperty("DateStart"))
			{
				Date d = (Date)memo.getProperty("DateStart");
				Calendar c = Calendar.getInstance();
				c.setTime(d);
				pageContext.setAttribute("MM", c.get(Calendar.MONTH)+1);
				pageContext.setAttribute("DD", c.get(Calendar.DATE));
				pageContext.setAttribute("YYYY", c.get(Calendar.YEAR));
			}
			if (memo.hasProperty("DateStart"))
			{
				Date d = (Date)memo.getProperty("DateStart");
				Calendar c = Calendar.getInstance();
				c.setTime(d);
				pageContext.setAttribute("MM", c.get(Calendar.MONTH)+1);
				pageContext.setAttribute("DD", c.get(Calendar.DATE));
				pageContext.setAttribute("YYYY", c.get(Calendar.YEAR));
			}
			if (memo.hasProperty("DateEnd"))
			{
				Date d = (Date)memo.getProperty("DateEnd");
				Calendar c = Calendar.getInstance();
				c.setTime(d);
				pageContext.setAttribute("MMe", c.get(Calendar.MONTH)+1);
				pageContext.setAttribute("DDe", c.get(Calendar.DATE));
				pageContext.setAttribute("YYYYe", c.get(Calendar.YEAR));
			}
			if (memo.hasProperty("rating"))
				rating = (Long)memo.getProperty("rating");
			if (memo.hasProperty("check1"))	check1 = 1;
			if (memo.hasProperty("check2"))	check2 = 1;
			if (memo.hasProperty("check3"))	check3 = 1;			
		}
    }
%>

	<div class="searchform">
	  <div class="search_query">
		<div class="form_description"><h2>Daum book search</h2></div>	
		<input id="q" name="q" class="element text medium" type="text" maxlength="255" value=""
			onkeydown="if (event.keyCode == 13) document.getElementById('b').click()"/> 
		<input id="b" type="submit" value="Search"/>
		<div id="r" class="search_result"></div>
	  </div>
	</div>

	<div id="form_container" class="hidden" style="display:none;">
		<div id="preview_img"></div>
		<form id="form_534097" class="appnitro"  method="post" action="/sign">
			<div class="form_description"><h2>Input</h2></div>
			<ul>
		    		<li id="li_1" >
		<label class="description" for="title">Title </label>
		<div>
			<input id="title" name="title" class="element text medium" type="text" maxlength="255" value="${fn:escapeXml(title)}"/> 
		</div> 
		</li>		<li id="li_5" >
		<label class="description" for="isbn">ISBN </label>
		<div>
			<input id="isbn" name="isbn" class="element text medium" type="text" maxlength="255" value="${fn:escapeXml(isbn)}"/> 
		</div> 
		</li>		<li id="li_6" >
		<label class="description" for="author">Author </label>
		<div>
			<input id="author" name="author" class="element text medium" type="text" maxlength="255" value="${fn:escapeXml(author)}"/> 
		</div> 
		</li>		<li id="li_7" >
		<label class="description" for="publisher">Publisher </label>
		<div>
			<input id="publisher" name="publisher" class="element text medium" type="text" maxlength="255" value="${fn:escapeXml(publisher)}"/> 
		</div> 
		</li>		<li id="li_3" >
		<label class="description" for="memo">Memo </label>
		<div>
			<textarea id="memo" name="memo" class="element textarea medium">${fn:escapeXml(memo)}</textarea> 
		</div>
		</li>		<li id="li_star">
		<label class="description" for="memo">Rating &amp; Flags</label>
			<input name="star1" id="star1_2" type="radio" class="star" value="2"	<%if(rating.intValue()==2) {%>checked='checked'<%}%>/>
			<input name="star1" id="star1_4" type="radio" class="star" value="4"	<%if(rating.intValue()==4) {%>checked='checked'<%}%>/>
			<input name="star1" id="star1_6" type="radio" class="star" value="6"	<%if(rating.intValue()==6) {%>checked='checked'<%}%>/>
			<input name="star1" id="star1_8" type="radio" class="star" value="8"	<%if(rating.intValue()==8) {%>checked='checked'<%}%>/>
			<input name="star1" id="star1_10" type="radio" class="star" value="10"	<%if(rating.intValue()==10){%>checked='checked'<%}%>/>
			<input type='checkbox' name='check1' value='1' id="check1" <%if(check1==1){%>checked='checked'<%}%> /><label for="check1"></label>
			<input type='checkbox' name='check2' value='1' id="check2" <%if(check2==1){%>checked='checked'<%}%> /><label for="check2"></label>
			<input type='checkbox' name='check3' value='1' id="check3" <%if(check3==1){%>checked='checked'<%}%> /><label for="check3"></label>
		</li>		<li id="li_2" >
		<label class="description" for="element_2_1">Start date</label>
		<span>
			<input id="element_2_1" name="MM" class="element text" size="2" maxlength="2" value="${fn:escapeXml(MM)}" type="text">
			<label for="element_2_1">MM</label>
		</span>
		<span>
			<input id="element_2_2" name="DD" class="element text" size="2" maxlength="2" value="${fn:escapeXml(DD)}" type="text">
			<label for="element_2_2">DD</label>
		</span>
		<span>
	 		<input id="element_2_3" name="YYYY" class="element text" size="4" maxlength="4" value="${fn:escapeXml(YYYY)}" type="text">
			<label for="element_2_3">YYYY</label>
		</span>
	
		<span id="calendar_2">
			<img id="cal_img_2" class="datepicker" src="/img/calendar.gif" alt="Pick a date.">	
		</span>

		<input type="button" onclick="fill_today(1);" value="Today" />

		<script type="text/javascript">
			Calendar.setup({
			inputField	 : "element_2_3",
			baseField    : "element_2",
			displayArea  : "calendar_2",
			button		 : "cal_img_2",
			ifFormat	 : "%B %e, %Y",
			onSelect	 : selectDate
			});
		</script>

		</li>		<li id="li_8" >
		<label class="description" for="element_8_1">Finish date</label>
		<span>
			<input id="element_8_1" name="MMe" class="element text" size="2" maxlength="2" value="${fn:escapeXml(MMe)}" type="text">
			<label for="element_8_1">MM</label>
		</span>
		<span>
			<input id="element_8_2" name="DDe" class="element text" size="2" maxlength="2" value="${fn:escapeXml(DDe)}" type="text">
			<label for="element_8_2">DD</label>
		</span>
		<span>
	 		<input id="element_8_3" name="YYYYe" class="element text" size="4" maxlength="4" value="${fn:escapeXml(YYYYe)}" type="text">
			<label for="element_8_3">YYYY</label>
		</span>
	
		<span id="calendar_3">
			<img id="cal_img_3" class="datepicker" src="/img/calendar.gif" alt="Pick a date.">	
		</span>
		
		<input type="button" onclick="fill_today(2);" value="Today"/>
		
		<script type="text/javascript">
			Calendar.setup({
			inputField	 : "element_8_3",
			baseField    : "element_8",
			displayArea  : "calendar_3",
			button		 : "cal_img_3",
			ifFormat	 : "%B %e, %Y",
			onSelect	 : selectDate
			});
		</script>

		</li>		<li id="li_4" >
		<label class="description" for="tags">Tags </label>
		<div>
			<input id="tags" name="tags" class="element text large" type="text" maxlength="255" value="${fn:escapeXml(tag)}"/> 
		</div> 
		</li>
					<li class="buttons">
			    <input type="hidden" name="form_id" value="534097" />
				<input id="saveForm" class="button_text" type="submit" name="submit" value="Post" />
		</li>
			</ul>
		</form>	
		<div id="footer"></div>
	</div>

	<div class="searchform">
	  <div class="search_query">
	    <div class="form_description"><h2>List</h2></div>	    
	    <form id="yearform" method="get" action="/list.jsp">
	      <label class="description" for="fin_year_select">Finish year</label>
	      <select name="fin_year_select" id="fin_year_select"></select>
	      <input type="submit" value="List"/>
	    </form>

	    <form id="flagform" method="get" action="/list.jsp">
			<label class="description" for="flagsubmit">Flags</label>
			<input type='checkbox' name='checked1' value='1' id="listcheck1"/><label for="listcheck1"></label>
			<input type='checkbox' name='checked2' value='1' id="listcheck2"/><label for="listcheck2"></label>
			<input type='checkbox' name='checked3' value='1' id="listcheck3"/><label for="listcheck3"></label>	      
			<input type="submit" id="flagsubmit" value="List"/>
	    </form>

	    <form id="titleform" method="get" action="/list.jsp">
	      <label class="description" for="list_title">Title</label>
	      <input id="list_title" name="title" class="element text medium" type="text" maxlength="255"/>
	      <input type="submit" value="List"/>
	    </form>

	    <form id="authorform" method="get" action="/list.jsp">
	      <label class="description" for="list_author">Author</label>
	      <input id="list_author" name="author" class="element text medium" type="text" maxlength="255"/>
	      <input type="submit" value="List"/>
	    </form>
	    
	    <label class="description" for="list_everything">Everything; could be a very long list.</label>
	    <input type="button" value="List of every book" id="list_everything" onclick="window.location='/list.jsp'"/>
	    <input type="button" value="Dump to CSV" id="dump_csv" onclick="window.location='/dumpcsv'"/>
	    
	  </div>
	</div>

	<img id="bottom" src="/img/bottom.png" alt="">
	<div id="sign">
        Logged in as ${fn:escapeXml(user.nickname)}.
        (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">log out</a>.)
	</div>

<% } else { %>
    <div class="logobox"><a href="<%= userService.createLoginURL(request.getRequestURI()) %>"><img src="/img/btn_google_signin_light_normal_web.png" alt=""></a></div>
<% } %>

  </body>
</html>