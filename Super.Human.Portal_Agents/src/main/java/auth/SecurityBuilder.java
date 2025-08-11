package auth;

import java.util.ArrayList;
import java.util.Collection;

import com.moonshine.domino.log.LogInterface;
import com.moonshine.domino.security.SecurityInterface;

import lotus.domino.Database;
import lotus.domino.Session;

/**
 * Utility to build SecurityInterface instances for the agents
 */
public class SecurityBuilder  
{
	public static final String ROLE_ADMINISTRATOR = "Administrator";
	
	public static final String RESTRICT_DOCUMENTATION_VIEW = "viewDocumentation";
	public static final String RESTRICT_DOCUMENTATION_MANAGE = "manageDocumentation";
	public static final String RESTRICT_APPS_VIEW = "viewInstalledApps";
	public static final String RESTRICT_APPS_INSTALL = "installApps";
	public static final String RESTRICT_BOOKMARKS_VIEW = "viewBookmarks";
	public static final String RESTRICT_BOOKMARKS_MANAGE = "manageBookmarks";
	public static final String RESTRICT_BROWSE_MY_SERVER = "browseMyServer";
	public static final String RESTRICT_GENESIS_MANAGE = "additionalGenesis";
	public static final String RESTRICT_IMPROVEMENT_REQUESTS = "improvementRequests";
	
	public static SecurityInterface buildInstance(Database roleDatabase, RoleRestrictedAgent agent, Session session, LogInterface log) {
		return new SimpleRoleSecurity(roleDatabase, agent.getRoleRestrictionID(), agent.getAllowedRoles(), session, log);
	}
	
	public static Collection<String> buildList(String role1) {
		ArrayList<String> roles = new ArrayList<String>();
		roles.add(role1);
		return roles;
	}
	public static Collection<String> buildList(String role1, String role2) {
		ArrayList<String> roles = new ArrayList<String>();
		roles.add(role1);
		roles.add(role2);
		return roles;
	}
	public static Collection<String> buildList(String role1, String role2, String role3) {
		ArrayList<String> roles = new ArrayList<String>();
		roles.add(role1);
		roles.add(role2);
		roles.add(role3);
		return roles;
	}
}