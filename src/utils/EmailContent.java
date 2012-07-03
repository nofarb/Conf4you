package utils;

public class EmailContent {

	public class AssignToConferenceEmail {
		
		public static final String from = "conf.for.you@gmail.com";
		public static final String subject = "Dear %s"; 
		public static final String  body = "Dear %s, <div>You have been invited to participate a conference %s</div></br><div>The conference will start on %s till %s.</div></br><div>Please confirm your participation here:</div><span><a href=\"%s\">Link</a><span>"; 
	}
	
	public class ForgotPasswordEmail {
		
		public static final String from = "conf.for.you@gmail.com";
		public static final String subject = "Reset password email"; 
		public static final String  body = "Dear %s, <div>Your new password is: %s</div>"; 
	}
}
