package config;

import org.json.JSONObject;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

/**
 * Return the configuration options for the application
 */
public class ConfigRead extends CRUDAgentBase 
{
	protected JSONObject configJSON = null;
	
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
		
		// define a config property
		configJSON = new JSONObject();
		jsonRoot.put("config", configJSON);
		
		// rather than return documents, return configuration values as properties
		addConfigPropertyBoolean("ui_documentation_editable", false); // `true` if the Getting Started UI should be editable, `false` otherwise
		addConfigPropertyBoolean("ui_documentation_show_unid", false); // `true` if the DocumentationUNID column should be displayed, false otherwise.
		addConfigPropertyString("ui_title", "Super.Human.Portal"); // The title for the application.  This may be customized with the server name or the organizational certifier.

		
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
}