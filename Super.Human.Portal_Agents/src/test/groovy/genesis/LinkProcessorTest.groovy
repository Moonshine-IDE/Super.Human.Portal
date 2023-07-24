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


public class LinkProcessorTest extends LinkProcessor {
	private JSONArray testData = null;
	
	public LinkProcessorTest() {
		super(null, new DefaultLogInterface());
		initializeInsertionParameters();
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