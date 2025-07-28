package config;

import java.util.Collection;

import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import genesis.LinkProcessor;
import lotus.domino.Database;
import lotus.domino.DocumentCollection;
import lotus.domino.Name;
import lotus.domino.NotesException;
import lotus.domino.View;
import lotus.domino.ViewEntryCollection;
import lotus.domino.Document;

/**
 * Return the configuration options for the application
 */
public class ConfigRead extends CRUDAgentBase implements RoleRestrictedAgent
{
	protected JSONObject configJSON = null;
	
	public String getRoleRestrictionID() {
		return null;  // allow all
	}
	
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
		
		// define a config property
		configJSON = new JSONObject();
		jsonRoot.put("config", configJSON);
		
		// rather than return documents, return configuration values as properties
		// addConfigPropertyBoolean("ui_documentation_editable", false); // `true` if the Getting Started UI should be editable, `false` otherwise
		// switch to new role-based permissions
		configJSON.put("ui_documentation_editable", shouldDisplay(agentDatabase, SecurityBuilder.RESTRICT_DOCUMENTATION_MANAGE));
		addConfigPropertyBoolean("ui_documentation_show_unid", false); // `true` if the DocumentationUNID column should be displayed, false otherwise.
		
		addConfigPropertyString("ui_title", "Super.Human.Portal"); // The title for the application.  This may be customized with the server name or the organizational certifier.
		addConfigPropertyString("nomad_helper_url", ""); // A URL for nomadhelper.html if this has been configured. If it is blank, open the Nomad URLs directly.
		
		// For nomadhelper.html instructions:  https://github.com/Moonshine-IDE/Super.Human.Portal/issues/54#issuecomment-2110781462
		addConfigPropertyString("nomad_base_url", ""); // A URL for the corresponding Nomad server - empty if no Nomad server is defined
		// data directory
		// TODO:  find a dynamic way to determine this
		// TODO:  read from notes.ini?
		String dataDirectory = "/local/notesdata";  
		configJSON.put("domino_data_directory", dataDirectory);
		// server name
		String serverName = "UNKNOWN";
		try {
			serverName = agentDatabase.getServer();
			if (null == serverName) {
				serverName = "";
			}
			else {
				serverName = getAbbrNameSafe(serverName);
			}
		}
		catch (NotesException ex) {
			getLog().err("Failed to read server name.", ex);
		}
		configJSON.put("domino_server_name", serverName);
		
		//  links to SuperHumanPortal database
		JSONObject configLink = new JSONObject();
		configLink.put("name", "SuperHumanPortal Configuration");
		configLink.put("type", "database");
		configLink.put("server", serverName);
		configLink.put("database", "SuperHumanPortal.nsf");
		configLink.put("view", "Configuration");
		configLink.put("defaultAction", "nomad");
		LinkProcessor processor = new LinkProcessor(session, getLog(), agentDatabase);
		processor.cleanupLink(configLink);
		configJSON.put("configuration_link", configLink);
		

		// additional user info for improvement requests
		addConfigPropertyString("customer_id", "UNKNOWN"); // Prominic customer ID populated by customer.
		jsonRoot.put("userInfo", getUserInfo());
		
	}
	
	protected JSONObject getUserInfo() {
		final String defaultValue = "UNKNOWN";
		JSONObject json = new JSONObject();
		String userID = getSecurity().getUserID();
		json.put("name", getAbbrNameSafe(userID));   // is the full username better?
		Database namesDB = null;
		View userView = null;
		DocumentCollection matches = null;
		Document personDoc = null;
		String email = null;
		try {
			namesDB = session.getDatabase("", "names.nsf");
			if (!DominoUtils.isDatabaseOpen(namesDB)) {
				throw new Exception("Could not open names.nsf.");
			}
			userView = DominoUtils.getView(namesDB, "($Users)");
			matches = userView.getAllDocumentsByKey(userID, true);
			if (matches.getCount() <= 0) {
				throw new Exception("Could not find person document for user '" + userID + "'.");
			}
			if (matches.getCount() > 1) {
				throw new Exception("Multiple person documents for user '" + userID + "'.");
			}
			personDoc = matches.getFirstDocument();
			email = personDoc.getItemValueString("InternetAddress"); 
			if (DominoUtils.isValueEmpty("email")) {
				getLog().err("No email address found in user document.");
				email = defaultValue;
			}
		}
		catch (Exception ex) {
			getLog().err("Failed to generate user JSON:  ", ex);
			email = defaultValue;
		}
		json.put("email", email);
		return json;
	}
	
	protected void addConfigPropertyString(String key, String defaultValue) {
		String value = null;
		try {
			value = ConfigurationUtils.getConfigAsString(agentDatabase, key);
			if (DominoUtils.isValueEmpty(value)) {
				value = defaultValue;
			}
		}
		catch (Exception ex) {
			getLog().err("Failed to read configuration value '" + key + "'.", ex);
			value = defaultValue;
		}
		
		configJSON.put(key, value);
	}
	
	protected void addConfigPropertyBoolean(String key, boolean defaultValue) {
		boolean value = defaultValue;
		try {
			String valueStr = ConfigurationUtils.getConfigAsString(agentDatabase, key);
			if (DominoUtils.isValueEmpty(valueStr)) {
				value = defaultValue;
			}
			else {
				value = Boolean.parseBoolean(valueStr);
			}
			
		}
		catch (Exception ex) {
			getLog().err("Failed to read configuration value '" + key + "'.  Using default.", ex);
			value = defaultValue;
		}
		
		configJSON.put(key, value);
	}
    
    protected String getAbbrNameSafe(String name) {
    		Name nameObj = null;
    		try {
    			nameObj = session.createName(name);
    			return nameObj.getAbbreviated();
    		}
    		catch (NotesException ex) {
    			getLog().err("Failed to generate abbreviated name for '" + name + "'.  Returning default value:  ", ex);
    			return "UNKNOWN";
    		}
    }
    
    protected String getCommonNameSafe(String name) {
    		Name nameObj = null;
    		try {
    			nameObj = session.createName(name);
    			return nameObj.getCommon();
    		}
    		catch (NotesException ex) {
    			getLog().err("Failed to generate commmon name for '" + name + "'.  Returning default value:  ", ex);
    			return "UNKNOWN";
    		}
    }
	
	/**
	 * Determine whether the interface indicated by the given ID should be displayed, based on the user roles and configuration values.
	 * The configuration document for a given sectionID is "allow_sectionID".
	 * @param  configDatabase - the database instance for configuration
	 * @param sectionID  the ID of the section to check
	 * 
	 */
	public boolean shouldDisplay(Database configDatabase, String sectionID) {
		try {
			// // UI Testing
			// String value = ConfigurationUtils.getConfigAsString(configDatabase, "allow_" + sectionID);
			// return "true".equalsIgnoreCase(value);
			// // treat any other value as false
			return ((SimpleRoleSecurity)getSecurity()).isAuthorizedForRoles(sectionID);
		}
		catch (Exception ex) {
			getLog().err("Exception when checking display rights for '" + sectionID + "'.   Default to hidden");
			return false;
		}
	}
}