package system.exceptions;

public class ItemNotFoundException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -544204074794502614L;

	public ItemNotFoundException(String errMessage) {
		super(errMessage);
	}
}
