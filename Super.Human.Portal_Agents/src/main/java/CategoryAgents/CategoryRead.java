package CategoryAgents;

import java.util.Collection;

import com.moonshine.domino.security.SecurityInterface;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import lotus.domino.NotesException;
import lotus.domino.View;

/**
 * Modify this class for custom changes to the agent.
 */
public class CategoryRead extends CategoryReadBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_DOCUMENTATION_VIEW;
	}
	
	public Collection<String> getAllowedRoles() {
		return SecurityBuilder.buildList(SimpleRoleSecurity.ROLE_ALL);
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}
	
	
	@Override
	protected View getLookupView() throws NotesException {
		return agentDatabase.getView("Categories/Ordered");   // use sorting
	}
}
