package daos;

import java.util.List;

import model.Company;
import model.Conference;
import model.ConferenceFilters;
import model.Location;
import org.hibernate.Session;
import db.HibernateUtil;

/**
 * This class is responsible of supplying services related to the Location entity which require database access.
 * Singleton class.
 */
public class LocationDao {

	private static LocationDao instance = null;

	private LocationDao() {}

	public static LocationDao getInstance() {
		if (instance == null) {
			instance = new LocationDao();
		}
		return instance;
	}
	
	/**
	 * Get a list of all the locations that are stored in the database
	 */
	public List<Location> getLocations(){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		List<Location> result = null;
		
		try {
			session.beginTransaction();
			result = (List<Location>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery("select loc from Location loc where loc.active = '1'").list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}
	
	
	/**
	 * Get a location from the database by its database key ID
	 * @param id
	 * @return
	 */
	public Location getLocationById(String id){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Location result = null;
		
		try {
			session.beginTransaction();
			result = (Location)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"select location from  Location location where location.locationId = :id")
	                .setString("id", id)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}
	
	public Location getLocationByName(String name){	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Location result = null;
		
		try {
			session.beginTransaction();
			result = (Location)session.createQuery(
					"select loc from  Location loc where loc.name = :name")
	                .setString("name", name)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}
	
	
	
	/**
	 * Add a new location to the database
	 * @param location
	 * @return
	 */
	public Location addLocation(Location location){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();	
		try {
			session.beginTransaction();
			session.merge(location);
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return location;	
	}
	
	/**
	 * Update an existing location in the database
	 * @param location
	 * @return
	 */
	public Location updateLocation(Location location){
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();	
		try {
			session.beginTransaction();
			session.update(location); 
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return location;	
	}
	
	
	public Boolean isLocationNameExists(String name)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Boolean exists = null;
		try {
			session.beginTransaction();
			exists = session.createQuery(
					"select loc from  Location loc where loc.name = :name")
	                .setString("name", name)
	                .uniqueResult() != null;
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		
		return exists;
	}
	
	public void deleteLocation(String name)
	{	
		Location locationToDelete = getLocationByName(name);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Boolean exists = null;
		try {
			session.beginTransaction();
			session.update(locationToDelete.setActive(false));
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
	}
}
