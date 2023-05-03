package genesis

import spock.lang.*

import java.util.Collection;
import java.util.TreeSet;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import lotus.domino.NotesException

import util.ValidationException;

/**
 * Test the JSON conversion logic for GenesisReadSpec
 */
class GenesisReadSpec extends Specification {
	private class GenesisReadTest extends GenesisRead {
		private JSONArray testData = null;
		
		@Override
		protected JSONArray getGenesisAppList()
				throws NotesException, Exception, ValidationException, IOException {
			return testData;
		}
		
		@Override
		protected void loadInstalledApps() {
			// set the installed apps instead
		}
		

		@Override
		protected void initializeInsertionParameters() {
			serverAbbr = 'test-1.test.com/test';
			serverCommon = 'test-1.test.com';
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
	
	def 'link browser simple'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
            "name": "Web Interface",
            "type": "browser",
            "url": "/Super.Human.Portal/js-release/index.html"
          }""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'Web Interface'
		test.getStringSafe(testLink, 'type') == 'browser'
		test.getStringSafe(testLink, 'url') == "/Super.Human.Portal/js-release/index.html"
		!test.getStringSafe(testLink, 'nomadURL')
		!test.getStringSafe(testLink, 'database')
		!test.getStringSafe(testLink, 'server')
		!test.getStringSafe(testLink, 'view')
	}
	
	def 'link database simple'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf"
		test.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		test.getStringSafe(testLink, 'server') == test.serverCommon
		!test.getStringSafe(testLink, 'view')
	}
	
}