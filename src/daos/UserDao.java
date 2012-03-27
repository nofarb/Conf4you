package daos;

import java.util.List;

import model.Company;
import model.CompanyType;
import model.User;

/**
 * This class is responsible of supplying services related to the User entity which require database access.
 * Singleton class.
 */
public class UserDao {

	private static UserDao instance = null;

	private UserDao() {}

	public static UserDao getInstance() {
		if (instance == null) {
			instance = new UserDao();
		}
		return instance;
	}
	
	/**
	 * Get all users from DB
	 * @return
	 */
	public List<User> getUsers(){
		return null;
	}
	
	
	/**
	 * Get user by its database primary key
	 * @param emailAddr
	 * @return
	 */
	public User getUserById(String id){
		return null;
		
	}
	
	/**
	 * Get user by its email
	 * @param emailAddr
	 * @return
	 */
	public User getUserByEmail(String emailAddr){
		return null;
		
	}
	
	/**
	 * Add new user
	 * @param emailAddr
	 * @return
	 */
	public User addUser(User user){
		return null;
		
	}
	
	/**
	 * Authenticate user on login
	 * @param user
	 * @param password
	 * @return the authenticated user, or null otherwise.
	 */
	public User authenticateUser(String emailAddr, String password){
		return null;
		
	}
	
	/**
	 * Sends an email with a new password to emailAddr, if exists in the system. 
	 * If the user doesn't exist nothing is being sent. In such case we do not give an error alert
	 * for security reasons.
	 * @param emailAddr
	 */
	public void resetForgottenPassword(String emailAddr){
		
	}
	
	
	/**
	 * Changed password for a logged in user
	 * @param user
	 * @param newPassword
	 */
	public void changePassword(User user , String newPassword){
		
	}
	
	/**
	 * Update user details
	 * @param user
	 */
	public void changedUserDetails(User user){
		
	}

	
	/**
	 * Send email with a new password if the email address exist in the DB
	 * @param emailAddr
	 */
	private void sendResetForgottenPasswordEmail(String emailAddr){
		
	}
	
	/**
	 * get users that belong to a given company
	 * @param company
	 * @return
	 */
	public List<User> getUserInCompany(Company company){
		return null;
	}
	
	/**
	 * get users that belong to a given company type
	 * @param companyType
	 * @return
	 */
	public List<User> getUserInCompanyOfType(CompanyType companyType){
		return null;
	}
	

	
}
