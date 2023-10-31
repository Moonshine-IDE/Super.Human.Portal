package CustomBookmarkAgents;

import java.util.Random;

import org.json.JSONArray;
import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.Database;
import lotus.domino.DbDirectory;
import lotus.domino.NotesException;

/**
 * Return a list of the databases on the server
 */
public class DatabaseRead extends CRUDAgentBase
{
	
	@Override
	protected void runAction() {
		DbDirectory directory = null;
		JSONArray json = null;
		try {
			directory = session.getDbDirectory("");
			json = new JSONArray();
			
			Database curDatabase = directory.getFirstDatabase(DbDirectory.TEMPLATE_CANDIDATE);   // include templates for now
			while (null != curDatabase) {
				String identifier = "UNKNOWN";
				try {
					identifier = curDatabase.getFilePath();
					json.put(getDatabaseJSON(curDatabase));
				}
				catch (Exception ex) {
					getLog().err("Could not process database '" + identifier + "': ", ex);
				}
				finally {
					Database prevDatabase = curDatabase;
					curDatabase = directory.getNextDatabase();
					DominoUtils.recycle(session, prevDatabase);
				}
			}
		}
		catch (NotesException ex) {
			getLog().err("Error when reading database directory:  ", ex);
		}
		finally {
			DominoUtils.recycle(session, directory);
			jsonRoot.put("databases", json);
		}
	}
	
	protected JSONObject getDatabaseJSON(Database db) throws NotesException, Exception {
		JSONObject json = new JSONObject();
		
		// this JSON is intended to be compatible with the database link logic
		json.put("name", db.getTitle());
		json.put("type", "database");
		json.put("server", db.getServer());
		json.put("database", db.getFilePath());
		json.put("view", "");  // no specific view by default
		
		// TODO:  generate the access URLs based on LinkProcessor logic
		json.put("url", "TODO");
		json.put("nomadURL", "TODO");
		
		// additional values
		// Replica is not needed for initial logic, but it may be useful later
		json.put("replicaID", db.getReplicaID());
		
		// properties to track existing values:
		// TODO:  compute these instead of using placeholders
		json.put("hasBookmarks", false); // new Random().nextBoolean());
		json.put("bookmarkCount", 0);
		json.put("bookmarks", new JSONArray());
		
		return json;
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new AllowAllSecurity(session);
	}
	
	@Override
	protected boolean useJSON() {
		// only support JSON for now
		return true;
	}
}