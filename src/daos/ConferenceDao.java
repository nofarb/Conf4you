package daos;

import java.util.List;

import model.Conference;
import model.Filters;
import model.User;

/**
 * This class is responsible of supplying services related to the Conference entity which require database access.
 * Singleton class.
 */
public class ConferenceDao {

	private static ConferenceDao instance = null;

	private ConferenceDao() {}

	public static ConferenceDao getInstance() {
		if (instance == null) {
			instance = new ConferenceDao();
		}
		return instance;
	}
	
	/**
	 * Get all conferences according to the selected filter
	 * @return
	 */
	public List<Conference> getConferences(Filters.ConferencePreDefinedFilter filter){
		return null;
	}
	
	/**
	 * Get all conferences between the given dates
	 * @param filter
	 * @return
	 */
	public List<Conference> getConferences(Filters.ConferenceDatesFilter filter){
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
	
	/**
	 * Get conferences associated with a given user
	 * @param user
	 * @return
	 */
	public List<Conference> getConferencesForUser(User user){
		return null;
		
	}
}
