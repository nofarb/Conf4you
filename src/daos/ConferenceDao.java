package daos;

import java.util.List;

import model.Conference;
import model.Filters;
import model.User;

public class ConferenceDao {

	
	/**
	 * Get all conferences from DB according to the selected filter
	 * @return
	 */
	public List<User> getConferences(Filters.ConferenceFilter filter){
		return null;
	}
	
	
	/**
	 * Get conference by its database primary key
	 * @param id
	 * @return
	 */
	public User getConferenceId(String id){
		return null;
		
	}
	
	
	/**
	 * add new conference
	 * @param conference
	 * @return
	 */
	public Conference addNewConference(Conference conference){
		return null;
		
	}
	

	/**
	 * update conference
	 * @param conference
	 * @return
	 */
	public Conference updateConference(Conference conference){
		return null;
		//yada
		
	}
	
	/**
	 * assign users to a conference
	 * @param conference
	 * @return
	 */
	public Conference assignUsersToConference(Conference conference, List<User> user){
		return null;
	}
	
	
	/**
	 * remove users from a conference
	 * @param conference
	 * @return
	 */
	public Conference removeUsersFromConference(Conference conference, List<User> user){
		return null;
		
	}
	
	/**
	 * Send predefined email to users that never got such mail for this conference
	 * @param user
	 */
	public void sendConferenceAssignmentNotificationEmailToUsers(List<User> user){
		
	}

	/**
	 * Mark user as arrived to the conference on today's date+
	 * @param user
	 * @param conference
	 */
	public void markUserAsArrived(User user, Conference conference){
		
	}
}
