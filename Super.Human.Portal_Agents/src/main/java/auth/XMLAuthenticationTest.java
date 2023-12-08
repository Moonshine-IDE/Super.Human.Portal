package auth;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Vector;

import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONArray;
import org.w3c.dom.Element;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.*;

/**
 * Simple agent to return the authentication status.
 * Allows
 * @author JAnderson
 *
 */
public class XMLAuthenticationTest extends CRUDAgentBase implements RoleRestrictedAgent {
	
	public Collection<String> getAllowedRoles() {
		return SecurityBuilder.buildList(SimpleRoleSecurity.ROLE_ALL);
	}
	
	public SecurityInterface checkSecurity() {
		return getSecurity();
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		//return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
		// need to build this manually to override allowAnonymous
		SimpleRoleSecurity instance = (SimpleRoleSecurity) SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
		// Nevermind. Changing allowAnonymous could change the roles
		// if (!instance.allowAnonymous) {
		// 	instance.setAllowAnonymous(true);
		// 	instance.initializeUserRoles(); // rerun this
		// }
		return instance;
	}

	protected void runAction() {
		// no additional logic
		
	}
	

	@Override
	protected void initializeResponse() throws ParserConfigurationException {
		super.initializeResponse();
		
		// Override the status logic.
		// This would have been fine, but there is a bug in the current logic.
		String user = getSecurity().getUserID();
		String status = "TODO";
		if (getSecurity().allowAction()) {
			// checked before anonymous to support agents that allow anonymous access
			status = "authenticated";
		}
		else if (user.equals(SecurityInterface.ANONYMOUS)) {
			status = "anonymous";
		}
		else {
			status = "authenticated-with-insufficient-access";
		}
		
		// write state
		if (useJSON()) {
			jsonRoot.put("status", status);
			// legacy name - remove once code is updated
			jsonRoot.put("state", status);
			
			
		}
		else {
			Element statusElement = xmlDoc.createElement("status");
			statusElement.appendChild(xmlDoc.createTextNode(status));
			xmlRoot.appendChild(statusElement);
			// legacy name - remove once code is updated
			Element stateElement = xmlDoc.createElement("state");
			stateElement.appendChild(xmlDoc.createTextNode(status));
			xmlRoot.appendChild(stateElement);
		}
		
		// write login URL
		String loginURL = getLoginURL();
		if (useJSON()) {
			jsonRoot.put("loginURL", loginURL);
		}
		else {
			Element statusElement = xmlDoc.createElement("loginURL");
			if (null == loginURL) {
				// normalize as ""
				statusElement.appendChild(xmlDoc.createTextNode(""));
			}
			else {
				statusElement.appendChild(xmlDoc.createTextNode(loginURL));
			}
			
			xmlRoot.appendChild(statusElement);
		}
		
		// write the security roles
		Collection<String> roles = getRoles();
		if (useJSON()) {
			JSONArray jsonRoles = new JSONArray();
			jsonRoot.put("roles", jsonRoles);
			for (String role : roles) {
				jsonRoles.put(role);
			}
		}
		else {
			Element rolesElement = xmlDoc.createElement("roles");
			for (String role : roles) {
				Element roleElement = xmlDoc.createElement("role");
				roleElement.appendChild(xmlDoc.createTextNode(role));
				rolesElement.appendChild(roleElement);
			}
			
			xmlRoot.appendChild(rolesElement);
		}
		
		
	}
	
	/**
	 * Return a URL to use for authentication instead of the Royale login form
	 */
	public String getLoginURL() {
		String loginURL = null;
		try {
			loginURL = ConfigurationUtils.getConfigAsString(agentDatabase, "login_url");		
		}
		catch (Exception ex) {
			// ignore the error - it indicates the config was not found
		}
		
		if (DominoUtils.isValueEmpty(loginURL)) {
			return null; // normalize
		}
		else {
			return loginURL;
		}
	}
	
	/**
	 * Get the security roles for the authenticated (or anonymous) user.
	 */
	public Collection<String> getRoles() {
		
		// Allow the roles to be overridden with the "test_security_roles" configuration value.
		// This should not be a security concern if the individual agent security is implemented properly.
		// TODO:  revisit this logic before the release.  Is it easy to setup role configuration for testing?
		Vector testRoles = null;
		try {
			testRoles = ConfigurationUtils.getConfigAsVector(agentDatabase, "test_security_roles");
		}
		catch (Exception ex) {
			//getLog().err("Failed to read 'test_security_roles':  ", ex);
			// Don't bother reporting this test-specific case
		}
		
		if (!isVectorEmpty(testRoles)) {
			Collection<String> roles = new ArrayList<String>();
			for (Object role : testRoles) {
				roles.add(role.toString());
			}
			return roles;
		}
		
		SimpleRoleSecurity roleManager = null;
		if (getSecurity() instanceof RoleRestrictedAgent) {
			roleManager = (SimpleRoleSecurity) getSecurity();
		} 
		else {
			// create a special instance
			roleManager = new SimpleRoleSecurity(agentDatabase, session, getLog());
		}
		return roleManager.getUserRoles();
	}
	
	public boolean isVectorEmpty(Vector vector) {
		if (null == vector || vector.isEmpty()) {
			return true;
		}
		
		// check if there is one entry, which is blank
		if (vector.size() > 2) {
			return false;  // found at least one real value
		}
		else if (DominoUtils.isValueEmpty(vector.get(0).toString())) {
			return true;
		}
		else {  // one non-empty entry
			return false;
		}
		
	}
}