package daos;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import org.hibernate.Session;
import system.exceptions.ItemNotFoundException;
import utils.OwaspAuthentication;
import db.HibernateUtil;
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
	 * Get a user by its database key 
	 * 
	 * @param emailAddr
	 * @return
	 * @throws ItemNotFoundException 
	 */
	public User getUserByUserName(String userName) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		User user = (User)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"from User where userName=:userName")
                .setString("userName",userName)
                .uniqueResult();
		session.getTransaction().commit();
		return user;
	}

	/**
	 * Get a user by its email
	 * 
	 * @param emailAddr
	 * @return
	 */
	public List<User> getUserByEmail(String emailAddr) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"from User where email=:mail")
                .setString("mail",emailAddr)
                .list();
		session.getTransaction().commit();
		return users;
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
		session.merge(user);
		session.getTransaction().commit();
	}

	/**
	 * Add a bulk of users to the database
	 * 
	 * @param emailAddr
	 * @return the auto generated id
	 */
	public void addUsers(List<User> users) {

		for (User user : users) {
			addUser(user);
		}
	}

	/**
	 * Authenticate a user on login
	 * 
	 * @param user
	 * @param password
	 * @return the authenticated user, or null otherwise.
	 * @throws ItemNotFoundException 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	public User authenticateUser(String userName, String password) throws ItemNotFoundException, NoSuchAlgorithmException, SQLException
	{
	
		 if (userName==null||password==null)
		 {
			 // TIME RESISTANT ATTACK
			 // Computation time is equal to the time needed by a legitimate user
			 userName="";
			 password="";
			 return null; 
		}
		 
		 User user = getUserByUserName(userName);
		 
		 if (user == null)
		 {
			 return null;
		 }
		 
		 if (OwaspAuthentication.authenticate(userName, password, user))
		 {
			return user;
		 }
		 
		return null;
	}

	/**
	 * This function sends an email with a new password to emailAddr, if exists
	 * in the system. If the user doesn't exist nothing is being sent. In such
	 * case we do not provide an error alert for security reasons.
	 * 
	 * @param emailAddr
	 */
	public void resetForgottenPassword(String emailAddr) {
			//TODO
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
	public List<User> getUsersInCompany(long companyId) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select u from User u left outer join u.company where u.company.companyID=:companyId")
                .setLong("companyId",  companyId)
                .list();
		session.getTransaction().commit();
		return users;
	}
	
	/**
	 * get a list of all users that belong to a given company
	 * 
	 * @param company
	 * @return
	 */
	public List<User> getUsersInCompany(String companyName) {

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select u from User u left outer join u.company where u.company.name=:companyName")
                .setString("companyName",  companyName)
                .list();
		session.getTransaction().commit();
		return users;
	}

	/**
	 * get a list of users that belong to a given company type
	 * 
	 * @param companyType
	 * @return
	 */
	public List<User> getUsersInCompanyOfType(CompanyType companyType) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select u from User u left outer join u.company where u.company.companyType=:companyType")
                .setString("companyType",  companyType.toString())
                .list();
		session.getTransaction().commit();
		return users;
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
	
	private boolean isDeleteAllowed(String userName)
	{
		//TODO implement
		
		return true;
		
	}
	

}
