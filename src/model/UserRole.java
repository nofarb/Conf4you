package model;

/**
 * This class states the user types is our system
 * @author nofar
 *
 */

public enum UserRole {
	NONE(0), PARTICIPANT(1), SPEAKER(2), RECEPTIONIST(3), CONF_MNGR(4), ADMIN(5);
	
    private int value;
    
    private UserRole(int value) {
            this.value = value;
    }
    
    public int getValue() { return value; }
};  
