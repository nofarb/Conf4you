package model;

import java.util.HashMap;
import java.util.Map;

/**
 * This class states the user types is our system
 * @author Alon
 *
 */

public enum UserRole {
	NONE(0), PARTICIPANT(1), SPEAKER(2), RECEPTIONIST(3), CONF_MNGR(4), ADMIN(5);
	
    private int value;
    
    private UserRole(int value) {
            this.value = value;
    }
    
    public int getValue() { return value; }
    
    public static UserRole resolveUserRole(int intValue)
    {
    	switch (intValue) {
		case 0:
			return NONE; 
		case 1:
			return PARTICIPANT; 
		case 2:
			return SPEAKER; 
		case 3:
			return RECEPTIONIST; 
		case 4:
			return CONF_MNGR;
		case 5:
			return ADMIN;
		default:
			return NONE; 
		}
    }
    
    public static String resolveUserRoleToFriendlyName(int intValue)
    {
    	switch (intValue) {
		case 0:
			return "None"; 
		case 1:
			return "Participant"; 
		case 2:
			return "Speaker"; 
		case 3:
			return "Receptionist"; 
		case 4:
			return "Conference Manager";
		case 5:
			return "Admin";
		default:
			return "None";
		}
    }
    
	/**
	 * Get the roles that user can see (scope)
	 * @param conference
	 * @return
	 */
	public static Map<Integer, String> getAllRoles(){
		
		Map<Integer,String> map = new HashMap<Integer,String>();
		map.put(1, "Participant");
		map.put(2, "Speaker");
		map.put(3, "Receptionist");
		map.put(4, "Conference Manager");

		return map;
	}
};  
