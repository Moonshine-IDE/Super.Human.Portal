package GenesisDirectoryAgents;

import java.util.Collection;

import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.util.CustomizationUtils;

/**
 * Modify this class for custom changes to the agent.
 */
public class GenesisDirectoryCreate extends GenesisDirectoryCreateBase {

    // No modifications by default
	@Override
	protected Collection<FieldDefinition> getReturnFieldList() {
		Collection<FieldDefinition> fields = super.getReturnFieldList();
		CustomizationUtils.removeField(fields, "password");

		return fields;
		
	}
}
