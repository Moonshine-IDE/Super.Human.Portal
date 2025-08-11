package GenesisDirectoryAgents;

import java.util.Collection;

import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.CustomizationUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;

/**
 * Modify this class for custom changes to the agent.
 */
public class GenesisDirectoryRead extends GenesisDirectoryReadBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_GENESIS_MANAGE;
	}
	
	public Collection<String> getAllowedRoles() {
		// return SecurityBuilder.buildList(SecurityBuilder.ROLE_ADMINISTRATOR);
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
	protected Collection<FieldDefinition> getFieldList() {
		// exclude the password
		Collection<FieldDefinition> fields = super.getFieldList();
		CustomizationUtils.removeField(fields, "password");

		return fields;
	}
	
}
