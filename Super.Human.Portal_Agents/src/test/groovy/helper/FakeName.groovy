package helper

import java.util.Vector;

import lotus.domino.Name;
import lotus.domino.NotesException;
import lotus.domino.Session;

public class FakeName implements Name {
	private String fullName = null;
	private String commonName = null;
	private String domain = null;
	
	public FakeName(String fullName) {
		this.fullName = fullName;
		
		String[] tokens = fullName.split('/');
		if (tokens.length <= 1) {
			this.commonName = fullName;
			this.domain = "TEST";
		}
		else {
			this.commonName = tokens[0];
			this.domain = tokens[tokens.length-1];
		}
	}
	
	@Override
	public String getAbbreviated() throws NotesException {
		return commonName + '/' + domain;
	}
	
	@Override
	public String getCommon() throws NotesException {
		return commonName;
	}
	@Override
	public String getOrganization() throws NotesException {
		return domain;
	}
	@Override
	public String getCanonical() throws NotesException {
		return 'cn=' + commonName + '/o=' + domain;
	}
	
	
	/** Unimplemented methods */
	public boolean isHierarchical() {
		return false; // Unimplemented
	}
	public java.lang.String getADMD() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr821() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr822Comment1() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr822Comment2() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr822Comment3() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr822LocalPart() {
		return null; // Unimplemented
	}
	public java.lang.String getAddr822Phrase() {
		return null; // Unimplemented
	}
	public java.lang.String getCountry() {
		return null; // Unimplemented
	}
	public java.lang.String getGeneration() {
		return null; // Unimplemented
	}
	public java.lang.String getGiven() {
		return null; // Unimplemented
	}
	public java.lang.String getInitials() {
		return null; // Unimplemented
	}
	public java.lang.String getKeyword() {
		return null; // Unimplemented
	}
	public java.lang.String getLanguage() {
		return null; // Unimplemented
	}
	public java.lang.String getOrgUnit1() {
		return null; // Unimplemented
	}
	public java.lang.String getOrgUnit2() {
		return null; // Unimplemented
	}
	public java.lang.String getOrgUnit3() {
		return null; // Unimplemented
	}
	public java.lang.String getOrgUnit4() {
		return null; // Unimplemented
	}
	public java.lang.String getPRMD() {
		return null; // Unimplemented
	}
	public java.lang.String getSurname() {
		return null; // Unimplemented
	}
	public lotus.domino.Session getParent() {
		return null; // Unimplemented
	}
	public void recycle() {
		// Nothing to do
	}
	public void recycle(java.util.Vector vector) {
		// Unimplemented
	}


}