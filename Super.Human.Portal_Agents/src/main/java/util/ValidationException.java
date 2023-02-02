package util;

/**
 * An exception that is used to return a validation error.  It will hold both an 
 * error that may be displayed to the user {@link #getPublicError()}, and an 
 * error that give more detailed information {@link #getDetailedError()}.
 * @author Joel Anderson
 *
 */
public class ValidationException extends Exception {
    
    /** Serial ID */
    private static final long serialVersionUID = 5519771317993819732L;

    /** An error message that will be prefixed to each public error */
    private static String baseError = null;
    
    /** The error which may be displayed to the users */
    private String publicError = "";
    /** A more detailed error message for debugging */
    private String detailedError = "";
    
    
    /**
     * Create a new ValidationException
     * @param publicError  the error that may be displayed to the user
     * @param detailedError  a more detailed error
     */
    public ValidationException(String publicError, String detailedError) {
        setPublicError(publicError);
        setDetailedError(detailedError);
    }
    
    
    /**
     * Create a new ValidationException
     * @param publicError  the error that may be displayed to the user
     * @param detailedError  a more detailed error
     */
    public ValidationException(String publicError, String detailedError, Throwable throwable) {
        super(throwable);
        setPublicError(publicError);
        setDetailedError(detailedError);
    }

    public ValidationException(String message) {
        this(message, message);
    }

    public ValidationException(String message, Throwable throwable) {
        this(message, message, throwable);
    }

    /**
     * Set a public error message that may be displayed to a customer.
     * @param publicError the public error message
     */
    protected void setPublicError(String publicError) {
        if (null != baseError) {
            this.publicError = baseError + publicError;
        }
        else {
            this.publicError = publicError;
        }
    }

    /**
     * Get a public error message that may be displayed to a customer.
     * @return the public error message
     */
    public String getPublicError() {
        return publicError;
    }

    /**
     * Set a detailed error message that may be displayed to a customer.
     * @param publicError the public error message
     */
    protected void setDetailedError(String detailedError) {
        this.detailedError = detailedError;
    }

    /**
     * @return the detailedError
     */
    public String getDetailedError() {
        return detailedError;
    }
    
    
    
    /* ######## Overwritten functions ######## */
    
    public String getMessage() {
        return publicError + " -- " + detailedError;
    }
    
    
    /* ######## Extra Goodies ######## */
    
    /**
     * Set a base error, which will be automatically prefixed to the public 
     * error of any new ValidationExceptions.  Set to <code>null</code> to
     * disable this feature.  You will need to include any given separators 
     * or whitespace in the given string.
     */
    public static void setBaseError(String base) {
        baseError = base;
    }

}
