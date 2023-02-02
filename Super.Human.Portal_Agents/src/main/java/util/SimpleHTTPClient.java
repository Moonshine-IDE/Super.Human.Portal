package util;

import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpConnectionManager;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.SimpleHttpConnectionManager;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.params.HttpClientParams;
import org.apache.commons.httpclient.params.HttpConnectionManagerParams;
import org.apache.commons.httpclient.protocol.Protocol;
import org.apache.commons.httpclient.protocol.ProtocolSocketFactory;


import util.StringUtils;
import util.ValidationException;

/**
 * A wrapper for Apache Commons HttpClient that will provide some simple functionality.
 * It also provides a function to make the HttpClients ignore certificate errors
 * ({@link #setIgnoreCert()}, and to {@link #getDefaultClient(int, int, int)}.
 * @author Joel Anderson
 *
 */
public class SimpleHTTPClient {

    /** The Apache HttpClient used to get the report for each VM */
    protected HttpClient httpClient = null;
    
    /**
     * Initialize the internal HttpClient instance
     * @param socketTimeout  timeout for the socket
     * @param connectionTimeout  timeout for the connection
     * @param retry  number of allowed retries
     */
    public SimpleHTTPClient(int socketTimeout, int connectionTimeout, int retry) {
        httpClient = getDefaultClient(socketTimeout, connectionTimeout, retry);
    }
    
    /**
     * Set the global protocol to ignore certificate errors.  This will affect
     * all HTTPClient instances associated with this program.
     */
    public static void setIgnoreCert() {
        Protocol easyhttps = new Protocol("https",
                (ProtocolSocketFactory) new EasySSLProtocolSocketFactory(), 443);
        Protocol.registerProtocol("https", easyhttps);
    }
    
    
    /**
     * Setup an HTTPClient, with the given timeout parameters
     * @param socketTimeout  timeout for the socket
     * @param connectionTimeout  timeout for the connection
     * @param retry  number of allowed retries
     * @return the initialized HTTPClient
     */
    public static HttpClient getDefaultClient(int socketTimeout,
            int connectionTimeout, int retry) {
        DefaultHttpMethodRetryHandler retryhandler = new DefaultHttpMethodRetryHandler(
                retry, true);

        HttpClientParams clientParams = new HttpClientParams();
        clientParams.setSoTimeout(socketTimeout);

        clientParams.setParameter(HttpClientParams.RETRY_HANDLER, retryhandler);
        clientParams.setConnectionManagerTimeout(connectionTimeout);

        HttpConnectionManagerParams connectionManagerParams = new HttpConnectionManagerParams();
        connectionManagerParams.setConnectionTimeout(connectionTimeout);
        HttpConnectionManager manager = new SimpleHttpConnectionManager();
        manager.setParams(connectionManagerParams);

        return new HttpClient(clientParams, manager);
    }
    
    /**
     * Perform a simple get request to get a the page at the given URL
     * @param url  the URL, which may contain query string parameters
     * @return  the response from the URL
     * @throws ValidationException  If there was an error code
     * @throws IOException  if an IO error occurred while calling the URL
     */
    public String getPage(String url) throws ValidationException, IOException {
        
            GetMethod method = new GetMethod(url);
            int statusCode = httpClient.executeMethod(method);
            String message = method.getStatusText();
            InputStream inputStream = method.getResponseBodyAsStream();
            String page = StringUtils.convertStreamToString(inputStream);
            
            
            // check for error codes
            if (HttpStatus.SC_OK != statusCode) {
                throw new ValidationException("HTTP Error.", "Error code " + statusCode + " in response to URL '" + url);
            }
            
            return page;
    }

}
