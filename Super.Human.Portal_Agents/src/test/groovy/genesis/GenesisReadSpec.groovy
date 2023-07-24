package genesis

import spock.lang.*

import java.util.Collection;
import java.util.TreeSet;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import lotus.domino.NotesException

import util.JSONUtils;
import util.ValidationException;

/**
 * Test the JSON conversion logic for GenesisReadSpec
 */
class GenesisReadSpec extends Specification {
	private class GenesisReadTest extends GenesisRead {
		private JSONArray testData = null;
		
		public GenesisReadTest() {
			super();
			linkProcessor = new LinkProcessorTest();
		}
		
		@Override
		protected JSONArray getGenesisAppList()
				throws NotesException, Exception, ValidationException, IOException {
			return testData;
		}
		
		@Override
		protected void loadInstalledApps() {
			// set the installed apps instead
		}
		
		protected void setTestData(JSONArray testData) {
			this.testData = testData;
		}
		
		protected void setTestData(String testData) {
			JSONObject original = new JSONObject(data);
			JSONArray list = (JSONArray)original.get("list");
			setTestData(list)
		}
		
		protected void addInstalledApp(String appName) {
			installedApps.add(appName);
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

	
	
	def 'insertion parameters'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		test.linkProcessor.addInsertionParameter("%TEST%", "foo");
		JSONObject testAccess = new JSONObject("""{
			"access": {
				"description": "This is a %TEST% addin on server %SERVER_ABBR% that will be accessible from https://%SERVER_COMMON%/%TEST%",
				"links": [{
					"name": "Test addin on server %SERVER_ABBR%",
					"type": "database",
					"description": "This is a placeholder (%TEST%) description.  %THIS% is not an insertion parameter.",
					"url": "notes://%SERVER_COMMON%/dombackup.nsf", 
					"nomadURL": "https://nomadweb.%SERVER_COMMON%/nomad/#/notes://%SERVER_COMMON%/dombackup.nsf", 
					"server": "%SERVER_ABBR%", 
					"database": "%TEST%actual.nsf",
					"view": "View%TEST%"
				}]
			}
		}""")
		// JSONObject expected = new JSONObject("""{
		// 	"access": {
		// 		"description": "This is a foo addin on server ${test.serverAbbr} that will be accessible from https://${test.serverCommon}/foo",
		// 		"links": [{
		// 			"name": "Test addin on server ${test.serverAbbr}",
		// 			"type": "database",
		// 			"url": "notes://${test.serverCommon}/dombackup.nsf", 
		// 			"nomadURL": "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}dombackup.nsf", 
		// 			"server": "${test.serverAbbr}", 
		// 			"database": "fooactual.nsf",
		// 			"view": "Viewfoo"
		// 		}]
		// 	}	
		// }""")
		JSONObject target = new JSONObject()
		test.copyAccessInfo(target, testAccess)
		
		then:
		// I found it too difficult to debug errors like this
		//expected == target
		target.get("access")
		target.get("access") instanceof JSONObject
		
		when:
		JSONObject access = (JSONObject) target.get("access")
		
		then:
		// replace multiple parameters
		JSONUtils.getStringSafe(access, "description") == "This is a foo addin on server ${test.linkProcessor.serverAbbr} that will be accessible from https://${test.linkProcessor.serverCommon}/foo"
		access.get("links")
		access.get("links") instanceof JSONArray
		
		when:
		JSONArray links = (JSONArray) access.get('links')
		JSONObject testLink = links.get(0)
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == "Test addin on server ${test.linkProcessor.serverAbbr}"
		JSONUtils.getStringSafe(testLink, 'type') == "database"
		JSONUtils.getStringSafe(testLink, 'description') == "This is a placeholder (foo) description.  %THIS% is not an insertion parameter."
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.linkProcessor.serverCommon}/dombackup.nsf"
		// replace same parameter more than once
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.linkProcessor.serverCommon}/nomad/#/notes://${test.linkProcessor.serverCommon}/dombackup.nsf"
		JSONUtils.getStringSafe(testLink, 'server') == "${test.linkProcessor.serverAbbr}"
		JSONUtils.getStringSafe(testLink, 'database') == "fooactual.nsf"
		JSONUtils.getStringSafe(testLink, 'view') == "Viewfoo"
		
	}

	
}