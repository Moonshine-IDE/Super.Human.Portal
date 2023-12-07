package com.moonshine.domino.security;

import lotus.domino.Document;
import lotus.domino.NotesException;
import lotus.domino.Session;

/**
 * Replace Moonshine-Domino-CRUD to fix costructor logic
 */
abstract public class SecurityInterface  {
	
	public static final String ANONYMOUS = "";
	private String remoteUser = ANONYMOUS;
	
	protected Session session = null;
	
	public SecurityInterface(Session session) {
		try {
			this.session = session;
			
			if (null == session || null == session.getAgentContext() || null == session.getAgentContext().getDocumentContext()) {
				this.remoteUser = ANONYMOUS;
			}
			else {
				Document contextDoc = session.getAgentContext().getDocumentContext();
				this.remoteUser = contextDoc.getItemValueString("Remote_User");
				if (null == remoteUser || remoteUser.trim().isEmpty()) {
					this.remoteUser = ANONYMOUS;
				}
			}
		}
		catch (NotesException ex) {
			// TODO:  log error
			this.remoteUser = ANONYMOUS;
		}
	}
	/**
	 * Indicate whether if the action associated with this instance should be allowed
	 * @return <code>true</code> if the action is allowed, <code>false</code> otherwise.
	 */
	abstract public boolean allowAction();
	
	/**
	 * Indicate whether the user is allowed access to the document.
	 * @param document the document to check
	 * @return <code>true</code> if the access is allowed, <code>false</code> otherwise.
	 */
	abstract public boolean allowAccess(Document document);
	
	/**
	 * Get the ID of the authenticated user. 
	 * By default this will return "Remote_User" from the context document.
	 * Returns "" to indicate an anonymous user.
	 *
	 * @return the ID of the authenticated user
	 */
	public String getUserID() {
		return this.remoteUser;
	}
	
	/**
	 * Cleanup any Domino API objects created by this class.
	 * Override as needed in the subclasses.
	 */
	public void cleanup() {
		// nothing to do for default implementation.
	}
}