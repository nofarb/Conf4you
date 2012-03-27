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
	 * Get all locations from DB
	 * @return
	 */
	public List<Location> getLocations(){
		return null;
	}
	
	
	/**
	 * Get Location by its database primary key
	 * @param id
	 * @return
	 */
	public Location getLocationById(String id){
		return null;
		
	}
	
	
	/**
	 * Add new Location
	 * @param location
	 * @return
	 */
	public Location addLocation(Location location){
		return null;
		
	}
	
	/**
	 * update a Location
	 * @param location
	 * @return
	 */
	public Location updateLocation(Location location){
		return null;
		
	}
}
