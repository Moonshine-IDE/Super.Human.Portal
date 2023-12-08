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
	
	public static SecurityInterface buildInstance(Database roleDatabase, RoleRestrictedAgent agent, Session session, LogInterface log) {
		return new SimpleRoleSecurity(roleDatabase, agent.getAllowedRoles(), session, log);
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