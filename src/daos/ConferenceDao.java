package daos;

import java.util.Calendar;
import java.util.List;
import java.util.Date;
import org.hibernate.Session;
import db.HibernateUtil;
import model.Conference;
import model.ConferenceFilters;
import model.Location;


/**
 * This class is responsible of supplying services related to the Conference entity which require database access.
 * Singleton class.
 */
public class ConferenceDao {

	private static ConferenceDao instance = null;

	private ConferenceDao() {}

	public static ConferenceDao getInstance() {
		if (instance == null) {
			instance = new ConferenceDao();
		}
		return instance;
	}
	
	/**
	 * Get a list of all the Conferences that are stored in the database
	 */
	@SuppressWarnings("unchecked")
	public List<Conference> getConferences(ConferenceFilters.ConferencePreDefinedFilter filter){
		
		Calendar filterDate = Calendar.getInstance();
		Date dateToFilter = new Date();		
		filterDate.setTime(dateToFilter);
		
		switch(filter)
		{
			case ALL:
				filterDate.add(Calendar.YEAR, -40);
				break;
			case LAST7DAYS:
				filterDate.add(Calendar.DATE, -7);
				break;
			case LAST30DAYS:
				filterDate.add(Calendar.DATE, -30);
				break;
			case LAST90DAYS:
				filterDate.add(Calendar.DATE, -90);
				break;				
		}
		
		dateToFilter.setTime(filterDate.getTimeInMillis());
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<Conference> result = (List<Conference>) session.createQuery("select conf from Conference conf where conf.startDate >= :filterDate and conf.active = '1'")
				.setDate("filterDate", dateToFilter)
				.list();
		session.getTransaction().commit();
		return result;
	}
	
	/**
	 * Get a conference by its database key ID
	 * 
	 * @param emailAddr
	 * @return
	 */
	public Conference getConferenceById(long id) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		Conference conf = (Conference)session.createQuery(
				"from Conference where conferenceId=:conferenceId")
                .setLong("conferenceId",id)
                .uniqueResult();
		session.getTransaction().commit();
		return conf;
		
	}
	

	/**
	 * Get a list of all the Conference that match the given filter.
	 * @param filter
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<Conference> getConferences(ConferenceFilters.ConferenceDatesFilter filter){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<Conference> result = (List<Conference>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select conf from Conference conf where conf.startDate >= :startDate and conf.endtDate <= :endDate and conf.active = '1'")
                .setDate("startDate", filter.getFromDate())
                .setDate("endDate", filter.getToDate())
                .list();
		session.getTransaction().commit();
		return result;
	}
	
	
	/**
	 * Get a conference by its database name
	 * @param id
	 * @return
	 */
	public Conference getConferenceByName(String name){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Conference conf = (Conference)session.createQuery(
				"select conf from  Conference conf where conf.name = :name")
                .setString("name", name)
                .uniqueResult();
		session.getTransaction().commit();
		return conf;
	}
	
	public Boolean isConferenceNameExists(String name){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Boolean exists = session.createQuery(
				"select conf from  Conference conf where conf.name = :name")
                .setString("name", name)
                .uniqueResult() != null;
		session.getTransaction().commit();
		return exists;
	}
	
	public void deleteConference(String name){
		
		Conference conferenceToDelete = getConferenceByName(name);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(conferenceToDelete.setActive(false));
		session.getTransaction().commit();
	}
	
	public void addNewConference(List<Conference> conferences){
		 for (Conference conf:conferences)
		 {
			 addNewConference(conf);
		 }
	}
	

	/**
	 * Add a new Conference to the database
	 */
	public Conference addNewConference(Conference conference){
		
		Conference conf = getConferenceByName(conference.getName());
		if (conf != null)
		{
			//conference already exists
			return conf;
		}
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.merge(conference);
		session.getTransaction().commit();
		
		return conference;
	}

	/**
	 * Update an existing conference in the database
	 */
	public Conference updateConference(Conference conference){
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.merge(conference);
		session.getTransaction().commit();
		
		return conference;
	
	}
	

	/**
	 * assign location to a conference
	 * @param conference
	 * @return
	 */
	public Conference assignLocationToConference(Conference conference, Location location){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Conference conf = getConferenceByName(conference.getName());
		session.update(conf.setLocation(location));
		session.getTransaction().commit();
		
		return conf;
	}
}
