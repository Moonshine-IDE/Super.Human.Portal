package GenesisDirectoryAgents;

import java.util.Collection;

import com.moonshine.domino.security.SecurityInterface;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;

/**
 * Modify this class for custom changes to the agent.
 */
public class GenesisDirectoryUpdate extends GenesisDirectoryUpdateBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_GENESIS_MANAGE;
	}
	
	public Collection<String> getAllowedRoles() {
		//return SecurityBuilder.buildList(SecurityBuilder.ROLE_ADMINISTRATOR);
		return null;  // use getRoleRestrictionID
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}

    // No modifications by default
}
