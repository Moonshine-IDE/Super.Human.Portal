package CustomBookmarkAgents;

import java.util.Collection;

import org.json.JSONObject;

import com.moonshine.domino.security.SecurityInterface;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import genesis.LinkProcessor;
import lotus.domino.Document;
import lotus.domino.NotesException;

/**
 * Modify this class for custom changes to the agent.
 */
public class CustomBookmarkCreate extends CustomBookmarkCreateBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_BOOKMARKS_MANAGE;
	}
	
	public Collection<String> getAllowedRoles() {
		return SecurityBuilder.buildList(SecurityBuilder.ROLE_ADMINISTRATOR);
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}

	@Override
    protected void writeNewDocument(Document document) throws NotesException {
    		super.writeNewDocument(document);
    		
    		// update with link logic
    		LinkProcessor linkProcessor = new LinkProcessor(session, getLog(), agentDatabase);
    		linkProcessor.setAllowRemoteServer(true);
    		JSONObject link = (JSONObject) jsonRoot.get("document");
    		linkProcessor.cleanupLink(link);
	}
	
	@Override
	protected boolean useJSON() {
		//only support JSON
		// TODO:  throw an error instead
		return true;
	}
}
