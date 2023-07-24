package util;

import org.json.JSONException;
import org.json.JSONObject;

import com.moonshine.domino.log.LogInterface;

public class JSONUtils  
{
	public JSONUtils()
	{
	}
    
    public static String getStringSafe(JSONObject object, String key) {
    		try {
    			return object.getString(key);
    		}
    		catch (JSONException ex) {
    			// this fails if the key was not found.  Return null instead.
    			return null;
		}
    }
    
    /**
     * Copy the indicated property from one object to another.
     * If the property was not found in the original, then set the default value, or do not set the property if <code>defaultValue == null</code>
     * @param orig  the original object
     * @param origName  the original property name
     * @param target  the target object
     * @param targetName  the new property name
     * @param defaultValue  the default value to use, or <code>null</code> to leave the property unset.
     */
    public static void copyPropertySafe(JSONObject orig, String origName, JSONObject target, String targetName, Object defaultValue, LogInterface log) {
    		Object value = null;
    		try {
    			value = orig.get(origName);
    		}
    		catch (JSONException ex) {
    			// key not found
    		}
    		
    		if (null == value) {
    			if (null == defaultValue) {
    				return; // do not set the property
    			}
    			else {
    				value = defaultValue;
    			}
    		}
    		
    		// safely update the property
    		try {
    			target.put(targetName, value);
    		}
    		catch (JSONException ex) {
    			// unexpected error - probably an invalid value
    			log.err("Could not set property '" + targetName + "' to '" + value.toString() + "'.");
    		}
    }
}