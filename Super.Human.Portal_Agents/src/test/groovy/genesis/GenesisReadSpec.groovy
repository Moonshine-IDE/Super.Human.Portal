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
	}
	
}