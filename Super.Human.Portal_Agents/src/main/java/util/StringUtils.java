package util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.Writer;

public class StringUtils  
{
    
    
    /**
     * Return all of the data from the InputStream as a String.
     * I got this code from:   http://www.kodejava.org/examples/266.html 
     * @param is  the InputStream
     * @return  the text contained in the InputStream
     * @throws IOException if an error occurs while reading the stream
     */
    public static String convertStreamToString(InputStream is)
                         throws IOException {
        /*
        * To convert the InputStream to String we use the
        * Reader.read(char[] buffer) method. We iterate until the
        * Reader return -1 which means there's no more data to
        * read. We use the StringWriter class to produce the string.
        */
        if (is != null) {
            Writer writer = new StringWriter();
             
            char[] buffer = new char[1024];
            try {
                Reader reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
                int n;
                while ((n = reader.read(buffer)) != -1) {
                    writer.write(buffer, 0, n);
                }
            } finally {
                is.close();
            }
            return writer.toString();
        } 
        else {       
            return "";
        }
    }
}