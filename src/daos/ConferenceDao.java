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
	 * Get a list of all the Conferences that are stored in the database
	 */
	public List<Conference> getConferences(Filters.ConferencePreDefinedFilter filter){
		return null;
	}
	

	/**
	 * Get a list of all the Companies that match the given filter.
	 * @param filter
	 * @return
	 */
	public List<Conference> getConferences(Filters.ConferenceDatesFilter filter){
		return null;
	}
	
	
	/**
	 * Get a conference by its database key ID
	 * @param id
	 * @return
	 */
	public User getConferenceId(String id){
		return null;
		
	}
	
	

	/**
	 * Add a new Conference to the database
	 */
	public Conference addNewConference(Conference conference){
		return null;
		
	}
	


	/**
	 * Update an existing conference in the database
	 */
	public Conference updateConference(Conference conference){
		return null;
		//yada
		
	}
	
	/**
	 * Assign users to a conference
	 * @param conference
	 * @return
	 */
	public Conference assignUsersToConference(Conference conference, List<User> user){
		return null;
	}
	
	
	/**
	 * Remove users from a conference
	 * @param conference
	 * @return
	 */
	public Conference removeUsersFromConference(Conference conference, List<User> user){
		return null;
		
	}
	
	/**
	 * This function sends a predefined invitation to a conference email to users, 
	 * as long as they have never gotten such mail before about this conference
	 * @param user
	 */
	public void sendConferenceAssignmentNotificationEmailToUsers(List<User> user){
		
	}

	/**
	 * Mark user as arrived to the conference in respect to this date
	 * @param user
	 * @param conference
	 */
	public void markUserAsArrived(User user, Conference conference){
		
	}
	
	/**
	 * Get all conferences associated with a given user
	 * @param user
	 * @return
	 */
	public List<Conference> getConferencesForUser(User user){
		return null;
		
	}
}
