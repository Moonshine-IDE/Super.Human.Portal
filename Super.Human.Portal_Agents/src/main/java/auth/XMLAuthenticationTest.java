package auth;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Element;

import com.moonshine.domino.crud.CRUDAgentBase;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;

import lotus.domino.*;

/**
 * Simple agent to return the authentication status.
 * Allows
 * @author JAnderson
 *
 */
public class XMLAuthenticationTest extends CRUDAgentBase {
	
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new ConfiguredAnonymousSecurity(session, getLog());
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
	}
}