package daos;

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
		session.merge(conferencesUsers);
		session.getTransaction().commit();
	}
	
	
	public List<User> getUsersForRoleInCompanyInConference(Conference conference, User user, UserRole userRole) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<User> users = (List<User>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select cu.user from ConferencesUsers where cu.conference=:conference and cu.userRole=:userRole")
                .setEntity("conference",  conference).setLong("userRole", userRole.getValue())
                .list();
		session.getTransaction().commit();
		return users;
	}
}
