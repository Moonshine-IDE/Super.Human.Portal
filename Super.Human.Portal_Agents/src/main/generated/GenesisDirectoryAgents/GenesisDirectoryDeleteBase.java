package GenesisDirectoryAgents;


import com.moonshine.domino.crud.DeleteAgentBase;
import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.field.FieldType;
import com.moonshine.domino.security.*;
import com.moonshine.domino.util.DominoUtils;
import com.moonshine.domino.util.ParameterException;

import java.util.ArrayList;
import java.util.Collection;

import lotus.domino.*;

/**
 * Generated Code
 * Update {@link GenesisDirectoryDelete} instead, so that this class can be replaced if necessary.
 */
public class GenesisDirectoryDeleteBase extends DeleteAgentBase {
	

	protected Object getDocumentIdentifier() throws ParameterException {
		Collection<FieldDefinition> keys = new ArrayList<FieldDefinition>();
		// use Domino universal ID as the key
		keys.add(new FieldDefinition(getUniversalIDName(), FieldType.TEXT, false));
		
		/* You can use custom keys like this

         */
		return getKeyRequired(keys);
	}
	

	protected View getLookupView() throws NotesException {
		return null;  // universalID lookup
		
		/* For custom keys
		try {
			return DominoUtils.getView(agentDatabase, "All By UNID/CRUD/GenesisDirectory");
		}
		catch (Exception ex) {
			getLog().err("Could not open lookup view: ", ex);
			return null;
		}
		*/
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new AllowAllSecurity(session);
	}
	
	/**
	 * Cleanup any Domino API objects created by this agent
	 */
	protected void cleanup() {
		// nothing to do
	}
}
