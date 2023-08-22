package GenesisDirectoryAgents;

import java.util.Collection;

import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.util.CustomizationUtils;

/**
 * Modify this class for custom changes to the agent.
 */
public class GenesisDirectoryRead extends GenesisDirectoryReadBase {

    @Override
	protected Collection<FieldDefinition> getFieldList() {
		// exclude the password
		Collection<FieldDefinition> fields = super.getFieldList();
		CustomizationUtils.removeField(fields, "password");

		return fields;
	}
	
}
