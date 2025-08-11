package auth;

import java.util.Collection;

import com.moonshine.domino.security.SecurityInterface;

/**
 * Used to define a consistent interface for agent roles, for easy setup and verification.
 */
public interface RoleRestrictedAgent 
{
	/**
	 * Get an ID that will be used to lookup the role restrictions for this agent.
	 * If not <code>null</code>, this will have priority over {@link #getAllowedRoles()}.
	 */
	public String getRoleRestrictionID();
	
	/**
	 * Get the allowed roles for the agent.  Should be used when building the security.
	 * Lower priority than getRoleRestrictionID
	 */
	public Collection<String> getAllowedRoles();
	
	/**
	 * Return the security interface for verification
	 */
	public SecurityInterface checkSecurity();
	
}