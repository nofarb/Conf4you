package helpers;

import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtils {
	
	private static final String host = "smtp.gmail.com";
	private static final String port = "587";
	private static final String user = "conf.for.you@gmail.com";
	private static final String password = "nofaralonelad";
	
	/**
	 * 
	 * @param host (like "smtp.gmail.com")
	 * @param from  (like yada@gmail.com)
	 * @param password mail password
	 * @param port like 587 for gmail
	 * @param to array of email addresses to sent to
	 * @param content
	 * @param isHtml true for html, false for text
	 */
	public static void sendEmail(EmailTemplate email, List<String> to, boolean isHtml){
		sendEmail(host, user, password, port, email, to, isHtml);
	}
	
	public static void sendEmail(EmailTemplate email, String to, boolean isHtml){
		List<String> emailsList = new LinkedList<String>();
		emailsList.add(to);
		sendEmail(host, user, password, port, email, emailsList, isHtml);
	}
	
	public static void sendEmail(String host, String user, String password, String port, EmailTemplate email, List<String> to, boolean isHtml){
		
			try {
				Properties props = System.getProperties();
				props.put("mail.smtp.starttls.enable", "true"); 
				props.put("mail.smtp.host", host);
				props.put("mail.smtp.user", user);
				props.put("mail.smtp.password", password);
				props.put("mail.smtp.port", port);
				props.put("mail.smtp.auth", "true");

				Session session = Session.getDefaultInstance(props);
				MimeMessage message = new MimeMessage(session);
				message.setFrom(new InternetAddress(email.getFrom()));

				for(String addr : to){
					
						try {
							
							InternetAddress mail = new InternetAddress(addr);
							message.addRecipient(Message.RecipientType.TO, mail);
							
						} catch (AddressException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						} catch (MessagingException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
				}

				
				message.setSubject(email.getSubject());
				
				if(isHtml){
					message.setContent(email.getBody(), "text/html");
				}else{
					message.setText(email.getBody());
				}
				
				Transport transport = session.getTransport("smtp");
				transport.connect(host, email.getFrom(), password);
				transport.sendMessage(message, message.getAllRecipients());
				transport.close();
				
			} catch (AddressException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NoSuchProviderException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (MessagingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
}
