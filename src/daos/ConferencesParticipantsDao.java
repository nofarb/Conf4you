package daos;

import java.util.Date;

import org.apache.log4j.Logger;
import org.hibernate.Session;

import db.HibernateUtil;
import model.Conference;
import model.ConferencesParticipants;
import model.User;

public class ConferencesParticipantsDao {

	private static ConferencesParticipantsDao instance = null;
	static Logger logger = Logger.getLogger(ConferencesParticipantsDao.class);
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
	@SuppressWarnings("deprecation")
	public void updateUserArrival(Conference conference, User user)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		try
		{
			session.beginTransaction();
			Date dNow = new Date( );
			//SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd");
			dNow.setHours(0);
			dNow.setMinutes(0);
			dNow.setSeconds(0);
			ConferencesParticipants confUsr = new ConferencesParticipants(conference, user,  dNow);
			
			
			session.save(confUsr);
			session.getTransaction().commit();
		}
		catch (RuntimeException e)
		{
			logger.error(e.getMessage(), e);
			session.getTransaction().rollback();
		}
	}
	
	public Boolean isUserArrivedToday(Conference conference, User user){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Boolean exists = false;
		try
		{
			Date dNow = new Date( );
			dNow.setHours(0);
			dNow.setMinutes(0);
			dNow.setSeconds(0);
			session.beginTransaction();
			exists = session.createQuery(
					"select cp from  ConferencesParticipants cp where cp.conferenceId=:conferenceId and cp.userId=:userId and cp.date=:date")
	                .setLong("conferenceId", conference.getConferenceId())
	                .setLong("userId",user.getUserId())
	                .setDate("date", dNow)
	                .uniqueResult() != null;
			session.getTransaction().commit();
		}
		catch (RuntimeException e)
		{
			logger.error(e.getMessage(), e);
			session.getTransaction().rollback();
		}
		return exists;
		
	}
	
}

