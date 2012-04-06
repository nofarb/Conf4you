package system.exceptions;

public class AuthenticationError extends Exception{


	private static final long serialVersionUID = -1790649375119540423L;

	public AuthenticationError(String errMessage) {
		super(errMessage);
	}

}
