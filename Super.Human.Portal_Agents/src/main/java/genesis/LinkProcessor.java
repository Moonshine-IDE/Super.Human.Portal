package genesis;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Map;
import java.util.TreeMap;
import java.util.regex.Pattern;

import org.json.JSONException;
import org.json.JSONObject;

import com.moonshine.domino.log.LogInterface;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.Name;
import lotus.domino.NotesException;
import lotus.domino.Session;
import util.JSONUtils;

public class LinkProcessor  
{
	protected Session session = null;
	protected LogInterface log = null;
	
	protected String serverAbbr = null;
	protected String serverCommon = null;
	
	protected static final Pattern notesURLPattern = Pattern.compile("notes://([^/]+)/([^?]+.nsf)(?:/[^/?])?(?:.*)?$", Pattern.CASE_INSENSITIVE);
	/** Detect a URI based on the protocol only.  The rest of the URL does not have to be valid */
	protected static final Pattern uriPattern = Pattern.compile("^\\w+://.*$", Pattern.CASE_INSENSITIVE);
	
	protected Map<String, String> insertionParameters = new TreeMap<String, String>();
	
	public LinkProcessor(Session session, LogInterface log)
	{
		this.session = session;
		this.log = log;
		
		initializeInsertionParameters();
	}
	
	protected LogInterface getLog() {
		return log;
	}
    
    protected void cleanupLink(JSONObject link) {
    		String identifier = "UNKNOWN";
    		try {
    			identifier = JSONUtils.getStringSafe(link, "name");
    			String type = JSONUtils.getStringSafe(link, "type");
    			if (null != type && type.equalsIgnoreCase("database")) {
    				// Update database links so that they can work in Super.Human.Portal
    				String database = JSONUtils.getStringSafe(link, "database");
    				if (DominoUtils.isValueEmpty(database)) {
    					//  TODO:  remove this early workaround - we had not decided on the format yet.
    					database = JSONUtils.getStringSafe(link, "url");
    					
    					// TODO: cleanup the URL format before setting database
    					link.put("database", database);
    				}
    				
				if (isDatabaseName(database)) {
					String origURL = JSONUtils.getStringSafe(link, "url");
					if (DominoUtils.isValueEmpty(origURL) || isDatabaseName(origURL)) {
						// build a notes:// URL based on the database
						// This will be obsolete once the url logic is updated in the Genesis API
						
						// URL-encode the database name
						String databaseEnc = database;
						try {
							databaseEnc = URLEncoder.encode(database, "utf-8");
						}
						catch (UnsupportedEncodingException ex) {
							getLog().err("Encoding exception:  ", ex);
						}
						
						// TODO:  handle the FQDN in a better way?  The format is enforces for Super.Human.Installer, but we'll needs something more generic for other servers.
						String url = "notes://" + serverCommon + "/" + databaseEnc;
						// Add view if available
						String view = JSONUtils.getStringSafe(link, "view");
						if (!DominoUtils.isValueEmpty(view)) {
							try {
								url += "/" + URLEncoder.encode(view, "utf-8") + "?OpenView";
							}
							catch (UnsupportedEncodingException ex) {
								getLog().err("Encoding exception:  ", ex);
							}
						}
						link.put("url", url);
					}
					// else: url was already set "properly", so keep the original value
					
				}
				// else:  not a database.  No way to populate the url anyway
				
				String nomadURL = JSONUtils.getStringSafe(link, "nomadURL");
				if (DominoUtils.isValueEmpty(nomadURL)) {
					// Compute the Nomad URL
					// https://nomadweb.%SERVER_COMMON%/nomad/#/%NOTES_URL%
					String url = JSONUtils.getStringSafe(link, "url");
					if (!DominoUtils.isValueEmpty(url)) {
						nomadURL = "https://nomadweb." + serverCommon + "/nomad/#/" + url;
						link.put("nomadURL", nomadURL);
					}
					// else:  if we could not generate a Notes URL, we can't generate a Nomad URL.
					
				}
				
				// add local server name
				link.put("server", serverAbbr);
				
				// // This was added to test the GUI logic for views.  Remove this and configure a real example
				// link.put("view", "Configuration");
    			}
    			
    			
				
			// Replace insertion parameters
			// Note that not all of these properties will exist for all links
			// ignore type
			// name, server, and database are overkill, but I include this for future changes.
			processInsertionParameters(link, "name");
			processInsertionParameters(link, "description");
			processInsertionParameters(link, "server");
			processInsertionParameters(link, "database");
			processInsertionParameters(link, "view");
			processInsertionParameters(link, "url");
			processInsertionParameters(link, "nomadURL");
    			
			
			// temporary test data for #19
			String description = JSONUtils.getStringSafe(link, "description");
			String url = JSONUtils.getStringSafe(link, "url");
			if (DominoUtils.isValueEmpty(description) &&
				(!DominoUtils.isValueEmpty(url) && (url.contains("Super.Human.Portal") || url.contains("SuperHumanPortal")))) {
				link.put("description", "This is an example link description for Super.Human.Portal.");
			}
    			
		}
		catch (JSONException ex) {
			getLog().err("Error when processing link '" + identifier + "':  ", ex);
		}
    }
    
    /**
     * Check if this valid is a valid database name (including an optional path).  Rejects URIs.
     */
    protected boolean isDatabaseName(String value) {
    		if ( DominoUtils.isValueEmpty(value)) {
			return false;
    		} 
    		if (!value.toLowerCase().endsWith(".nsf")) {
    			return false;
    		}
    		
    		// check for URI with a defined scheme (i.e https:// or notes://)
    		// This was too restrictive.  For example, a URL with insertion parameter was not considered valid
    		// try {
    		// 	URI uri = new URI(value);
    		// 	if (!DominoUtils.isValueEmpty(uri.getScheme())) {
    		// 		return false;
    		// 	}
    		// }
    		// catch (URISyntaxException ex) {
    		// 	//ex.printStackTrace();
    		// }
    		if (uriPattern.matcher(value).matches()) {
    			return false;
    		}
    		
    		// no problems found
		return true;
    }
    
    /**
     * Initialize insertion parameters that can be applied to the Genesis application list, including the local server name.
     */
    protected void initializeInsertionParameters() {
    		Name nameObj = null;
    		try {
    			String name = session.getServerName();
    			nameObj = session.createName(name);
    			serverAbbr = nameObj.getAbbreviated();
    			addInsertionParameter("%SERVER_ABBR%", serverAbbr);
    			serverCommon = nameObj.getCommon();
    			addInsertionParameter("%SERVER_COMMON%", serverCommon);
    		}
    		catch (NotesException ex) {
    			getLog().err("Exception in initializeInsertionParameters.  They will be skipped:  ", ex);
    			
    		}
    		finally {
    			DominoUtils.recycle(session, nameObj);
    		}
    }
    
    protected void addInsertionParameter(String param, String replacement) {
    		insertionParameters.put(param, replacement);
    }
    
    protected void processInsertionParameters(JSONObject object, String key) {
    		try {
    			String value = JSONUtils.getStringSafe(object, key);
    			if (DominoUtils.isValueEmpty(value)) {
    				return;  // nothing to do
    			}
    			
    			// do a search/replace for each insertion parameter
    			// Note that the key is treated as a regular expression
    			for (Map.Entry<String, String> entry : insertionParameters.entrySet()) {
    				value = value.replaceAll(entry.getKey(), entry.getValue());
    			}
    			object.put(key, value);
    		}
    		catch (JSONException ex) {
    			getLog().err("Failed to update key '" + key + "'");
		}
    }
}