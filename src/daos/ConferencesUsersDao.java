package daos;

import java.util.LinkedList;
import java.util.List;

import model.Conference;
import model.ConferencesUsers;
import model.User;
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
	 * Add a new user to the database
	 * 
	 * @param emailAddr
	 * @return the auto generated id
	 */
	public void addEntry(ConferencesUsers conferencesUsers) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.saveOrUpdate(conferencesUsers);
		session.getTransaction().commit();
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
		
	/*	Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select cu.user from ConferencesUsers where cu.conference=:conference and cu.userRole=:userRole")
                .setEntity("conference",  conference).setLong("userRole", userRole.getValue())
                .list();
		session.getTransaction().commit();*/
		
		return users;
	}
}
