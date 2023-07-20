package CustomBookmarkAgents;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;

import com.moonshine.domino.crud.GetAllAgentBase;
import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.field.FieldType;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;
import com.moonshine.domino.util.ParameterException;

import lotus.domino.*;

/**
 * Generated Code
 * Update {@link CustomBookmarkRead} instead, so that this class can be replaced if necessary.
 */
public class CustomBookmarkReadBase extends GetAllAgentBase {
	protected View getLookupView() throws NotesException {
		return agentDatabase.getView("All By UNID/CRUD/CustomBookmark");
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
	
	protected Object getFilterKey() throws ParameterException {
		Collection<FieldDefinition> keys = new ArrayList<FieldDefinition>();


		if (keys.size() <= 0) {
			keys.add(new FieldDefinition(getUniversalIDName(), FieldType.TEXT, false));
		}
		return getKeyOptional(keys);
	}
	
	protected void preprocessDocument(Document doc) {
		return;
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new AllowAllSecurity(session);
	}
	
	protected void cleanup()  {
		// nothing to add
	}
	
	
	protected boolean shouldReturnUniversalID() {
		return true;
	}
}
