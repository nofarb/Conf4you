package daos;

import java.util.Dictionary;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import model.Conference;
import model.ConferencesUsers;
import model.User;
import model.UserAttendanceStatus;
import model.UserRole;

import org.hibernate.Session;

import db.HibernateUtil;

public class ConferencesUsersDao {

	private static ConferencesUsersDao instance = null;

	private ConferencesUsersDao() {
	}

	public static ConferencesUsersDao getInstance() {
		if (instance == null) {
			instance = new ConferencesUsersDao();
		}
		return instance;
	}

	/**
	 * Assign users to a conference
	 * @param conference
	 * @return
	 */
	
	public void assignUserToConference(ConferencesUsers cu){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.saveOrUpdate(cu);
		session.getTransaction().commit();
	}
	
	public List<ConferencesUsers> getAllConferenceUsers(Conference conference){	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<ConferencesUsers> result = (List<ConferencesUsers>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select cu from  ConferencesUsers cu where cu.conference = :conf")
                .setEntity("conf", conference)
                .list();
		session.getTransaction().commit();
		
		return result;
	}
	
	public List<ConferencesUsers> getConderenceUsersByType(Conference conference, UserRole ur ){	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<ConferencesUsers> result = (List<ConferencesUsers>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select cu from  ConferencesUsers cu where cu.conference = :conf and cu.userRole = :userRole")
                .setEntity("conf", conference)
                .setInteger("userRole", ur.getValue())
                .list();
		session.getTransaction().commit();
		
		return result;
	}
	
	public ConferencesUsers getConferenceUser(Conference conference, User user ){	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		ConferencesUsers result = (ConferencesUsers)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select cu from  ConferencesUsers cu where cu.conference = :conf and cu.user = :user")
                .setEntity("conf", conference)
                .setEntity("user", user)
                .uniqueResult();
		session.getTransaction().commit();
		
		return result;
	}
	
	public List<User> getUsersThatNotBelongsToConference(Conference conference){	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<User> result = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select u from User u where u.admin != 1 and not exists (select 1 from ConferencesUsers cu where cu.user = u and cu.conference = :conf)")
                .setEntity("conf", conference)
                .list();
		session.getTransaction().commit();
		
		return result;
	}
	
	
	public void removeUserFromConference(Conference conference, User user){
		
		ConferencesUsers conferenceUser = getConferenceUser(conference, user);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.delete(conferenceUser);
		session.getTransaction().commit();
	}
	
	/**
	 * update users attendance approval to the conference
	 * @param conference
	 * @param user
	 * @return
	 */
	public void updateUserAttendanceApproval(Conference conference, User user, UserAttendanceStatus status){
		ConferencesUsers confPart = getConferenceUser(conference, user);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(confPart.setAttendanceStatus(status));
		session.getTransaction().commit();
		
	}
	/**
	 * This function sends a predefined invitation to a conference email to users, 
	 * as long as they have never gotten such mail before about this conference
	 * @param user
	 */
	public void sendConferenceAssignmentNotificationEmailToUsers(Conference conference, User user){
		
	}
	
	public UserRole getUserHighestRole(User user){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<ConferencesUsers> results = (List<ConferencesUsers>)session.createQuery(
				"select cu from  ConferencesUsers cu where cu.user = :user")
                .setEntity("user", user)
                .list();
		session.getTransaction().commit();
		
		UserRole ur = UserRole.NONE;
		
		if (results.size() == 0)
			return ur;
		
		for (ConferencesUsers cu : results)
		{
			if (cu.getUserRole() < ur.getValue())
			{
				ur =  UserRole.resolveUserRole(cu.getUserRole());
			}
		}
		
		return ur;
	}
	
	public List<User> getUsersForRoleInCompanyInConference(Conference conference, UserRole userRole) {
		
		/**
		 * this is mock data, the code in the comment below might be working, was unable to test it
		 */
		List<User> users = new LinkedList<User>();

		switch (userRole) {
		case PARTICIPANT:
			users.add(UserDao.getInstance().getUserById(1L));
			break;
		case CONF_MNGR:
			users.add(UserDao.getInstance().getUserById(2L));
			break;
		case RECEPTIONIST:
			users.add(UserDao.getInstance().getUserById(3L));
			break;
		case SPEAKER:
			users.add(UserDao.getInstance().getUserById(4L));
			break;

		default:
			users.add(UserDao.getInstance().getUserById(5L));
	    } 
		
		return users;
	}
}
