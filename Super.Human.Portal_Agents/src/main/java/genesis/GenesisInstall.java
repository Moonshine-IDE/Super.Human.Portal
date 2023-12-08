package genesis;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Collection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONObject;

import com.moonshine.domino.security.SecurityInterface;
import com.moonshine.domino.util.DominoUtils;

import auth.RoleRestrictedAgent;
import auth.SecurityBuilder;
import auth.SimpleRoleSecurity;
import lotus.domino.Document;
import lotus.domino.NotesException;
import lotus.domino.View;
import util.SimpleHTTPClient;
import util.ValidationException;

/**
 * Install a Genesis application
 */
public class GenesisInstall extends GenesisRead 
{
	@Override
	public Collection<String> getAllowedRoles() {
		return SecurityBuilder.buildList(SecurityBuilder.ROLE_ADMINISTRATOR);
	}
	
	@Override
	protected SecurityInterface createSecurityInterface() {
		return SecurityBuilder.buildInstance(agentDatabase, this, session, getLog());
	}
	
	@Override
	protected void runAction() {
		String directory = getParameter("directory");
		String appID = getParameter("AppID");
		if (DominoUtils.isValueEmpty(appID)) {
			reportError("Missing parameter:  'AppID'");
			return;
		}
		getLog().dbg("Installing app '" + appID + "' from directory '" + directory + ".");
		
		// TODO:  check if app is already installed?  Is there a use case for running the installation again?
		
		try {
			final String commandPrefix = "tell Genesis ";
			String command = getInstallCommand(appID, directory);
			if (!command.toLowerCase().startsWith(commandPrefix.toLowerCase())) {
				command = commandPrefix + command;
			}
			getLog().dbg("Running command '" + command + "'.");
			
			// The documentation said that the server parameter should be null for the local server, but I found I needed "" instead.
			String response = session.sendConsoleCommand("", command);
			getLog().dbg("Response:  " + response);
			
			
			appSpecificActions(appID, command);
			
			
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
     * @param directory  the label/ID of the Genesis Directory to use for the installation
     * @return
     * @throws ValidationException  if the indicated application was not found
     * @throws Exception for other exceptions
     */
    protected String getInstallCommand(String appID, String directory) throws ValidationException, NotesException, Exception {
    		if (isDefaultDirectory(directory)) {
    			return getInstallCommand(appID, (Document) null, directory);
    		}
    		else {
    			View directoryView = null;
    			Document directoryDoc = null;
    			try {
    				directoryView = DominoUtils.getView(getTargetDatabase(), "GenesisDirectory/By Label");
    				directoryDoc = directoryView.getDocumentByKey(directory);
				if (null == directoryDoc) {
					throw new ValidationException("Unrecognized Genesis Directory:  '" + directory + "'");
				}
				return getInstallCommand(appID, directoryDoc, directory);
			}
			finally {
				DominoUtils.recycle(session, directoryDoc);
				DominoUtils.recycle(session, directoryView);
			}
		}
	}
	
	protected String getInstallCommand(String appID, Document directoryDoc, String directory) throws ValidationException {
        try {
            // look this up from the API used by GenesisCatalog_GetAll
            SimpleHTTPClient http = new SimpleHTTPClient(1000, 1000, 0);
            String url = getAppURL(appID);
            if (null != directoryDoc) {
            		url = getAppURL(appID, directoryDoc);
            }
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
            // Example:  install genesis-directory
            
            // Could also be:  tell Genesis install genesis-directory
            // Normalize this
            Pattern commandPrefixPattern = Pattern.compile("^\\s*tell\\s+genesis\\s+", Pattern.CASE_INSENSITIVE);
            Matcher matcher = commandPrefixPattern.matcher(installCommand);
            installCommand = matcher.replaceFirst("");
            
            // modify the command syntax if this is an additional directory:
            // Example:  tell Genesis origin https://domino.demo.startcloud.com/gc-p.nsf - install demotest
            if (null != directoryDoc) {
				
				String directoryURL = getBaseURL(directoryDoc);
				String password =  directoryDoc.getItemValueString("password");
				
				String directoryPrefix = "origin \"" + directoryURL + "\" ";  // TODO:  encode/escape URL
				if (DominoUtils.isValueEmpty(password)) {
					// placeholder for no password
					directoryPrefix += "- ";
				}
				else {
					directoryPrefix += "\"" + password + "\" ";  // TODO:  encode/escape password
				}
            		
				installCommand = directoryPrefix + installCommand;
            		
            }
            
            return installCommand;
        }
        catch (ValidationException ex) {
            throw ex;
        }
        catch (Exception ex) {
            throw new ValidationException("Unable to lookup installation command.", ex);
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
    
    protected String getAppURL(String appID, Document directoryDoc) throws NotesException, ValidationException {
    		
    		// add the app ID
    		String url = getBaseAPI(directoryDoc);
    		url += "/" + appID;
    		return url;
    }
    
    /** 
     * Check if the given label corresponds to the default directory.
     * @param  label  The label for the directory
     */
    protected boolean isDefaultDirectory(String label) {
    		return DominoUtils.isValueEmpty(label) || label.equalsIgnoreCase(DEFAULT_DIRECTORY_LABEL);
    }
    
    protected void appSpecificActions(String appID, String command) {
		try {
			if (null == appID) {
				return;  // nothing to do
			}
			else if (appID.equalsIgnoreCase("genesis-directory")) {
				Document directoryDoc = null;
				try {
					directoryDoc = getTargetDatabase().createDocument();
					directoryDoc.replaceItemValue("Form", "GenesisDirectory");
					directoryDoc.replaceItemValue("label", "Local");
					directoryDoc.replaceItemValue("password", "");
					
					// build the default URL
					// TODO:  this is specialized for SHI Domino instances.  Make this more general, or only run for SHI instances?
					LinkProcessor processor = new LinkProcessor(session, getLog(), agentDatabase);
					String url = "http://" + processor.serverCommon;
					url += ":82/";  // Default for SHI Domino servers.  TODO:  determine this from server document?
					
					String dbName = "gdp1.nsf";  
					// parse from the command instead
					Pattern dbNamePattern = Pattern.compile("^.*\\b\"?(\\S+\\.nsf)\"?$", Pattern.CASE_INSENSITIVE);
					Matcher matcher = dbNamePattern.matcher(dbName);
					if (matcher.matches()) {
						dbName = matcher.group(1);
					}
					url += dbName;
					
					directoryDoc.replaceItemValue("url", url);
					
					directoryDoc.save(true);
					
				}
				finally {
					DominoUtils.recycle(session, directoryDoc);
				}
			}
		}
		catch (Exception ex) {
			getLog().err("Error in appSpecificActions:  ", ex);
			// don't fail the install
		}
    }
}