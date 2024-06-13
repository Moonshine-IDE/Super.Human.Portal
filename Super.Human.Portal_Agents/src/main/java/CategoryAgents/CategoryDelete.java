package CategoryAgents;

import java.util.Collection;

import com.moonshine.domino.security.SecurityInterface;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;

/**
 * Modify this class for custom changes to the agent.
 */
public class CategoryDelete extends CategoryDeleteBase implements RoleRestrictedAgent {
	
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
}
