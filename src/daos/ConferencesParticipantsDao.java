package daos;

import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import org.apache.commons.lang3.time.DateUtils;
import org.apache.log4j.Logger;
import org.hibernate.Session;

import utils.ConferenceUsersArivalHelper;

import db.HibernateUtil;
import model.Conference;
import model.ConferencesParticipants;
import model.ConferencesUsers;
import model.User;
import model.UserRole;

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
	

	@SuppressWarnings("unchecked")
	public List<ConferenceUsersArivalHelper> getAllParticipantsByConferenceAndIfArrivedToDay(Conference conference){
		
		List<ConferencesUsers> conferenceUsers = ConferencesUsersDao.getInstance().getConferenceUsersByType(conference, UserRole.PARTICIPANT);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		List<ConferencesParticipants> participants = null;
		
		try {
			Date now = new Date( );
			
			now = DateUtils.setHours(now, 0);
			now = DateUtils.setMinutes(now, 0);
			now = DateUtils.setSeconds(now, 0);
			now = DateUtils.setMilliseconds(now, 0);
			
			session.beginTransaction();
			participants = (List<ConferencesParticipants>)session.createQuery(
					"select cp from  ConferencesParticipants cp where cp.conference = :conf and cp.date = :date")
	                .setEntity("conf", conference)
	                .setDate("date", now)
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			logger.error(e.getMessage(), e);
			session.getTransaction().rollback();
		}		
	
		List<ConferenceUsersArivalHelper> cua = new LinkedList<ConferenceUsersArivalHelper>();
		
		if (conferenceUsers == null)
			return null;
		
		for (ConferencesUsers cu : conferenceUsers)
		{
			boolean contains = false;
			for (ConferencesParticipants participant : participants)
			{
				if (cu.getUser().getUserId() == participant.getUser().getUserId())
				{
					contains = true;
					continue;
				}
			}
			
			cua.add(new ConferenceUsersArivalHelper(cu, contains));
		}
		
		return cua;
	}
	
	
	/**
	 * update users arrival to the conference
	 * @param conference
	 * @param user
	 * @return
	 */
	public void updateUserArrival(Conference conference, User user)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		try
		{		
			Date now = new Date( );
			
			now = DateUtils.setHours(now, 0);
			now = DateUtils.setMinutes(now, 0);
			now = DateUtils.setSeconds(now, 0);
			now = DateUtils.setMilliseconds(now, 0);
			
			
			session.beginTransaction();
			ConferencesParticipants confUsr = new ConferencesParticipants(conference, user,  now);
						
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
			Date now = new Date( );
			
			now = DateUtils.setHours(now, 0);
			now = DateUtils.setMinutes(now, 0);
			now = DateUtils.setSeconds(now, 0);
			now = DateUtils.setMilliseconds(now, 0);
			
			session.beginTransaction();
			exists = session.createQuery(
					"select cp from  ConferencesParticipants cp where cp.conferenceId=:conferenceId and cp.userId=:userId and cp.date=:date")
	                .setLong("conferenceId", conference.getConferenceId())
	                .setLong("userId",user.getUserId())
	                .setDate("date", now)
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

