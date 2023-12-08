package CustomBookmarkAgents;

import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;

import org.json.JSONArray;
import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import genesis.LinkProcessor;
import lotus.domino.Database;
import lotus.domino.DbDirectory;
import lotus.domino.Document;
import lotus.domino.Name;
import lotus.domino.NotesException;
import lotus.domino.View;
import lotus.domino.ViewEntry;
import lotus.domino.ViewEntryCollection;

/**
 * Return a list of the databases on the server
 */
public class DatabaseRead extends CRUDAgentBase implements RoleRestrictedAgent
{
	
	protected Map<String, Collection<String> > bookmarkCache = null;
	
	public Collection<String> getAllowedRoles() {
		return SecurityBuilder.buildList(SimpleRoleSecurity.ROLE_ALL);
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}
	
	@Override
	protected void runAction() {
		DbDirectory directory = null;
		JSONArray json = null;
		try {
			cacheBookmarks();
			
			directory = session.getDbDirectory("");
			json = new JSONArray();
			
			Database curDatabase = directory.getFirstDatabase(DbDirectory.TEMPLATE_CANDIDATE);   // include templates for now
			while (null != curDatabase) {
				String identifier = "UNKNOWN";
				try {
					identifier = curDatabase.getFilePath();
					json.put(getDatabaseJSON(curDatabase));
					// // Use this to test only nested on only top-level entries
					// if (identifier.contains("/")) {
					// 	// json.put(getDatabaseJSON(curDatabase));
					// }
					// else {
					// 	json.put(getDatabaseJSON(curDatabase));
					// }
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
		
		// Generate the access URLs based on LinkProcessor logic
		// json.put("url", "TODO");
		// json.put("nomadURL", "TODO");
		LinkProcessor processor = new LinkProcessor(session, getLog(), agentDatabase);
		// set allowRemoteServer if we add support for reading other servers later
		processor.cleanupLink(json);
		
		// additional values
		// Replica is not needed for initial logic, but it may be useful later
		json.put("replicaID", db.getReplicaID());
		
		
		
		// properties to track existing values:
		Collection<String> bookmarks = getBookmarks(db.getServer(), db.getFilePath());
		boolean hasBookmarks = null != bookmarks && !bookmarks.isEmpty();
		json.put("hasBookmarks", hasBookmarks); 
		if (hasBookmarks) {
			json.put("bookmarkCount", bookmarks.size());
			JSONArray array = new JSONArray();
			for (String bookmark : bookmarks) {
				array.put(bookmark);
			}
			json.put("bookmarks", array);
		}
		else {
			json.put("bookmarkCount", 0);
			json.put("bookmarks", new JSONArray());
		}
		
		return json;
	}
	
	protected void cacheBookmarks() {
		bookmarkCache = new TreeMap<String, Collection<String> >();
		View bookmarkView = null;
		ViewEntryCollection entries = null;
		try {
			bookmarkView = DominoUtils.getView(getTargetDatabase(), "All By UNID/CRUD/CustomBookmark");
			entries = bookmarkView.getAllEntries();
			ViewEntry curEntry = entries.getFirstEntry();
			while (null != curEntry) {
				Document bookmarkDoc = null;
				try {
					bookmarkDoc = curEntry.getDocument();
					String type = bookmarkDoc.getItemValueString("type");
					if (null != type && type.equalsIgnoreCase("database")) {
						String server = bookmarkDoc.getItemValueString("server");
						String dbName = bookmarkDoc.getItemValueString("database");
						String key = buildDatabaseLookupString(server, dbName);
						getLog().dbg("Key:  '" + key + "'.");
						Collection<String> bookmarks = bookmarkCache.get(key);
						if (null == bookmarks) {
							bookmarks = new TreeSet<String>();
							bookmarkCache.put(key, bookmarks);
						}
						bookmarks.add(bookmarkDoc.getUniversalID());
					}
					// else:  skip other bookmark types
				}
				finally {
					ViewEntry prevEntry = curEntry;
					curEntry = entries.getNextEntry();
					
					DominoUtils.recycle(session, bookmarkDoc);
					DominoUtils.recycle(session, prevEntry);
				}
			}
		}
		catch (Exception ex) {
			getLog().err("Failed to load bookmarks:  ", ex);
		}
	}
	
	protected String buildDatabaseLookupString(String server, String dbName) {
		// avoid NullPointerException
		if (null == server) {
			server = "";
		}
		if (null == dbName) {
			dbName = "";
		}
		
		return getCommonName(server).toLowerCase() + "!" + dbName.trim().toLowerCase();
	}
	
	protected String getCommonName(String serverName) {
		if (null == serverName) {
			return "";
		}
		
		Name name = null;
		try {
			name = session.createName(serverName);
			return name.getCommon();
		}
		catch (NotesException ex) {
			getLog().err("Error in getCommonName:  ", ex);
			return "";
		}
	}
	
	protected Collection<String> getBookmarks(String server, String dbName) {
		String key = buildDatabaseLookupString(server, dbName);
		getLog().dbg("Key:  '" + key + "'.");
		return bookmarkCache.get(key);
	}
	
	@Override
	protected boolean useJSON() {
		// only support JSON for now
		return true;
	}
}