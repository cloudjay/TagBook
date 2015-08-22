<%! // google datastore functions %>

<%@include file="header.jsp" %>

<%!
public List<Entity> getMemos(User user) {
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    Key memobookKey = KeyFactory.createKey("Memobook", user.getEmail());
    Query query = new Query("Memo", memobookKey);
    return datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
}
%>

<%!
public int addFinYearFilter(String yearStr, Query query) {
    Integer finYear = Integer.parseInt(yearStr);
	Calendar cs = Calendar.getInstance();
	Calendar cf = Calendar.getInstance();
	cs.set(finYear, 0, 1, 0, 0);
	cf.set(finYear, 11, 31);
	ArrayList<Query.Filter> l = new ArrayList<Query.Filter>();
	l.add(FilterOperator.GREATER_THAN_OR_EQUAL.of("DateEnd", cs.getTime()));
	l.add(FilterOperator.LESS_THAN_OR_EQUAL.of("DateEnd", cf.getTime()));
	query.setFilter(CompositeFilterOperator.and(l));
	return 1;
}
%>

<%!
public int addTagsFilter(String[] tags, Query query) {
    ArrayList<Query.Filter> l = new ArrayList<Query.Filter>();
    for (String t : tags) {
    	if (t.trim().length()>0) {
    		l.add(FilterOperator.EQUAL.of("tag", t));
    	}
    }
    if (l.size() > 1) {
        query.setFilter(CompositeFilterOperator.and(l));
        return 1;
    } else if (l.size() == 1) {
    	query.setFilter(l.get(0));
    	return 1;
    }
	return 0;
}
%>

<%!
public List<Entity> filterProp(List<Entity> memos, String propName, String propMatch) {
	ArrayList<Entity> filtered = new ArrayList<Entity>();
	for (Entity m : memos) {
		String t = (String)m.getProperty(propName);
		if (t == null)
			continue;
		if (t.toUpperCase().indexOf(propMatch.toUpperCase()) != -1) {
			filtered.add(m);		
		}
	}
	return filtered;
}
%>

<%!
public List<Entity> filterProp(List<Entity> memos, String propName, Long propMatch) {
	ArrayList<Entity> filtered = new ArrayList<Entity>();
	for (Entity m : memos) {
		Long t = (Long)m.getProperty(propName);
		if (t == null)
			continue;
		if (t.equals(propMatch)) {
			filtered.add(m);		
		}
	}
	return filtered;
}
%>
