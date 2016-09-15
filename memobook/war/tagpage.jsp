<%@include file="header.jsp" %>

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
    <script type="text/javascript" src="materialize/js/materialize.min.js"></script>
<%@include file="google_analytics.jsp"%>
  </head>

  <body id="main_body" >

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
	<div class="tag_cloud card-panel">
		<jsp:include page="/tagcloud.jsp" flush="true"></jsp:include>
	</div>

	<div class="search_query card-panel">
	<form id="tagsearchform" method="get" action="/tag.jsp">
	  <div class="input-field col s12">
		  <input placeholder="" id="findtag" name="findtag" class="element text medium" type="text" maxlength="255" value=""> 
		  <button class="btn waves-effect waves-light indigo" id="findtagsubmit" type="submit" value="Search">Search</button>
		  <label for="findtag">Search by Tags</label>
	  </div>
	</form>
	</div>

	<div id="sign">
        Logged in as ${fn:escapeXml(user.nickname)}.
        (You can <a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">log out</a>.)
	</div>

<% } else { %>
    <div class="logobox"><a href="<%= userService.createLoginURL(request.getRequestURI()) %>"><img src="/img/btn_google_signin_light_normal_web.png" alt=""></a></div>
<% } %>

  </body>
</html>