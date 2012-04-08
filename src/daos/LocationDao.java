package daos;

import java.util.List;

import model.Location;
import model.User;

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
		return (List<Location>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select Loc from Location Loc)
                .list();
	}
	
	
	/**
	 * Get a location from the database by its database key ID
	 * @param id
	 * @return
	 */
	public Location getLocationById(String id){
		
		return (Location)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"select Loc from  Location Loc where Loc.locationId = :locId")
                .setLong("locId", id)
                .uniqueResult();
		
	}
	
	
	/**
	 * Add a new location to the database
	 * @param location
	 * @return
	 */
	public Location addLocation(Location location){
	Location loc = new Location(location.getName(), location.getAddress(), location.getMaxCapacity(), location.getContactName(), location.getPhone1(), location.getPhone2());
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.save(loc);
		session.getTransaction().commit();

		return loc;
		
	}
	
	/**
	 * Update an existing location in the database
	 * @param location
	 * @return
	 */
	public Location updateLocation(Location location){
		
		Location loc = getLocationById(location.getLocationId());
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(loc.setName(location.getName())
				.setMaxCapacity(location.getMaxCapacity())
				.setContactName(location.getContactName())
				.setPhone1(location.getPhone1())
				.setPhone2(location.getPhone2()));
		session.getTransaction().commit();

		return loc;
		
	}
}
