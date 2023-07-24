package genesis

import spock.lang.*

import com.moonshine.domino.log.DefaultLogInterface;

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
class LinkProcessorSpec extends Specification {
	
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
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
            "name": "Web Interface",
            "type": "browser",
            "url": "/Super.Human.Portal/js-release/index.html"
          }""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'Web Interface'
		JSONUtils.getStringSafe(testLink, 'type') == 'browser'
		JSONUtils.getStringSafe(testLink, 'url') == "/Super.Human.Portal/js-release/index.html"
		!JSONUtils.getStringSafe(testLink, 'nomadURL')
		!JSONUtils.getStringSafe(testLink, 'database')
		!JSONUtils.getStringSafe(testLink, 'server')
		!JSONUtils.getStringSafe(testLink, 'view')
	}
	
	def 'link database simple'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf"
		JSONUtils.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		!JSONUtils.getStringSafe(testLink, 'view')
	}
	
	def 'link database populated'() {
		// when the database is set already, it should not be overwritten
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"database": "actual.nsf"		
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/actual.nsf"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/actual.nsf"
		JSONUtils.getStringSafe(testLink, 'database') == 'actual.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		!JSONUtils.getStringSafe(testLink, 'view')
	}
	
	def 'link database valid url'() {
		// does not match database
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "notes://${test.serverCommon}/dombackup.nsf",  
			"database": "actual.nsf"		
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf"
		JSONUtils.getStringSafe(testLink, 'database') == 'actual.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		!JSONUtils.getStringSafe(testLink, 'view')
	}
	
	def 'link database encode'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dom backup.nsf"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dom+backup.nsf"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dom+backup.nsf"
		JSONUtils.getStringSafe(testLink, 'database') == 'dom backup.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		!JSONUtils.getStringSafe(testLink, 'view')
	}
	
	
	
	def 'link view simple'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"view": "TestView"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf/TestView?OpenView"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf/TestView?OpenView"
		JSONUtils.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		JSONUtils.getStringSafe(testLink, 'view') == "TestView"
	}	
	
	def 'link view encoded'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		// using example view from Genesis API
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "dombackup.nsf",
			"view": "8. Config"			
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/dombackup.nsf/8.+Config?OpenView"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/dombackup.nsf/8.+Config?OpenView"
		JSONUtils.getStringSafe(testLink, 'database') == 'dombackup.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		JSONUtils.getStringSafe(testLink, 'view') == "8. Config"
	}
	
	def 'link encoded nested'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest();
		// NOTE:  nested views work with `\` in my test, but not `/`
		JSONObject testLink = new JSONObject("""{
			"name": "NotesDatabase Link",
			"type": "database",
			"url": "test/dombackup.nsf",
			"view": "foo\\\\bar\\\\testview"	
		}""")
		test.cleanupLink(testLink);
		
		then:
		JSONUtils.getStringSafe(testLink, 'name') == 'NotesDatabase Link'
		JSONUtils.getStringSafe(testLink, 'type') == 'database'
		JSONUtils.getStringSafe(testLink, 'url') == "notes://${test.serverCommon}/test%2Fdombackup.nsf/foo%5Cbar%5Ctestview?OpenView"
		JSONUtils.getStringSafe(testLink, 'nomadURL') == "https://nomadweb.${test.serverCommon}/nomad/#/notes://${test.serverCommon}/test%2Fdombackup.nsf/foo%5Cbar%5Ctestview?OpenView"
		JSONUtils.getStringSafe(testLink, 'database') == 'test/dombackup.nsf'
		JSONUtils.getStringSafe(testLink, 'server') == test.serverAbbr
		JSONUtils.getStringSafe(testLink, 'view') == "foo\\bar\\testview"
	}
	
	
	def 'test notesPattern'() {
		// regex tests - serve as documentation for the intention of the regex
		expect:
		LinkProcessor.notesURLPattern.matcher('notes://test-1.test.com/test.nsf').matches()
		LinkProcessor.notesURLPattern.matcher('notes://test-1.test.com/test/folders/test.nsf').matches()  // database in folders
		LinkProcessor.notesURLPattern.matcher('notes://test-1.test.com/test.nsf/agent').matches()  // trailing design element (alias)
		LinkProcessor.notesURLPattern.matcher('notes://test-1.test.com/test.nsf?param1=foo').matches()  // parameters
		LinkProcessor.notesURLPattern.matcher('notes://test-1.test.com/test.nsf/agent?OpenAgent').matches()  // trailing design element and action
		
		
		!LinkProcessor.notesURLPattern.matcher('test.nsf').matches()  // old design - database only
		!LinkProcessor.notesURLPattern.matcher('test/folders/test.nsf').matches()  // more complicated database
		!LinkProcessor.notesURLPattern.matcher('https://test-1.test.com/test.nsf').matches()  // https
	}
	
	def 'test isDatabaseName'() {
		when:
		LinkProcessorTest test = new LinkProcessorTest()
		
		then:
		test.isDatabaseName('test.nsf')
		test.isDatabaseName('foo/bar/test.nsf')
		
		!test.isDatabaseName('test.nsf/trailing')
		!test.isDatabaseName('https://test-1.test.com/test.nsf')
		!test.isDatabaseName('notes://test-1.test.com/test.nsf')
		!test.isDatabaseName("notes://%SERVER_COMMON%/dombackup.nsf")  // URL before insertion parameters
	}
	
}