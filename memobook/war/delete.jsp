<%@include file="header.jsp" %>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
    	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
        Key		bookKey		= KeyFactory.createKey("Memobook", user.getEmail());
        Query	query		= new Query("Memo", bookKey);
        String	isbn		= request.getParameter("isbn");
        Filter	isbnFilter	= new FilterPredicate("isbn", FilterOperator.EQUAL, isbn);
        query.setFilter(isbnFilter);
        Iterable<Entity> memos = datastore.prepare(query).asIterable();
        for (Entity memo : memos) {
        	datastore.delete(memo.getKey());
        }
    }
%>

<script type="text/javascript">
window.location.href = document.referrer;
</script>