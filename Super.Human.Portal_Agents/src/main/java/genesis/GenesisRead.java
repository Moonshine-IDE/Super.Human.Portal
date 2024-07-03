package genesis;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.TreeSet;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import lotus.domino.Document;
import lotus.domino.NotesException;
import lotus.domino.View;
import lotus.domino.ViewEntry;
import lotus.domino.ViewEntryCollection;
import util.JSONUtils;
import util.SimpleHTTPClient;
import util.ValidationException;

/**
 * Return a list of available Genesis applications
 */
public class GenesisRead extends CRUDAgentBase implements RoleRestrictedAgent
{
	protected static final String DEFAULT_GENESIS_REST_API = "http://appstore.dominogenesis.com/rest/v1/apps";
	protected static final int API_TIMEOUT_MS = 5000;
	protected Collection<String> installedApps = new TreeSet<String>();
	
	protected static final int DEFAULT_INSTALL_TIME_S = 15;
	protected int configInstallTimeS = -1;
	
	/** The label to use for the default, public Genesis directory */
	protected static final String DEFAULT_DIRECTORY_LABEL = "Default";  
	
	protected LinkProcessor linkProcessor = null;
	
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
		// only allow JSON
		if (!useJSON()) {
			reportError("XML not supported.");
			return;
		}
		
		
        JSONArray entries = new JSONArray();
        
        View additionalDirectoryView = null;
        ViewEntryCollection additionalDirectories = null;
        try {
        		loadInstalledApps();
        		linkProcessor = new LinkProcessor(session, getLog(), agentDatabase);
        		
        		// The central directory.  Use "" for the label for now.
        		addApplicationsFromDirectory(getDataURL(), DEFAULT_DIRECTORY_LABEL, entries, linkProcessor);
        		
        		// process the additional directories, if any
        		additionalDirectoryView = DominoUtils.getView(agentDatabase, "All By UNID/CRUD/GenesisDirectory");
        		additionalDirectories = additionalDirectoryView.getAllEntries();
        		ViewEntry curEntry = additionalDirectories.getFirstEntry();
        		while (null != curEntry) {
        			Document additionalDirectoryDoc = null;
        			try {
        				additionalDirectoryDoc = curEntry.getDocument();
        				
        				String label = additionalDirectoryDoc.getItemValueString("label");
        				String url = getBaseAPI(additionalDirectoryDoc);
        				addApplicationsFromDirectory(url, label, entries, linkProcessor);
        			}
        			finally {
        				ViewEntry prevEntry = curEntry;
        				curEntry = additionalDirectories.getNextEntry();
        				
        				DominoUtils.recycle(session, additionalDirectoryDoc);
        				DominoUtils.recycle(session, prevEntry);
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
        finally {
        		DominoUtils.recycle(session, additionalDirectories);
        		DominoUtils.recycle(session, additionalDirectoryView);
        }
    }
    
    protected void addApplicationsFromDirectory(String directoryURL, String directoryLabel, JSONArray applicationList, LinkProcessor linkProcessor) {
    		try {
			JSONArray list = getGenesisAppList(directoryURL);
			
			for (Object entry : list) {
				try {
					JSONObject node = (JSONObject) entry;
					JSONObject newNode = new JSONObject();
					JSONUtils.copyPropertySafe(node, "id", newNode, "AppID", null, getLog());
					JSONUtils.copyPropertySafe(node, "title", newNode, "Label", null, getLog());
					JSONUtils.copyPropertySafe(node, "url", newNode, "DetailsURL", null, getLog());
					JSONUtils.copyPropertySafe(node, "install", newNode, "InstallCommand", null, getLog());
					JSONUtils.copyPropertySafe(node, "installTime", newNode, "InstallTimeS", getDefaultInstallTimeS(), getLog());
					
					// set the directory
					newNode.put("directory", directoryLabel);
					
					// add info installation info
					addInstallationInfo(newNode, node.get("id").toString());
					copyAccessInfo(newNode, node);
					
					applicationList.put(newNode);
				}
				catch (JSONException ex) {
					getLog().err("Exception while processing application:  '" + entry.toString() + "':  ", ex);
					// continue with other entries
				}
			}
		}
		catch (Exception ex) {
			getLog().err("Failed to read the '" + directoryLabel + "' (" + directoryURL + ") directory.  Skipping:  ", ex);
		}
    	
    }

    protected JSONArray getGenesisAppList(String url)
            throws NotesException, Exception, ValidationException, IOException {
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
    
    /**
     * Get the base URL for GenesisDirectory document.  This URL will end with the database, so the API options will need to be added.
     * @param directoryDoc  The GenesisDirectory document. Expected to be non-null
     * @return  the base URL
     * @throws NotesException  if an error occurs in the Domino API
     * @throws ValidationException  if the URL was not configured properly
     */
    protected String getBaseURL(Document directoryDoc)  throws NotesException, ValidationException {
    		String url = directoryDoc.getItemValueString("url"); // + "/rest?openagent&req=v1/apps";
    		if (DominoUtils.isValueEmpty(url)) {
			throw new ValidationException("Invalid Genesis Directory configuration - missing URL:  '" + getDirectoryLabel(directoryDoc) + "'.");
    		}
    		
    		// normalize
    		// Expected example:  http://demo.startcloud.com:82/gdp1.nsf
    		// Including API:  http://demo.startcloud.com:82/gdp1.nsf/rest?openagent&req=v1/apps
    		// detect base URL ending in a database
    		Pattern urlPattern = Pattern.compile("^(https?://.*/[^/]*\\.nsf).*$", Pattern.CASE_INSENSITIVE);
    		Matcher matcher = urlPattern.matcher(url);
    		if (!matcher.matches()) {
			throw new ValidationException("Invalid Genesis Directory configuration - invalid URL:  '" + getDirectoryLabel(directoryDoc) + "'.");
    		}
    		else {
    			url = matcher.replaceAll("$1");
    		}
    		
    		return url;
    }
    
    /**
     * Get the base API URL for GenesisDirectory document.  This will be the complete URL needed to get the application list.
     * @param directoryDoc  The GenesisDirectory document. Expected to be non-null
     * @return  the base URL
     * @throws NotesException  if an error occurs in the Domino API
     * @throws ValidationException  if the URL was not configured properly
     */
    protected String getBaseAPI(Document directoryDoc) throws NotesException, ValidationException {
    		String url = getBaseURL(directoryDoc);
    		url += "/rest?openagent&req=v1/apps";
    		return url;
	}
    
    protected String getDirectoryLabel(Document directoryDoc) {
    		String label = null;
    		try {
    			label = directoryDoc.getItemValueString("label");
		}
		catch (NotesException ex) {
			getLog().err("Could not read label from directory:  ", ex);
			// continue and use default value
			label = null;
		}
		
    		if (DominoUtils.isValueEmpty(label)) {
    			label = "DEFAULT";
		}
		
		return label;
    	
    }
    
    protected int getDefaultInstallTimeS() {
    		if (configInstallTimeS >= 0) {
    			return configInstallTimeS;
    		} 
    		
    		// attempt to read the configuration
    		try {
    			configInstallTimeS = ConfigurationUtils.getConfigAsInt(agentDatabase, "default_install_time_s");
    			if (configInstallTimeS < 0) {
    				configInstallTimeS = DEFAULT_INSTALL_TIME_S;
    			}
		}
		catch (Exception ex) {
			// no configured value - use default
			configInstallTimeS = DEFAULT_INSTALL_TIME_S;
		}
    		
		return configInstallTimeS;
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
    							linkProcessor.cleanupLink((JSONObject) linkObj);
    						}
    						else {
    							getLog().err("Skipping invalid link:  not a JSON object.");
    						}
    					}
    				}
    				
    				linkProcessor.processInsertionParameters(accessInfo, "description");
    			}
		}
		catch (JSONException ex) {
			// ignore
		}
    }

}