package CustomBookmarkAgents;

import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONObject;

import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import genesis.LinkProcessor;
import lotus.domino.Database;
import lotus.domino.NotesException;
import lotus.domino.View;
import lotus.domino.ViewEntryCollection;

/**
 * Modify this class for custom changes to the agent.
 */
public class CustomBookmarkRead extends CustomBookmarkReadBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_BOOKMARKS_VIEW;
	}
	
	public Collection<String> getAllowedRoles() {
		// return SecurityBuilder.buildList(SimpleRoleSecurity.ROLE_ALL);
		return null;  // use GetRoleRestrictionID
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}

	@Override
    protected void writeDocuments(ViewEntryCollection entries, Collection<FieldDefinition> fieldList) throws NotesException {
    		LinkProcessor linkProcessor = new LinkProcessor(session, getLog(), agentDatabase);
    		linkProcessor.setAllowRemoteServer(true);
    		
    		super.writeDocuments(entries, fieldList);
    		
    		JSONArray links = (JSONArray) jsonRoot.get(getDocumentCollectionName());
    		for (Object linkObj : links) {
    			JSONObject link = (JSONObject) linkObj;
    			linkProcessor.cleanupLink(link);
    		}
	}
	
	@Override
	protected boolean useJSON() {
		//only support JSON
		// TODO:  throw an error instead
		return true;
	}
	
	@Override
	protected View getLookupView() throws NotesException {
		String lookupID = getParameter("DominoUniversalID");
		if (!DominoUtils.isValueEmpty(lookupID)) {
			// The user is trying to lookup a document by ID
			return super.getLookupView();  // use the default view, which is sorted by universal ID
		}
		// Use a sorted view until UI handles sorting
		String viewName = "Bookmarks/FlatForAgent";
		try {
			String configViewName = ConfigurationUtils.getConfigAsString(agentDatabase, "bookmarks_view");
			if (DominoUtils.isValueEmpty(configViewName)) {
				getLog().dbg("Using default view name for bookmarks");
				
			}
			else {
				viewName = configViewName;
			}
		}
		catch (Exception ex) {
			getLog().err("Exception while reading lookup view");
		}
		return agentDatabase.getView(viewName);
	}
}
