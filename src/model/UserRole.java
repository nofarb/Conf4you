package model;

/**
 * This class states the user types is our system
 * @author nofar
 *
 */

public enum UserRole {
	NONE(0), SPEAKER(1), RECEPTIONIST(2), CONF_MNGR(3), ADMIN(4);
	
    private int value;
    
    private UserRole(int value) {
            this.value = value;
    }
    
    public int getValue() { return value; }
};  
