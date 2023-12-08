package auth;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.TreeSet;
import java.util.Vector;

import com.moonshine.domino.log.LogInterface;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.ConfigurationUtils;
import com.moonshine.domino.util.DominoUtils;

import lotus.domino.Database;
import lotus.domino.Document;
import lotus.domino.Name;
import lotus.domino.NotesException;
import lotus.domino.Session;

/**
 * A security implementation based on allowed roles.  Access will be allowed if <b>at least one</b> allowed role is configured for the authenticated user. 
 * TODO:  Add option to require all roles
 * 
 * <p>Roles are case-sensitive.  TODO: add an option for case insensitive.</p>
 * 
 * <p>Only "authenticated" users are allowed to have roles.  Anonymous users will not be allowed unless you set {@link #setAllowAnonymous(boolean)} to <code>true</code>.</p>
 * 
 * Some roles are provided by default:<ul>
 *   <li>{@link #ROLE_ALL} ({@value #ROLE_ALL}) - Use this to allow any authenticated user.</li>
 *   <li>{@link #ROLE_ANONYMOUS} ({@value #ROLE_ANONYMOUS}) - Use this to only allow anonymous users.</li>
 *   <li>{@link #ROLE_NOT_ANONYMOUS} ({@value #ROLE_NOT_ANONYMOUS}) - Use this to allow any non-anonymous user.  Note that this distinct from the "authenticated" logic described above.</li>
 * </ul>
 * 
 * To configure additional roles:<ol>
 *   <li>Define a list of roles in a {@value #DEFAULT_ROLE_LIST_KEY} config document.</li>
 *   <li>For each role, define a config document named "role_%ROLE%_users" and populate it with user entries.</li>
 * </ol>
 * 
 * The user entries are case-insensitive (TODO:  make this an option).  The allowed user entries values are:<ul>
 *   <li> {@value #WILDCARD_ALL} - Allow all "authenticated" users.<li>
 *   <li> {@value #WILDCARD_ANONYMOUS} - Allow anonymous users.  This will only work if {@link #getAllowAnonymous() is <code>true</code>.<li>
 *   <li> {@value #WILDCARD_NON_ANONYMOUS} - Allow any "authenticated" user that is not anonymous.<li>
 *   <li> User names - In decreasing order of security strength, these can be canonical, abbreviated, or common name only.
 *   <li> Organization/domain wildcards in the format "*&#47;ORG" - allow any users in this organization
 *   <li> TODO: Groups are not yet supported
 * </ul>
 * 
 */
public class SimpleRoleSecurity  extends SecurityInterface
{
	protected LogInterface log = null;
	protected Set<String> allowedRoles = new TreeSet<String>();
	protected Set<String> userRoles = new TreeSet<String>();
	protected Database roleDatabase = null;
	
	protected Collection<String> userLookupKeys = new ArrayList<String>();
	
	/** Role list config key */
	protected static final String DEFAULT_ROLE_LIST_KEY = "role_list";
	protected String roleListKey = DEFAULT_ROLE_LIST_KEY;
	
	/** Universal role added for all users */
	public static final String ROLE_ALL = "All";
	/** Universal role for anonymous users only */
	public static final String ROLE_ANONYMOUS = "Anonymous";
	// I removed "Authenticated" because it is the same as "All" with the rules defined in isAuthenticated
	// /** Universal role for authenticated users only.  This uses the allow_anonymous logic from {@link ConfiguredAnonymousSecurity}. */
	// public static final String ROLE_AUTHENTICATED = "Authenticated";
	/** Universal role for non-anonymous users.  This ignores the allow_anonymous logic */
	public static final String ROLE_NOT_ANONYMOUS = "NotAnonymous";
	
	/** Role entry that matches all authenticated users.  See {@link #isAuthenticated()} and {@link #setAllowAnonymous(boolean)}. */
	public static final String WILDCARD_ALL = "*";
	/** Role entry that matches all non-anonymous users */
	public static final String WILDCARD_NOT_ANONYMOUS = "*/*";
	/** Role entry that allows anonymous users.  Requires that {@link #getAllowAnonymous() is <code>true</code>. */
	public static final String WILDCARD_ANONYMOUS = "anonymous";
	
	public static final boolean DEFAULT_ALLOW_ANONYMOUS = false;
	public static final String ALLOW_ANONYMOUS_KEY = "allow_anonymous";
	protected boolean allowAnonymous = DEFAULT_ALLOW_ANONYMOUS;
	
	/**
	 * Initialize the security with no allowed roles.
	 * Add roles with {@link #addAllowedRole(String)}.
	 * @param roleDatabase  the role configuration database
	 * @param session  the session
	 * @param log  the log
	 */
	public SimpleRoleSecurity(Database roleDatabase, Session session, LogInterface log) {
		
		super(session);
		this.log = log;
		this.roleDatabase = roleDatabase;
		initializeAllowAnonymous();
		initializeUserRoles();
	}
	
	/**
	 * Initialize the security with a single specified role.
	 * Add additional roles with {@link #addAllowedRole(String)}.
	 * @param roleDatabase  the role configuration database
	 * @param session  the session
	 * @param log  the log
	 */
	public SimpleRoleSecurity(Database roleDatabase, String role, Session session, LogInterface log)
	{
		this(roleDatabase, session, log);
		addAllowedRole(role);
	}
	
	/**
	 * Initialize the security with a list of roles.
	 * Add additional roles with {@link #addAllowedRole(String)}.
	 * @param roleDatabase  the role configuration database
	 * @param session  the session
	 * @param log  the log
	 */
	public SimpleRoleSecurity(Database roleDatabase, Collection<String> roles, Session session, LogInterface log)
	{
		this(roleDatabase, session, log);
		for (String role : roles) {
			addAllowedRole(role);
		}
	}
	

	/**
	 * See {@link #isAuthorizedForRoles()}.
	 */
	public boolean allowAction() {
		return isAuthenticated() && isAuthorizedForRoles();
	}
	
	/**
	 * See {@link #isAuthorizedForRoles()}.
	 */
	public boolean allowAccess(Document document) {
		return isAuthenticated() && isAuthorizedForRoles();
	}
	
	
	
	
	
	
	protected void initializeAllowAnonymous() {
		// check the configuration
		try {
			String allowAnonymousStr = ConfigurationUtils.getConfigAsString(session.getCurrentDatabase(), ALLOW_ANONYMOUS_KEY);
//			log.dbg(ALLOW_ANONYMOUS_KEY + "='" + allowAnonymousStr + "'.");
			if (DominoUtils.isValueEmpty(allowAnonymousStr)) {
				setAllowAnonymous(DEFAULT_ALLOW_ANONYMOUS);  // default to false
			}
			else {
				setAllowAnonymous(allowAnonymousStr.equals("true"));
			}
			
		}
		catch (Exception ex) {
			log.err("Could not read configuration value '" + ALLOW_ANONYMOUS_KEY + "'", ex);
			setAllowAnonymous(DEFAULT_ALLOW_ANONYMOUS);
		}
		//log.dbg("allowAnonymous=" + this.allowAnonymous);
	}
	
	/**
	 * @return  <code>true</code> if anonymous users are allowed to have roles.
	 *          <code>false</code> if anonymous users will be rejected automatically.
	 */
	public boolean getAllowAnonymous() {
		return allowAnonymous;
	}
	
	/**
	 * Override the allow anonymous logic
	 * @param value  <code>true</code> to allow anonymous users to have roles.
	 *               <code>false</code> to reject anonymous users.
	 */
	public void setAllowAnonymous(boolean value) {
		this.allowAnonymous = value;
	}
	
	/**
	 * Initialize the roles for the user based on the configuration in the role database
	 */
	protected void initializeUserRoles() {
		userRoles.clear();  // start fresh
		
		// in order to have any roles, the user must be authenticated
		if (!isAuthenticated()) {
			log.err("Rejecting all roles for non-authenticated user '" + getUserID() + "'.");
			return;
		}
		
		initializeUserLookupKeys();
		
		// TODO:  Note that I could improve the performance for the role lookups by only checking the allowedRoles.  However:
		// - This would require an update to userRoles if addAllowedRoles is called
		// - The full user role list is needed for agents like XMLAuthenticationTest.  This implementation could be moved to getUserRoles to be loaded on requirement
		try {
			// Universal roles
			userRoles.add(ROLE_ALL);
			if (isAnonymous()) {
				userRoles.add(ROLE_ANONYMOUS);
			}
			else {
				userRoles.add(ROLE_NOT_ANONYMOUS);
			}
			
			// Custom roles
			Collection<String> fullRoleList = getFullRoleList();
			for (Object roleObj : fullRoleList) {
				String role = roleObj.toString();
				if (hasUserRole(role)) {
					userRoles.add(role);
				}
			}
			
		}
		catch (Exception ex) {
			log.err("Exception in initializeUserRoles: ", ex);
		}
	}
	
	protected void initializeUserLookupKeys() {
		// reset
		userLookupKeys.clear();
		
		// initialize allowed keys for the user
		if (isAnonymous()) {
			userLookupKeys.add(normalizeName("anonymous"));
			// universal wildcard
			userLookupKeys.add(WILDCARD_ALL);
		}
		else {
			Name name = null;
			try {
				name = createName(getUserID());
				// common variations on name
				userLookupKeys.add(normalizeName(name.getAbbreviated()));
				userLookupKeys.add(normalizeName(name.getCommon()));
				userLookupKeys.add(normalizeName(name.getCanonical()));
				
				// Organization wildcard
				String org = normalizeName(name.getOrganization());
				userLookupKeys.add(normalizeName("*/" + org));  //normalize name is overkill for now, but I did this to future-proof the code
				
				// universal wildcard
				userLookupKeys.add(WILDCARD_ALL);
				// universal user (not anonymous)
				userLookupKeys.add(WILDCARD_NOT_ANONYMOUS);
			}
			catch (NotesException ex) {
				log.err("Error processing user name:  ", ex);
			}
			finally {
				DominoUtils.recycle(session, name);
			}
		}
	}
	
	/**
	 * Wrapper for session.createName.  Will be overwritten in unit tests
	 */
	protected Name createName(String rawName) throws NotesException {
		return session.createName(rawName);
	}
	
	protected String normalizeName(String original) {
		if (null == original) {
			return "";
		}
		return original.trim().toLowerCase();
	}
	
	/**
	 * Check if the indicated role is configured for this user.
	 */
	protected boolean hasUserRole(String role) {
		// don't redo the work if this was already processed
		if (userRoles.contains(role)) {
			return true;
		}
		//  TODO:  also cache roles that were checked, but not found
		
		// Special logic for universal roles
		// This is calculated in initializeRoles, but I'll include it here so that it doesn't trigger lookup logic below if undefined.
		if (isAnonymous()) {
			userRoles.add(ROLE_ANONYMOUS);
		}
		else {
			userRoles.add(ROLE_NOT_ANONYMOUS);
		}
		
		try {
			Collection<String> cleanedList = getUserListForRole(role);
			
			// Check if the user is included directly in the list
			for (String key : userLookupKeys) {
				if (cleanedList.contains(key)) {
					log.dbg("Entry '" + key + "' matched for role '" + role + "'.");
					userRoles.add(role);
				}
			}
			
			// TODO:  check if the list contains a group associated with the user.
			
			// No matches at this point
			return false;
		}
		catch (Exception ex) {
			log.err("Exception when loading role '" + role + "':  ", ex);
			return false;  // default to rejecting role
		}
		

	}
	
	protected Collection<String> getUserListForRole(String role) {
		try {
			// I am not normalizing this, since roles are case-sensitive with the initial design
			String configKey = "role_" + role + "_users";
			Vector configList = ConfigurationUtils.getConfigAsVector(roleDatabase, configKey);
			// normalize to lowercase for case insensitive matching
			Set<String> cleanedList = new HashSet<String>();
			for (Object listEntry : configList) {
				String cleaned = normalizeName(listEntry.toString());
				cleanedList.add(cleaned);
			}
			return cleanedList;
		}
		catch (Exception ex) {
			log.err("No user list found for role '" + role + "':", ex);
			return new TreeSet<String>();
		}
	}
	
	protected Collection<String> getFullRoleList() {
		try {
			Vector fullRoleList = ConfigurationUtils.getConfigAsVector(roleDatabase, roleListKey);
			if (null == fullRoleList) {
				return new ArrayList<String>();
			}
			ArrayList<String> list = new ArrayList<String>();
			for (Object obj : fullRoleList) {
				list.add(obj.toString());
			}
			return list;
		}
		catch (Exception ex) {
			log.err("Error while reading full role list:  ", ex);
			return new ArrayList<String>();
		}
	}
	
	/**
	 * Get a full list of configured roles for the user.
	 * @return  the list of roles
	 */
	public Collection<String> getUserRoles() {
		// return an independent copy to avoid edits
		return new TreeSet<String>(userRoles);
	}
	
	public void refreshUserRoles() {
		userRoles.clear();
		initializeUserRoles();
	}
	
	
	/**
	 * Check if the user has access based on the specified roles.
	 * With the default logic, this will return <code>true</code> if the user has any of the specified roles.
	 */
	public boolean isAuthorizedForRoles() {
		for (String allowedRole : this.allowedRoles) {
			if (userRoles.contains(allowedRole)) {
				return true;
			}
		}
		// no matching roles
		return false;
	}
	
	/**
	 * Get the allowed roles for a user
	 */
	public Collection<String> getAllowedRoles() {
		// return an independent copy to avoid edits
		return new TreeSet<String>(allowedRoles);
	}
	
	/**
	 * Add an allowed role for this agent.
	 * @param role  the role to add
	 * @return <code>true</code> if the role was not already added
	 */
	public boolean addAllowedRole(String role) {
		return allowedRoles.add(role);
	}
	
	/**
	 * Remove an allowed role. Intended for use with overriding parent logic with inheritance.
	 * @param role  the role to remove
	 * @return <code>true</code> if the role was an allowed role
	 */
	public boolean removeAllowedRole(String role) {
		return allowedRoles.remove(role);
	}
	
	/**
	 * Check if the user is considered authenticated.
	 * If the user is not authenticated, they will not be allowed any other roles, regardless of wildcards.
	 */
	public boolean isAuthenticated() {
		if (!isAnonymous()) {
			return true;  // TODO:  more logic?
		}
		else if (getAllowAnonymous()) {
			return true;
		}
		else {
			return false;  // anonymous and not allowed
		}
	}

	public boolean isAnonymous() {
		String userID = getUserID();
//		log.dbg("Authenticated User:  '" + userID + "'");
//		log.dbg("allowAnonymous:  " + allowAnonymous + "");
		return null == userID || userID.equals(SecurityInterface.ANONYMOUS);
	}
}