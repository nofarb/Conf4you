package utils;

import model.ConferencesUsers;

public class ConferenceUsersArivalHelper {

	private ConferencesUsers cu;
	private boolean isArived;
	
	public ConferenceUsersArivalHelper(ConferencesUsers cu, boolean isArived)
	{
		this.cu = cu;
		this.isArived = isArived;
	}
	
	public ConferencesUsers getConferenceUser() {
		return cu;
	}
	
	public void setConferenceUser(ConferencesUsers cu) {
		this.cu = cu;
	}
	
	public boolean isArived() {
		return isArived;
	}
	public void setArived(boolean isArived) {
		this.isArived = isArived;
	}
	
	
}
