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
		
		public GenesisReadTest() {
			super();
			initializeInsertionParameters();
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
		

		@Override
		protected void initializeInsertionParameters() {
			serverAbbr = 'test-1.test.com/test';
			serverCommon = 'test-1.test.com';
    			addInsertionParameter("%SERVER_ABBR%", serverAbbr);
    			addInsertionParameter("%SERVER_COMMON%", serverCommon);
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
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		!test.getStringSafe(testLink, 'view')
	}
	
	def 'link database populated'() {
		// when the database is set already, it should not be overwritten
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"database": "actual.nsf"		
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/actual.nsf"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/actual.nsf"
		test.getStringSafe(testLink, 'database') == 'actual.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		!test.getStringSafe(testLink, 'view')
	}
	
	def 'link database valid url'() {
		// does not match database
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "notes://${test.serverCommon}/dombackup.nsf",  
			"database": "actual.nsf"		
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf"
		test.getStringSafe(testLink, 'database') == 'actual.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		!test.getStringSafe(testLink, 'view')
	}
	
	def 'link database encode'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dom backup.nsf"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dom+backup.nsf"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dom+backup.nsf"
		test.getStringSafe(testLink, 'database') == 'dom backup.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		!test.getStringSafe(testLink, 'view')
	}
	
	
	
	def 'link view simple'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"view": "TestView"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf/TestView?OpenView"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf/TestView?OpenView"
		test.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		test.getStringSafe(testLink, 'view') == "TestView"
	}	
	
	def 'link view encoded'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		// using example view from Genesis API
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"view": "8. Config"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf/8.+Config?OpenView"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf/8.+Config?OpenView"
		test.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		test.getStringSafe(testLink, 'view') == "8. Config"
	}
	
	def 'link encoded nested'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		// NOTE:  nested views work with `\` in my test, but not `/`
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "test/dombackup.nsf",
			"view": "foo\\\\bar\\\\testview"	
		}""")
		test.cleanupLink(testLink);
		
		then:
		test.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		test.getStringSafe(testLink, 'type') == 'database'
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/test%2Fdombackup.nsf/foo%5Cbar%5Ctestview?OpenView"
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/test%2Fdombackup.nsf/foo%5Cbar%5Ctestview?OpenView"
		test.getStringSafe(testLink, 'database') == 'test/dombackup.nsf'
		test.getStringSafe(testLink, 'server') == test.serverAbbr
		test.getStringSafe(testLink, 'view') == "foo\\bar\\testview"
	}
	
	
	def 'insertion parameters'() {
		when:
		GenesisReadTest test = new GenesisReadTest();
		test.addInsertionParameter("%TEST%", "foo");
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
		test.getStringSafe(access, "description") == "This is a foo addin on server ${test.serverAbbr} that will be accessible from https://${test.serverCommon}/foo"
		access.get("links")
		access.get("links") instanceof JSONArray
		
		when:
		JSONArray links = (JSONArray) access.get('links')
		JSONObject testLink = links.get(0)
		
		then:
		test.getStringSafe(testLink, 'name') == "Test addin on server ${test.serverAbbr}"
		test.getStringSafe(testLink, 'type') == "database"
		test.getStringSafe(testLink, 'description') == "This is a placeholder (foo) description.  %THIS% is not an insertion parameter."
		test.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf"
		// replace same parameter more than once
		test.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf"
		test.getStringSafe(testLink, 'server') == "${test.serverAbbr}"
		test.getStringSafe(testLink, 'database') == "fooactual.nsf"
		test.getStringSafe(testLink, 'view') == "Viewfoo"
		
	}
	
	
	def 'test notesPattern'() {
		// regex tests - serve as documentation for the intention of the regex
		expect:
		GenesisRead.notesURLPattern.matcher('notes://test-1.test.com/test.nsf').matches()
		GenesisRead.notesURLPattern.matcher('notes://test-1.test.com/test/folders/test.nsf').matches()  // database in folders
		GenesisRead.notesURLPattern.matcher('notes://test-1.test.com/test.nsf/agent').matches()  // trailing design element (alias)
		GenesisRead.notesURLPattern.matcher('notes://test-1.test.com/test.nsf?param1=foo').matches()  // parameters
		GenesisRead.notesURLPattern.matcher('notes://test-1.test.com/test.nsf/agent?OpenAgent').matches()  // trailing design element and action
		
		
		!GenesisRead.notesURLPattern.matcher('test.nsf').matches()  // old design - database only
		!GenesisRead.notesURLPattern.matcher('test/folders/test.nsf').matches()  // more complicated database
		!GenesisRead.notesURLPattern.matcher('https://test-1.test.com/test.nsf').matches()  // https
	}
	
	def 'test isDatabaseName'() {
		when:
		GenesisReadTest test = new GenesisReadTest()
		
		then:
		test.isDatabaseName('test.nsf')
		test.isDatabaseName('foo/bar/test.nsf')
		
		!test.isDatabaseName('test.nsf/trailing')
		!test.isDatabaseName('https://test-1.test.com/test.nsf')
		!test.isDatabaseName('notes://test-1.test.com/test.nsf')
		!test.isDatabaseName("notes://%SERVER_COMMON%/dombackup.nsf")  // URL before insertion parameters
	}
	
}