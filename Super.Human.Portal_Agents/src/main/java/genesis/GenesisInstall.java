package genesis;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.json.JSONObject;

import com.moonshine.domino.security.AllowAllSecurity;
import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;

import util.SimpleHTTPClient;
import util.ValidationException;

/**
 * Install a Genesis application
 */
public class GenesisInstall extends GenesisRead 
{
	@Override
	protected SecurityInterface createSecurityInterface() {
		return new AllowAllSecurity(session);
	}
	
	@Override
	protected void runAction() {
		String appID = getParameter("AppID");
		if (DominoUtils.isValueEmpty(appID)) {
			reportError("Missing parameter:  'AppID'");
			return;
		}
		getLog().dbg("Installing app '" + appID + "'.");
		
		// TODO:  check if app is already installed?  Is there a use case for running the installation again?
		
		try {
			final String commandPrefix = "tell Genesis ";
			String command = getInstallCommand(appID);
			if (!command.toLowerCase().startsWith(commandPrefix.toLowerCase())) {
				command = commandPrefix + command;
			}
			getLog().dbg("Running command '" + command + "'.");
			
			// The documentation said that the server parameter should be null for the local server, but I found I needed "" instead.
			String response = session.sendConsoleCommand("", command);
			getLog().dbg("Response:  " + response);
			
			
			jsonRoot.put("successMessage", "Installation has started for application '" + appID + "'.");
		}
		catch (ValidationException ex) {
			getLog().err("Exception:  ", ex);
			reportError(ex.getPublicError());
		}
		catch (Exception ex) {
			getLog().err("Exception:  ", ex);
			reportError("Could not install app '" + appID + "'.");
			
		}
	}
    
    /**
     * Lookup or generate the install command for the indicated application
     * @param appID  the ID of the application
     * @return
     * @throws ValidationException  if the indicated application was not found
     * @throws Exception for other exceptions
     */
    protected String getInstallCommand(String appID) throws ValidationException {
        try {
            // look this up from the API used by GenesisCatalog_GetAll
            SimpleHTTPClient http = new SimpleHTTPClient(1000, 1000, 0);
            String url = getAppURL(appID);
            getLog().dbg("App URL:  " + url);
            String output = http.getPage(url);  // already throws ValidationException on error
            getLog().dbg("Raw output:  '" + output + "'");
            JSONObject json = new JSONObject(output);
            JSONObject app = json.getJSONObject("app");
            if (null == app) {
                throw new ValidationException("Application not found.");
            }
            String installCommand = app.getString("install");
            if (DominoUtils.isValueEmpty(installCommand)) {
                throw new ValidationException("No installation command defined for application '" + appID + "'.");
            }
            
            return installCommand;
        }
        catch (ValidationException ex) {
            throw ex;
        }
        catch (Exception ex) {
            throw new ValidationException("Unable to lookup installation command.");
        }
        
        
//        return "install " + appID;
    }

    /**
     * Get the URL to retrieve the application details
     * @param appID  the ID of the application
     * @return  a URL 
     * @throws UnsupportedEncodingException
     * @throws Exception if the configuration lookup failed
     */
    protected String getAppURL(String appID) throws UnsupportedEncodingException, Exception {
        String url = getDataURL();
        
        if (!url.endsWith("/")) {
            url += "/";
        }
        url += URLEncoder.encode(appID, "utf-8");
        return url;
    }
}