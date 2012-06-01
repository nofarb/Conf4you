package daos;

import java.util.Date;

import org.hibernate.Session;

import db.HibernateUtil;
import model.Conference;
import model.ConferencesParticipants;
import model.User;

public class ConferencesParticipantsDao {

	private static ConferencesParticipantsDao instance = null;

	private ConferencesParticipantsDao() {}

	public static ConferencesParticipantsDao getInstance() {
		if (instance == null) {
			instance = new ConferencesParticipantsDao();
		}
		return instance;
	}
	

	/**
	 * update users arrival to the conference
	 * @param conference
	 * @param user
	 * @return
	 */
	public void updateUserArrival(Conference conference, User user){
		ConferencesParticipants confUsr = new ConferencesParticipants(conference, user,  new Date());
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(confUsr);
		session.getTransaction().commit();
	}	
}

