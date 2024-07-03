package auth

import spock.lang.*

import helper.FakeName;

import java.util.Collection;
import java.util.TreeMap;
import java.util.TreeSet;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import lotus.domino.NotesException
import lotus.domino.Name;

import util.JSONUtils;
import util.ValidationException;

import com.moonshine.domino.security.SecurityInterface
import com.moonshine.domino.log.DefaultLogInterface;

import config.*;
import CategoryAgents.*;
import CustomBookmarkAgents.*;
import DocumentationFormAgents.*;
import genesis.*;
import GenesisDirectoryAgents.*;

/**
 * Test the user matching logic for SimpleRoleSecurity
 */
class SimpleRoleSecuritySpec extends Specification {
	def roleMap = new TreeMap<String, Collection<String> >();
	private String testUser = '';
	
	private class SimpleRoleSecurityTest extends SimpleRoleSecurity {
		public SimpleRoleSecurityTest(String user, boolean allowAnonymous, roleMap) {
			super(null, null, new DefaultLogInterface());
			this.testUser = user;
			setAllowAnonymous(allowAnonymous);
			this.roleMap = roleMap;
			
			// need to regenerate the roles at this point
			initializeUserRoles();
		}
		
		@Override
		public String getUserID() {
			return this.testUser;
		}
		
		@Override
		protected Name createName(String rawName) throws NotesException {
			return new FakeName(rawName);
		}
	
		@Override
		protected Collection<String> getUserListForRole(String role) {
			try {
				// I am not normalizing this, since roles are case-sensitive with the initial design
				String configKey = "role_" + role + "_users";
				Collection<String> configList = roleMap[configKey]
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
	
		@Override
		protected Collection<String> getFullRoleList() {
			return ['Administrator']
		}
		
		@Override
		protected void initializeAllowAnonymous() {
			// nothing to do
		}
	}
	
	def cleanupSpec() {
		// run after last feature method
	}
	
	def setup() {
		// run before every feature method
	}
	
	def cleanup() {
		// run after every feature method
	}
	
	
	
	/**
	 * Data-driven tests:  https://spockframework.org/spock/docs/1.0/data_driven_testing.html
	 * @Unroll is required to see which line failed.
	 */
	@Unroll	
	def 'test getRoles:  user=#user, allowAnonymous=#allowAnonymous, roleMap=#roleMap'() {
		expect:
		
		SimpleRoleSecurity testSecurity = new SimpleRoleSecurityTest(user, allowAnonymous, roleMap);
		testSecurity.getUserRoles() == new TreeSet<String>(expectedRoles);
		
		
		where:
		
        user         | allowAnonymous | roleMap                                                   | expectedRoles
        ''           | false          | ['role_Administrator_users':['Demo Admin']]               | [] // No roles are allowed for Anonymous in this case
        ''           | false          | ['role_Administrator_users':['Anonymous', 'Demo Admin']]  | [] // No roles are allowed for Anonymous in this case
        ''           | true           | ['role_Administrator_users':['Demo Admin']]               | ['All', 'Anonymous'] // Default roles
        ''           | true           | ['role_Administrator_users':['Anonymous', 'Demo Admin']]  | ['All', 'Anonymous', 'Administrator'] // Support for "Anonymous" user entry
        ''           | true           | ['role_Administrator_users':['*']]                        | ['All', 'Anonymous', 'Administrator'] // Anonymous is included in wildcard
        ''           | true           | ['role_Administrator_users':['*/*']]                      | ['All', 'Anonymous'] // Anonymous is not included in user wildcard
        'Demo Admin' | true           | ['role_Administrator_users':['Demo Admin']]               | ['All', 'NotAnonymous', 'Administrator'] // Simple match
        'Demo Admin' | false          | ['role_Administrator_users':['Demo Admin']]               | ['All', 'NotAnonymous', 'Administrator'] // allow_anonymous doesn't matter
        'Demo Admin' | false          | ['role_Administrator_users':[]]                           | ['All', 'NotAnonymous'] // Default Roles
        'Demo Admin' | false          | ['role_Administrator_users':['Demo Admin/TEST']]          | ['All', 'NotAnonymous', 'Administrator'] // Abbreviated
        'Demo Admin' | false          | ['role_Administrator_users':['CN=Demo Admin/O=TEST']]     | ['All', 'NotAnonymous', 'Administrator'] // Canonical
        'Demo Admin' | false          | ['role_Administrator_users':['*']]                        | ['All', 'NotAnonymous', 'Administrator'] // Wildcard
        'Demo Admin' | false          | ['role_Administrator_users':['*/*']]                      | ['All', 'NotAnonymous', 'Administrator'] // User Wildcard
        'Demo Admin' | false          | ['role_Administrator_users':['*/TEST']]                   | ['All', 'NotAnonymous', 'Administrator'] // Organization Wildcard
        'Demo Admin' | false          | ['role_Administrator_users':['demo admin']]               | ['All', 'NotAnonymous', 'Administrator'] // Case insensitive
        'Demo Admin' | false          | ['role_Administrator_users':['demo admin/test']]          | ['All', 'NotAnonymous', 'Administrator'] // 
        'Demo Admin' | false          | ['role_Administrator_users':['cn=demo admin/o=test']]     | ['All', 'NotAnonymous', 'Administrator'] // 
        'Demo Admin' | false          | ['role_Administrator_users':['*/test']]                   | ['All', 'NotAnonymous', 'Administrator'] // 

	}
	
	@Unroll
	def 'Test roles for agent #agent.getClass()'() {
		expect:
		

		agent instanceof RoleRestrictedAgent
		agent.getAllowedRoles() == allowedRoles
		// This triggers a StackOverflowError.  I think this is because of the dependency on DominoAPI instances for initialization
		// SecurityInterface security = agent.checkSecurity();
		// security
		// security instanceof SimpleRoleSecurity
		// security.getAllowedRoles() == agent.getAllowedRoles();

		
		where:
		// TODO:  dynamically identify the agents from agentProperties (or AgentBase subclasses) and create instances
		
        agent                               | allowedRoles
        new ConfigRead()                    | ['All']
        new XMLAuthenticationTest()         | ['All']
        new DocumentationFormRead()         | ['All']
        new DocumentationFormDelete()       | ['All']
        new DocumentationFormCreate()       | ['All']
        new DocumentationFormUpdate()       | ['All']
        new CategoryRead()                  | ['All']
        new CategoryDelete()                | ['All']
        new CategoryCreate()                | ['All']
        new CategoryUpdate()                | ['All']
        new CustomBookmarkDelete()          | ['Administrator']
        new CustomBookmarkCreate()          | ['Administrator']
        new CustomBookmarkUpdate()          | ['Administrator']
        new CustomBookmarkRead()            | ['All']
        new DatabaseRead()                  | ['All']
        new GenesisDirectoryUpdate()        | ['Administrator']
        new GenesisDirectoryCreate()        | ['Administrator']
        new GenesisDirectoryDelete()        | ['Administrator']
        new GenesisDirectoryRead()          | ['Administrator']
        new GenesisRead()                   | ['All']
        new GenesisInstall()                | ['Administrator']



	}
	
}