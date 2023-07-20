package CustomBookmarkAgents;

import java.util.ArrayList;
import java.util.Collection;

import com.moonshine.domino.crud.CreateAgentBase;
import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.field.FieldType;
import com.moonshine.domino.security.*;
import com.moonshine.domino.util.DominoUtils;
import com.moonshine.domino.util.ParameterException;

import lotus.domino.*;

/**
 * Generated Code
 * Update {@link CustomBookmarkCreate} instead, so that this class can be replaced if necessary.
 */
public class CustomBookmarkCreateBase extends CreateAgentBase {
	protected String getFormName() {
		return "CustomBookmark";
	}
	 

	protected Collection<FieldDefinition> getFieldList() {
		Collection<FieldDefinition> fields = new ArrayList<FieldDefinition>();
		fields.add(new FieldDefinition("group", FieldType.TEXT, false));


		fields.add(new FieldDefinition("type", FieldType.TEXT, false));


		fields.add(new FieldDefinition("url", FieldType.TEXT, false));


		fields.add(new FieldDefinition("server", FieldType.TEXT, false));


		fields.add(new FieldDefinition("database", FieldType.TEXT, false));


		fields.add(new FieldDefinition("view", FieldType.TEXT, false));


		fields.add(new FieldDefinition("name", FieldType.TEXT, false));



		return fields;
	}
	

	protected Object getDocumentIdentifier() throws ParameterException {
		return null; // no uniqueness validation
		
		/* You can add uniqueness validation like this:
		Collection<FieldDefinition> keys = new ArrayList<FieldDefinition>();

		return getKeyRequired(keys);
		*/
	}
	

	protected View getLookupView() throws NotesException {
		return null; // no uniqueness validation
		
		/* If uniqueness validation is desired:
		try {
			return DominoUtils.getView(agentDatabase, "All By UNID/CRUD/CustomBookmark");
		}
		catch (Exception ex) {
			getLog().err("Could not open lookup view: ", ex);
			return null;
		}
		*/
	}
	 

	@Override
	protected Collection<FieldDefinition> getReturnFieldList() {
		Collection<FieldDefinition> fields = new ArrayList<FieldDefinition>();
		fields.add(new FieldDefinition("group", FieldType.TEXT, false));
		fields.add(new FieldDefinition("type", FieldType.TEXT, false));
		fields.add(new FieldDefinition("url", FieldType.TEXT, false));
		fields.add(new FieldDefinition("server", FieldType.TEXT, false));
		fields.add(new FieldDefinition("database", FieldType.TEXT, false));
		fields.add(new FieldDefinition("view", FieldType.TEXT, false));
		fields.add(new FieldDefinition("name", FieldType.TEXT, false));

		return fields;
		
	}
	

	protected void runAdditionalProcessing(Document document) {
		// nothing to do
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
	
	
	protected boolean shouldReturnUniversalID() {
		return true;
	}
}
