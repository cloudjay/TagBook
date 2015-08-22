package memobook;

import java.util.*;

import com.google.appengine.api.datastore.Entity;
import com.google.appengine.tools.mapreduce.Mapper;


public class CountRelativeTagMapper extends Mapper<Entity, String, Long> {
	
	private static final long serialVersionUID = 1L;
	
	CountRelativeTagMapper() {}
	
	private void incrementCounter(String t, String ot) {
	    getContext().getCounter(ot+","+t).increment(1);
	}
	
	@Override
	public void map(Entity entity) {
    	@SuppressWarnings("unchecked")
		ArrayList<String> tagSet = (ArrayList<String>)entity.getProperty("tag");
    	if (tagSet != null) {
			@SuppressWarnings("unchecked")
			ArrayList<String> otherTagSet = (ArrayList<String>) tagSet.clone();
    		for (String t : tagSet) {
    			for (String ot: otherTagSet) {
    				if (ot.equals(t)) continue;
    				incrementCounter(t, ot);
    			}
    		}
    	}		
	}
}
