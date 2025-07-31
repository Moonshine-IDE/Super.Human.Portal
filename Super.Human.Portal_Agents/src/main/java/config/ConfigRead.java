package config;

import java.util.Collection;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;

import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.log.DefaultLogInterface;
import com.moonshine.domino.log.LogInterface;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import genesis.LinkProcessor;
import lotus.domino.Database;
import lotus.domino.Directory;
import lotus.domino.DirectoryNavigator;
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
		JSONObject json = new JSONObject();
		String userID = getSecurity().getUserID();
		json.put("name", getAbbrNameSafe(userID));   // is the full username better?
		json.put("email", getEmailAddress());
		return json;
	}
	
	@SuppressWarnings("unchecked")
	protected String getEmailAddress() {
		final String defaultValue = ""; // leave it blank so that the user needs to fill it in in the form.
		String email = null;
		String userID = getSecurity().getUserID();
		if (DominoUtils.isValueEmpty(userID)) {
			getLog().dbg("Skipping email lookup for anonymous user.");
			return defaultValue;
		}
		
		
		// lookup with UserName object
		// This didn't work because getUserNameObject() returned the server name
		// Setting Run as Web User didn't change this behavior
		// Name userName = null;
		// try {
		// 	userName = session.getUserNameObject();
		// 	getLog().dbg("session.getUserNameObject().getCanonical():  " + session.getUserNameObject().getCanonical());
		// 	getLog().dbg("session.getUserNameObject().getAddr822Comment1():  " + session.getUserNameObject().getAddr822Comment1());
		// 	getLog().dbg("session.getUserNameObject().getAddr822Comment2():  " + session.getUserNameObject().getAddr822Comment2());
		// 	getLog().dbg("session.getUserNameObject().getAddr822Comment3():  " + session.getUserNameObject().getAddr822Comment3());
		// 	getLog().dbg("session.getUserNameObject().getAddr822LocalPart():  " + session.getUserNameObject().getAddr822LocalPart());
		// 	getLog().dbg("session.getUserNameObject().getAddr822Phrase():  " + session.getUserNameObject().getAddr822Phrase());
		// 	email = userName.getAddr821();
		// 	if (DominoUtils.isValueEmpty(email)) {
		// 		email = defaultValue;
		// 		getLog().err("No email address found in getUserNameObject.");
		// 	}
		// }
		// catch (NotesException ex) {
		// 	getLog().err("Error when reading email from getUserNameObject:  ", ex);
		// }
		// finally {
		// 	DominoUtils.recycle(session, userName);
		// }
		
		
		// // lookup with formula
		// try {
		// 	String formula = "@NameLookup([NoUpdate]; \"" + userID + "\"; \"InternetAddress\")";
		// 	Vector<?> results = session.evaluate(formula, null);
		// 	getLog().dbg("Found " + results.size() + " results for formula lookup of '" + userID + "'.");
		// 	for (Object result : results) {
		// 		getLog().dbg("Lookup result:  '" + result.toString());
		// 	}
		// 	if (results.size() <= 0) {
		// 		getLog().err("No matches found for user '" + userID + "'.");
		// 		email = defaultValue;
		// 	}
		// 	else if (results.size() > 1) {
		// 		getLog().err("Multiple email address found in directory.  Since this is unexpected behavior, no email will be returned.");
		// 		email = defaultValue;
		// 		
		// 	}
		// 	else {
		// 		// only one entry
		// 		email = results.get(0).toString();
		// 		getLog().dbg("Found exactly one email address:  '" + email + "'.");
		// 	}
		// }
		// catch (NotesException ex) {
		// 	getLog().err("Failed to lookup email address with formula:  ", ex);
		// 	email = defaultValue;
		// }
		
		// lookup with Directory
		Directory dir = null;
		DirectoryNavigator results = null;
		try {
			dir = session.getDirectory();
			dir.setSearchAllDirectories(true);
			dir.setUseContextServer(true);
			// TODO:  PartialMatches?  Supposed to default to false
			// TODO:  TrustedOnly?
			results = dir.lookupNames("($Users)", userID, "InternetAddress");
			final long max = results.getCurrentMatches();
			getLog().dbg("Found " + max + " matches for name '" + userID + "'.");
			// Vector firstResult = results.getFirstItemValue();
			// if (null == firstResult || 0 == firstResult.size()) {
			// 	getLog().dbg("No addresses found in directory");
			// 	email = defaultValue;
			// }
			// else {
			// 	email = firstResult.get(0).toString();
			// }
			
			
			
			
			Vector currentValue = null;
			Set<String> uniqueResults = new TreeSet<String>();
			
			if (max > 0) {
				try {
					currentValue = results.getFirstItemValue();
					int count = 0;
					while (null != currentValue && count < max) {
						if (currentValue.size() > 0) {
							// only use the first value
							String curEmail = currentValue.get(0).toString();
							if (DominoUtils.isValueEmpty(curEmail)) {
								getLog().dbg("Found empty value with directory lookup.");
							}
							else {
								getLog().dbg("Found an email address in the directory:  '" + curEmail + "'.");
								uniqueResults.add(curEmail.trim().toLowerCase());
							}
						}
						Vector prevValue = currentValue;
						currentValue = results.getNextItemValue();  // returns empty vector if there are no more entries
						count++;
						DominoUtils.recycle(session, prevValue);
						
					}
					getLog().dbg("Found " + count + " matches in directory (limit:  " + max + ").");
				}
				finally {
					DominoUtils.recycle(session, currentValue);
				}
			}
			// else:  no matches.  Calling getFirstItemValue throws an error in this case.
			
			if (uniqueResults.size() == 0) {
				getLog().err("No email address found in directory.");
				email = defaultValue;
			}
			else if (uniqueResults.size() > 1) {
				getLog().err("Multiple email address found in directory.  Since this is unexpected behavior, no email will be returned.");
				email = defaultValue;
				
			}
			else {
				// only one entry
				email = uniqueResults.iterator().next();
				getLog().dbg("Found exactly one email address:  '" + email + "'.");
			}
		}
		catch (Exception ex) {
			getLog().err("Error when looking up the user in the directory:  ", ex);
			email = defaultValue;
		}
		finally {
			DominoUtils.recycle(session, results);
			DominoUtils.recycle(session, dir);
		}
		
		// // lookup by userID
		// Database namesDB = null;
		// View userView = null;
		// DocumentCollection matches = null;
		// Document personDoc = null;
		// try {
		// 	namesDB = session.getDatabase("", "names.nsf");
		// 	if (!DominoUtils.isDatabaseOpen(namesDB)) {
		// 		throw new Exception("Could not open names.nsf.");
		// 	}
		// 	userView = DominoUtils.getView(namesDB, "($Users)");
		// 	matches = userView.getAllDocumentsByKey(userID, true);
		// 	if (matches.getCount() <= 0) {
		// 		// TODO:  check directory assistance as well
		// 		throw new Exception("Could not find person document for user '" + userID + "'.");
		// 	}
		// 	if (matches.getCount() > 1) {
		// 		throw new Exception("Multiple person documents for user '" + userID + "'.");
		// 	}
		// 	personDoc = matches.getFirstDocument();
		// 	email = personDoc.getItemValueString("InternetAddress"); 
		// 	if (DominoUtils.isValueEmpty("email")) {
		// 		getLog().err("No email address found in user document.");
		// 		email = defaultValue;
		// 	}
		// }
		// catch (Exception ex) {
		// 	getLog().err("Failed lookup email address:  ", ex);
		// 	email = defaultValue;
		// }
		// finally {
		// 	DominoUtils.recycle(session, personDoc);
		// 	DominoUtils.recycle(session, matches);
		// 	DominoUtils.recycle(session, userView);
		// 	DominoUtils.recycle(session, namesDB);
		// 	
		// }
		
		// normalize 
		if (DominoUtils.isValueEmpty(email)) {
			getLog().err("No email address found.");
			email = defaultValue;
		}
		return email;
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