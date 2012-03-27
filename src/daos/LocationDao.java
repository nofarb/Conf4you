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
		return null;
	}
	
	
	/**
	 * Get a location from the database by its database key ID
	 * @param id
	 * @return
	 */
	public Location getLocationById(String id){
		return null;
		
	}
	
	
	/**
	 * Add a new location to the database
	 * @param location
	 * @return
	 */
	public Location addLocation(Location location){
		return null;
		
	}
	
	/**
	 * Update an existing location in the database
	 * @param location
	 * @return
	 */
	public Location updateLocation(Location location){
		return null;
		
	}
}
