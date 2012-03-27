package system.exceptions;

public class AuthenticationError extends Exception{

	public AuthenticationError(String errMessage) {
		super(errMessage);
	}

}
