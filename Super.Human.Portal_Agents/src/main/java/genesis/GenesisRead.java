package genesis;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.Map;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.net.URI;
import java.net.URISyntaxException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.Name;
import lotus.domino.NotesException;
import util.SimpleHTTPClient;
import util.ValidationException;

/**
 * Return a list of available Genesis applications
 */
public class GenesisRead extends CRUDAgentBase 
{
	protected static final String DEFAULT_GENESIS_REST_API = "http://appstore.dominogenesis.com/rest/v1/apps";
	protected static final int API_TIMEOUT_MS = 5000;
	protected Collection<String> installedApps = new TreeSet<String>();
	protected Map<String, String> insertionParameters = new TreeMap<String, String>();
	
	protected String serverAbbr = null;
	protected String serverCommon = null;
	
	protected static final Pattern notesURLPattern = Pattern.compile("notes://([^/]+)/([^?]+.nsf)(?:/[^/?])?(?:.*)?$", Pattern.CASE_INSENSITIVE);
	/** Detect a URI based on the protocol only.  The rest of the URL does not have to be valid */
	protected static final Pattern uriPattern = Pattern.compile("^\\w+://.*$", Pattern.CASE_INSENSITIVE);
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new AllowAllSecurity(session);
	}
	
	@Override
	protected void runAction() {
		// only allow JSON
		if (!useJSON()) {
			reportError("XML not supported.");
			return;
		}
		
		
        JSONArray entries = new JSONArray();
        
        try {
        		loadInstalledApps();
        		initializeInsertionParameters();
            JSONArray list = getGenesisAppList();
            
            for (Object entry : list) {
                try {
                    JSONObject node = (JSONObject) entry;
                    JSONObject newNode = new JSONObject();
                    newNode.put("AppID", node.get("id"));
                    newNode.put("Label", node.get("title"));
                    newNode.put("DetailsURL", node.get("url"));
                    newNode.put("InstallCommand", node.get("install"));
                    
                    // add info installation info
                    addInstallationInfo(newNode, node.get("id").toString());
                    copyAccessInfo(newNode, node);
                    
                    entries.put(newNode);
                }
                catch (JSONException ex) {
                    getLog().err("Exception while processing application:  '" + entry.toString() + "':  ", ex);
                    // continue with other entries
                }
            }
            
            // // add an example application
			// JSONObject newNode = new JSONObject();
			// newNode.put("AppID", "xampleaddin");
			// newNode.put("Label", "Xample Addin");
			// newNode.put("DetailsURL", "https://genesis.directory/apps/superhumanportal");
			// newNode.put("InstallCommand", "install superhumanportal");
    		// 	newNode.put("Installed", true);
			// JSONObject accessNode = new JSONObject();
			// newNode.put("access", accessNode);
			// accessNode.put("description", "This is not a real application.  It is being used for testing only, and will be removed at a later time.");
			// 
			// JSONArray links = new JSONArray();
			// accessNode.put("links", links);
			// JSONObject exampleLink = new JSONObject();
			// links.put(exampleLink);
			// exampleLink.put("type", "browser");
			// exampleLink.put("name", "Example Link");
			// exampleLink.put("url", "/SuperHumanPortal.nsf/XMLAuthenticationTest?OpenAgent");	
			// exampleLink = new JSONObject();
			// links.put(exampleLink);
			// exampleLink.put("type", "database");
			// exampleLink.put("name", "Example Database");
			// exampleLink.put("url", "notes://demo.startcloud.com/SuperHumanPortal.nsf");  // NOTE:  this will fail for most users
			// 
			// entries.put(newNode);		
     
            jsonRoot.put("apps", entries);
        }
        catch (Throwable ex) {
            reportError("Error while generating application list.");
            getLog().err("Exception:  ", ex);
        }
    }

    protected JSONArray getGenesisAppList()
            throws NotesException, Exception, ValidationException, IOException {
        String url = getDataURL();
        SimpleHTTPClient http = new SimpleHTTPClient(API_TIMEOUT_MS, API_TIMEOUT_MS, 0);
        String data = http.getPage(url);
        JSONObject original = new JSONObject(data);
        JSONArray list = (JSONArray)original.get("list");
        return list;
    }
    
    protected void loadInstalledApps() {
    		File addinDir = new File("JavaAddin/");  // in the Data directory
    		String[] addins = addinDir.list();
    		for (String addin : addins) { 
    			if (isAddin(addin)) {
    				installedApps.add(cleanAddinName(addin));
    			}
    		}
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
    
    /**
     * Check if the given filename should be treated as an addin.
     */
    protected boolean isAddin(String name) {
    		return true;  // no checks for now
    }
    
    protected String cleanAddinName(String raw) {
    		if (null == raw) {
    			return "null";
    		}
    		String cleaned = raw.toLowerCase();
    		// TODO:  more checks;
    		return cleaned;
    }
    
    /**
     * Determine if the addin is installed
     */
    protected boolean isInstalled(String addinName) {
    		return installedApps.contains(cleanAddinName(addinName));
    }
	
	/**
     * Get the API URL from the configuration.
     * @return
     * @throws NotesException
     * @throws Exception
     */
    protected String getDataURL() throws NotesException, Exception {
        // Original:  https://api.genesis.directory/v1/apps
        String url = null;
        try {
        		url = ConfigurationUtils.getConfigAsString(agentDatabase, "genesis_api_applist");
        		if (DominoUtils.isValueEmpty(url)) {
    				url = DEFAULT_GENESIS_REST_API;
        		}
    		}
    		catch (Exception ex) {
    			getLog().err("Could not read configured Genesis URL.");
    			url = DEFAULT_GENESIS_REST_API;
    		}
    		
    		return url;
    }
    
    protected void addInstallationInfo(JSONObject node, String appID) {
    		// TODO:  lookup the installation status from the database
    		
    		// default to no configuration
    		node.put("Installed", isInstalled(appID));
    		
    		
    		// TODO:  save the access node for the agent listing installed applications
    		// JSONObject accessNode = new JSONObject();
    		// node.put("access", accessNode);
    		// accessNode.put("description", "Placeholder description.");
    		// 
    		// JSONArray links = new JSONArray();
    		// accessNode.put("links", links);
    		// 
    		// // TODO: remove this fake link
    		// JSONObject exampleLink = new JSONObject();
    		// links.put(exampleLink);
    		// exampleLink.put("type", "browser");
    		// exampleLink.put("name", "Example Link");
    		// exampleLink.put("url", "/auth.nsf/XMLAuthenticationTest?OpenAgent");
    		
    }
    
    protected void copyAccessInfo(JSONObject updateMe, JSONObject original) {
    		try {
    			Object accessInfoObj = original.get("access");
    			if (null != accessInfoObj && (accessInfoObj instanceof JSONObject)) {
    				JSONObject accessInfo = (JSONObject) accessInfoObj;
    				updateMe.put("access", accessInfo);
    				
    				Object linksObj = accessInfo.get("links");
    				if (null != linksObj && linksObj instanceof JSONArray) {
    					JSONArray links = (JSONArray) linksObj;
    					for (Object linkObj : links) {
    						if (linkObj instanceof JSONObject) {
    							cleanupLink((JSONObject) linkObj);
    						}
    						else {
    							getLog().err("Skipping invalid link:  not a JSON object.");
    						}
    					}
    				}
    				
    				processInsertionParameters(accessInfo, "description");
    			}
		}
		catch (JSONException ex) {
			// ignore
		}
    }
    
    protected void cleanupLink(JSONObject link) {
    		String identifier = "UNKNOWN";
    		try {
    			identifier = getStringSafe(link, "name");
    			String type = getStringSafe(link, "type");
    			if (null != type && type.equalsIgnoreCase("database")) {
    				// Update database links so that they can work in Super.Human.Portal
    				String database = getStringSafe(link, "database");
    				if (DominoUtils.isValueEmpty(database)) {
    					//  TODO:  remove this early workaround - we had not decided on the format yet.
    					database = getStringSafe(link, "url");
    					
    					// TODO: cleanup the URL format before setting database
    					link.put("database", database);
    				}
    				
				if (isDatabaseName(database)) {
					String origURL = getStringSafe(link, "url");
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
						// TODO:  support "view" parameter
						link.put("url", url);
					}
					// else: url was already set "properly", so keep the original value
					
				}
				// else:  not a database.  No way to populate the url anyway
				
				String nomadURL = getStringSafe(link, "nomadURL");
				if (DominoUtils.isValueEmpty(nomadURL)) {
					// Compute the Nomad URL
					// https://nomadweb.%SERVER_COMMON%/nomad/#/%NOTES_URL%
					String url = getStringSafe(link, "url");
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
				
				// replace insertion parameters
				// ignore type
				// name, server, and database are overkill, but I include this for future changes.
				processInsertionParameters(link, "name");
				processInsertionParameters(link, "server");
				processInsertionParameters(link, "database");
				processInsertionParameters(link, "view");
				processInsertionParameters(link, "url");
				processInsertionParameters(link, "nomadURL");
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
    
    protected String getStringSafe(JSONObject object, String key) {
    		try {
    			return object.getString(key);
    		}
    		catch (JSONException ex) {
    			// this fails if the key was not found.  Return null instead.
    			return null;
		}
    }
    
    protected void addInsertionParameter(String param, String replacement) {
    		insertionParameters.put(param, replacement);
    }
    
    protected void processInsertionParameters(JSONObject object, String key) {
    		try {
    			String value = getStringSafe(object, key);
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