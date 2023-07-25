package CustomBookmarkAgents;

import org.json.JSONObject;

import genesis.LinkProcessor;
import lotus.domino.Document;
import lotus.domino.NotesException;

/**
 * Modify this class for custom changes to the agent.
 */
public class CustomBookmarkCreate extends CustomBookmarkCreateBase {

	@Override
    protected void writeNewDocument(Document document) throws NotesException {
    		super.writeNewDocument(document);
    		
    		// update with link logic
    		LinkProcessor linkProcessor = new LinkProcessor(session, getLog());
    		JSONObject link = (JSONObject) jsonRoot.get("document");
    		linkProcessor.cleanupLink(link);
	}
	
	@Override
	protected boolean useJSON() {
		//only support JSON
		// TODO:  throw an error instead
		return true;
	}
}
