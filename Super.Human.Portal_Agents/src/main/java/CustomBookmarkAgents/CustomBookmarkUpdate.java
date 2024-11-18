package CustomBookmarkAgents;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.json.JSONObject;

import com.moonshine.domino.field.FieldDefinition;
import com.moonshine.domino.field.FieldType;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;
import com.moonshine.domino.util.ParameterException;
import com.moonshine.domino.util.PublicException;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import genesis.LinkProcessor;
import lotus.domino.Database;
import lotus.domino.Document;
import lotus.domino.NotesException;
import lotus.domino.View;

/**
 * Modify this class for custom changes to the agent.
 */
public class CustomBookmarkUpdate extends CustomBookmarkUpdateBase implements RoleRestrictedAgent {
	
	public String getRoleRestrictionID() {
		return SecurityBuilder.RESTRICT_BOOKMARKS_MANAGE;
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

    /**
     * Override the default logic to return the document after edits
     * TODO:  cleanup the API so that this doesn't require so many modifications'
     */
	@Override
	protected void runAction() {
		View lookupView = null;
		Document existingDocument = null;
		try {
			
			// Lookup first - this might be needed for validation
			Object id = getDocumentIdentifier();
			if (null == id ||
				DominoUtils.isValueEmpty(id.toString()) || 
				(id instanceof List && DominoUtils.isListEmpty((List) id))
			) {
				throw new PublicException("Lookup key is invalid:  '" + id.toString() + "'.");
			}
			
			//getLog().dbg("Document lookup key:  " + id);
			lookupView = getLookupView();
			if (null == lookupView) { // lookup by universalID
				Database database = getTargetDatabase();   // this should be recycled separately, since it could be the main agent database
				if (!DominoUtils.isDatabaseOpen(database)) {
					throw new PublicException("Unable to open database.");
					
				}
				String docID = id.toString();
				if (id instanceof List && ((List) id).size() >= 1) {
					// use the first element of the list.  This is unexpected, but allow it
					docID = ((List) id).get(0).toString();
				}
				
				existingDocument = database.getDocumentByUNID(docID);
			}
			else { // lookup by view
				existingDocument = lookupView.getDocumentByKey(id, true);
			}
			
			if (null == existingDocument) {
				getLog().err("Document '" + id + "' does not exist.");
				reportError("Document '" + id + "' does not exist.");
				return;
			}
			getLog().dbg("Found document " + existingDocument.getUniversalID());
			
			// check security before doing any additional processing on the document
			// TODO:  does this need a separate method?
			if (!getSecurity().allowAccess(existingDocument)) {
				reportError("You do not have permission to update this document.");
				return;
			}
			
			// validate the updates
			String message = validate();
			if (null != message) {  // allow "" to only populate the validation error messages.
				reportError(message);
				// validation XML already written
				return;
			}
			
			// make updates
			populateAgentFields(existingDocument);
			
			// check security again before doing any additional processing on the document
			if (!getSecurity().allowAccess(existingDocument)) {
				reportError("You do not have permission to make these updates to this document.");
				return;
			}
			
			runAdditionalProcessing(existingDocument);
			try {
				existingDocument.computeWithForm(false, true);  // return an exception on an error
			} 
			catch (NotesException ex) {
				reportError("Failed form-level validation.");
				getLog().err("computeWithForm failed:  ", ex);
				return;
			}
			
			// write the changes before saving - I have seen the document become unusable after saving
			writeUpdatedDocument(existingDocument);
			
			// save the document
			boolean successful = existingDocument.save(true);  // force the document save - this shouldn't be a problem for new documents.
			if (!successful) {
				reportError("Failed to save the new document.");
				return;
			}
			
			
		}
		catch (PublicException ex) {
			getLog().err("Public error in agent:  ", ex);
			reportError(ex.getPublicError());
		}
		catch (Exception ex) {
			getLog().err("Unexpected error in agent:  ", ex);
			reportError("Unexpected error in agent.");
		}
		finally {
			writeValidationMessages();
			
			DominoUtils.recycle(session, existingDocument);
			DominoUtils.recycle(session, lookupView);
		}
	}
	
	/**
	 * Write the created document to the response
	 * @param document the original created document
	 * @throws NotesException if an error occurs while reading the document
	 */
	protected void writeUpdatedDocument(Document document) throws NotesException {
		// TODO: need to reopen the document?
		if (useJSON()) {
			jsonRoot.put("document", getDocumentJSON(document, getReturnFieldList()));
		}
		else {
			writeDocumentXML(document, getReturnFieldList(), xmlRoot);
		}
    		
    		// update with link logic
    		LinkProcessor linkProcessor = new LinkProcessor(session, getLog(), agentDatabase);
    		linkProcessor.setAllowRemoteServer(true);
    		JSONObject link = (JSONObject) jsonRoot.get("document");
    		linkProcessor.cleanupLink(link);
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
		fields.add(new FieldDefinition("index", FieldType.TEXT, false));
		fields.add(new FieldDefinition("description", FieldType.TEXT, false));

		return fields;
		
	}
	
	@Override
	protected boolean shouldReturnUniversalID() {
		return true;
	}
}
