package CustomBookmarkAgents;

import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONObject;

import com.moonshine.domino.field.FieldDefinition;

import genesis.LinkProcessor;
import lotus.domino.NotesException;
import lotus.domino.ViewEntryCollection;

/**
 * Modify this class for custom changes to the agent.
 */
public class CustomBookmarkRead extends CustomBookmarkReadBase {

	@Override
    protected void writeDocuments(ViewEntryCollection entries, Collection<FieldDefinition> fieldList) throws NotesException {
    		LinkProcessor linkProcessor = new LinkProcessor(session, getLog());
    		linkProcessor.setAllowRemoteServer(true);
    		
    		super.writeDocuments(entries, fieldList);
    		
    		JSONArray links = (JSONArray) jsonRoot.get(getDocumentCollectionName());
    		for (Object linkObj : links) {
    			JSONObject link = (JSONObject) linkObj;
    			linkProcessor.cleanupLink(link);
    		}
	}
	
	@Override
	protected boolean useJSON() {
		//only support JSON
		// TODO:  throw an error instead
		return true;
	}
}
