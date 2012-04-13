package daos;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Query;

import servlets.UsersServices;
import system.exceptions.ItemNotFoundException;
import db.HibernateUtil;

import model.Company;
import model.CompanyType;
import model.User;

/**
 * This class is responsible of supplying services related to the User entity
 * which require database access. Singleton class.
 */
public class UserDao {

	private static UserDao instance = null;

	private UserDao() {
	}

	public static UserDao getInstance() {
		if (instance == null) {
			instance = new UserDao();
		}
		return instance;
	}

	/**
	 * Get a list of all the users that are stored in the database
	 */
	public List<User> getUsers() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<User> result = (List<User>) session.createQuery("from User").list();
		session.getTransaction().commit();
		return result;
	}

	/**
	 * Get a user by its database key ID
	 * 
	 * @param emailAddr
	 * @return
	 */
	public User getUserById(long id) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		return (User)session.load(User.class, id);
	}

	/**
	 * Get a user by its email
	 * 
	 * @param emailAddr
	 * @return
	 */
	public List<User> getUserByEmail(String emailAddr) {
		return null;
	}

	/**
	 * Add a new user to the database
	 * 
	 * @param emailAddr
	 * @return the auto generated id
	 */
	public void addUser(User user) {

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.save(user);
		session.getTransaction().commit();

	}

	/**
	 * Add a bulk of users to the database
	 * 
	 * @param emailAddr
	 * @return the auto generated id
	 */
	public void addUsers(List<User> users) {

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();

		for (User user : users) {
			session.save(user);
		}

		session.getTransaction().commit();

	}

	/**
	 * Authenticate a user on login
	 * 
	 * @param user
	 * @param password
	 * @return the authenticated user, or null otherwise.
	 * @throws ItemNotFoundException 
	 */
	public User authenticateUser(String emailAddr, String password) throws ItemNotFoundException {
		
		List<User> users = getUserByEmail(emailAddr);
		if(users.size() == 0){
			throw new ItemNotFoundException("User", emailAddr);
		}
		User user = users.get(0);
		
		if(user.getPassword().equals("")){ //TODO - operate the hash function on the password and match!
			return user;
		}
		else{
			return null;
		}

	}

	/**
	 * This function sends an email with a new password to emailAddr, if exists
	 * in the system. If the user doesn't exist nothing is being sent. In such
	 * case we do not provide an error alert for security reasons.
	 * 
	 * @param emailAddr
	 */
	public void resetForgottenPassword(String emailAddr) {

	}

	/**
	 * Changed a password of a logged in user
	 * 
	 * @param user
	 * @param newPassword
	 */
	public void changePassword(User user, String newPassword) {
				
		user.setPassword(newPassword); //TODO - hash password
		updateUser(user);
		
	}

	/**
	 * Update an existing user details in the database
	 * 
	 * @param user
	 */
	public void updateUser(User user) {

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();

		session.update(user); 

		session.getTransaction().commit();
	}
	
	/**
	 * get a list of all users that belong to a given company
	 * 
	 * @param company
	 * @return
	 */
	public List<User> getUsersInCompany(Company company) {
		return null;
	}

	/**
	 * get a list of users that belong to a given company type
	 * 
	 * @param companyType
	 * @return
	 */
	public List<User> getUsersInCompanyOfType(CompanyType companyType) {
		return null;
	}

	/**
	 * This function sends an email with a new password if the email address
	 * exist in the DB
	 * 
	 * @param emailAddr
	 */
	private void sendResetForgottenPasswordEmail(String emailAddr) {
		//TODO
	}



}
