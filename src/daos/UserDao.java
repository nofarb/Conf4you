package daos;

import helpers.EmailContent;
import helpers.EmailTemplate;
import helpers.EmailUtils;
import helpers.OwaspAuthentication;
import helpers.UniqueUuid;

import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;

import system.exceptions.ItemCanNotBeDeleted;
import system.exceptions.ItemNotFoundException;
import db.HibernateUtil;
import model.CompanyType;
import model.User;

/**
 * This class is responsible of supplying services related to the User entity
 * which require database access. Singleton class.
 */
public class UserDao {

	private static UserDao instance = null;
	static Logger logger = Logger.getLogger(UserDao.class);
	
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
	@SuppressWarnings("unchecked")
	public List<User> getUsers() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>) session.createQuery("from User").list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;
	}
	

	@SuppressWarnings("unchecked")
	public List<User> getActiveUsers() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)session.createQuery(
					"from User where active=:active")
	                .setBoolean("active",true).list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<User> getNonActiveUsers() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)session.createQuery(
					"from User where active=:active")
	                .setBoolean("active",false).list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public List<User> getAdmineUsers() {		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)session.createQuery(
					"from User where admin=:admin")
	                .setBoolean("admin",true).list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
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
		
		User result = null;
		try {
			session.beginTransaction();
			result = (User)session.createQuery(
					"from User where userId=:userId")
	                .setLong("userId",id)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}

	/**
	 * Get a user by its database key 
	 * 
	 * @param emailAddr
	 * @return
	 * @throws ItemNotFoundException 
	 */
	@SuppressWarnings("unchecked")
	public User getUserByUserName(String userName) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		User result = null;
		try {
			session.beginTransaction();
			result = (User)session.createQuery(
					"from User where userName=:userName")
	                .setString("userName",userName)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}

	/**
	 * Get a user by its email
	 * 
	 * @param emailAddr
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> getUserByEmail(String emailAddr) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)session.createQuery(
					"from User where email=:mail")
	                .setString("mail",emailAddr)
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}

	/**
	 * Add a new user to the database
	 * 
	 * @param emailAddr
	 * @return the auto generated id
	 */
	public void addUser(User user) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();

		try {
			session.beginTransaction();
			session.merge(user);
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
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
	 * @throws Exception 
	 */
	public void resetForgottenPassword(User user) throws Exception {
		String newPassword = UniqueUuid.GenarateUniqueId().substring(0, 6);
		changePassword(user, newPassword);
		
		sendResetForgottenPasswordEmail(user, newPassword);
	}

	/**
	 * This function sends an email with a new password if the email address
	 * exist in the DB
	 * 
	 * @param emailAddr
	 * @throws Exception 
	 */
	private void sendResetForgottenPasswordEmail(User user, String newPassword) throws Exception {
		EmailTemplate email = new EmailTemplate(EmailContent.ForgotPasswordEmail.from, EmailContent.ForgotPasswordEmail.subject, EmailContent.ForgotPasswordEmail.body);
		email.setSubject(email.getSubject());
		email.setBody(String.format(email.getBody(), 
				user.getName(), 
				newPassword));
		
		try
		{
			EmailUtils.sendEmail(email, user.getEmail(), true);
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			throw new Exception("Failed to send email, please try later");
		}
	}
	
	
	/**
	 * Changed a password of a logged in user
	 * 
	 * @param user
	 * @param newPassword
	 */
	public void changePassword(User user, String newPassword) {
				
		user.changePassword(newPassword);
		updateUser(user);
	}

	/**
	 * Update an existing user details in the database
	 * 
	 * @param user
	 */
	public void updateUser(User user) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();

		try {
			session.beginTransaction();
			session.update(user); 
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
	}
	
	
	/**
	 * get a list of all users that belong to a given company
	 * 
	 * @param company
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> getUsersInCompany(long companyId) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"select u from User u left outer join u.company where u.company.companyID=:companyId")
	                .setLong("companyId",  companyId)
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}
	
	/**
	 * get a list of all users that belong to a given company
	 * 
	 * @param company
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> getUsersInCompany(String companyName) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"select u from User u left outer join u.company where u.company.name=:companyName")
	                .setString("companyName",  companyName)
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}

	/**
	 * get a list of users that belong to a given company type
	 * 
	 * @param companyType
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<User> getUsersInCompanyOfType(CompanyType companyType) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<User> result = null;
		try {
			session.beginTransaction();
			result = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"select u from User u left outer join u.company where u.company.companyType=:companyType")
	                .setString("companyType",  companyType.toString())
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return result;	
	}

	private boolean isDeleteAllowed(Long userId)
	{
		//TODO implement
		
		return true;
		
	}
	
	public void deleteUser(Long userId) throws ItemCanNotBeDeleted
	{
		//TDOD - improve logic
		if(isDeleteAllowed(userId)){
			User user = getUserById(userId);
			if(user != null){
				user.setActive(false);
				updateUser(user);
			}
		}else{
			throw new ItemCanNotBeDeleted("Can't delete user name");
		}
	}
	
	
	
	

}
