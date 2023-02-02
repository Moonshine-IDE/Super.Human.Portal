package genesis;

import java.io.IOException;


import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.NotesException;
import util.SimpleHTTPClient;
import util.ValidationException;

/**
 * Return a list of available Genesis applications
 */
public class GenesisRead extends CRUDAgentBase 
{
	protected static final String DEFAULT_GENESIS_REST_API = "http://appstore.dominogenesis.com/rest/v1/apps";
	
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
                    
                    entries.put(newNode);
                }
                catch (JSONException ex) {
                    getLog().err("Exception while processing application:  '" + entry.toString() + "':  ", ex);
                    // continue with other entries
                }
            }
            
     
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
        SimpleHTTPClient http = new SimpleHTTPClient(2000, 2000, 0);
        String data = http.getPage(url);
        JSONObject original = new JSONObject(data);
        JSONArray list = (JSONArray)original.get("list");
        return list;
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
    		node.put("Installed", false);
    		
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

}