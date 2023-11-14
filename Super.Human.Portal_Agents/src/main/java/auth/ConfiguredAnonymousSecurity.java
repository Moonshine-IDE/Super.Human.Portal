package auth;

import com.moonshine.domino.log.LogInterface;
import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.Document;
import lotus.domino.Session;

/**
 * This works the same as AllowAllSecurity, except that Anonymous access 
 * can be configured with the {@value #ALLOW_ANONYMOUS_KEY} config document.
 * Anonymous access will be allowed only if the config value is <code>true</code>.
 * Authenticated users will always be allowed
 * 
 * @author JAnderson
 *
 */
public class ConfiguredAnonymousSecurity extends AllowAllSecurity {
	
	public static final boolean DEFAULT_ALLOW_ANONYMOUS = false;
	public static final String ALLOW_ANONYMOUS_KEY = "allow_anonymous";
	protected boolean allowAnonymous = DEFAULT_ALLOW_ANONYMOUS;
	protected LogInterface log = null;

	public ConfiguredAnonymousSecurity(Session session, LogInterface log) {
		super(session);
		this.log = log;
		
		// check the configuration
		try {
			String allowAnonymousStr = ConfigurationUtils.getConfigAsString(session.getCurrentDatabase(), ALLOW_ANONYMOUS_KEY);
//			log.dbg(ALLOW_ANONYMOUS_KEY + "='" + allowAnonymousStr + "'.");
			if (DominoUtils.isValueEmpty(allowAnonymousStr)) {
				allowAnonymous = DEFAULT_ALLOW_ANONYMOUS;  // default to false
			}
			else {
				allowAnonymous = null != allowAnonymousStr && allowAnonymousStr.equals("true");
			}
			
		}
		catch (Exception ex) {
			log.err("Could not read configuration value '" + ALLOW_ANONYMOUS_KEY + "'", ex);
			allowAnonymous = DEFAULT_ALLOW_ANONYMOUS;
		}
	}
	
	public boolean allowAction() {
		if (isAnonymous()) {
			return allowAnonymous;
		}
		return true;
	}

	public boolean allowAccess(Document document) {
		return allowAction();
	}
	

	public boolean isAnonymous() {
		String userID = getUserID();
//		log.dbg("Authenticated User:  '" + userID + "'");
//		log.dbg("allowAnonymous:  " + allowAnonymous + "");
		return null == userID || userID.equals(SecurityInterface.ANONYMOUS);
	}

}
