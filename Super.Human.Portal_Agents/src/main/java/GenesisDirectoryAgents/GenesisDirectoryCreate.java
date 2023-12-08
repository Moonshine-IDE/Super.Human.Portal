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
public class GenesisDirectoryCreate extends GenesisDirectoryCreateBase implements RoleRestrictedAgent {
	
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

    // No modifications by default
	@Override
	protected Collection<FieldDefinition> getReturnFieldList() {
		Collection<FieldDefinition> fields = super.getReturnFieldList();
		CustomizationUtils.removeField(fields, "password");

		return fields;
		
	}
}
