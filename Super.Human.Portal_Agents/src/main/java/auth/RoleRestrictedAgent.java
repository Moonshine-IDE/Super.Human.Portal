package auth;

import java.util.Collection;

import com.moonshine.domino.security.SecurityInterface;

/**
 * Used to define a consistent interface for agent roles, for easy setup and verification.
 */
public interface RoleRestrictedAgent 
{
	/**
	 * Get the allowed roles for the agent.  Should be used when building the securityi
	 */
	public Collection<String> getAllowedRoles();
	
	/**
	 * Return the security interface for verification
	 */
	public SecurityInterface checkSecurity();
	
}