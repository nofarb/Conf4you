package utils;

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
	public static void sendEmail(String host, String from, String password, String port, String subject, List<String> to, String content, boolean isHtml){
	


			try {
				Properties props = System.getProperties();
				props.put("mail.smtp.starttls.enable", "true"); 
				props.put("mail.smtp.host", host);
				props.put("mail.smtp.user", from);
				props.put("mail.smtp.password", password);
				props.put("mail.smtp.port", port);
				props.put("mail.smtp.auth", "true");

				Session session = Session.getDefaultInstance(props);
				MimeMessage message = new MimeMessage(session);
				message.setFrom(new InternetAddress(from));

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

				
				message.setSubject(subject);
				
				if(isHtml){
					message.setContent(content, "text/html");
				}else{
					message.setText(content);
				}
				
				Transport transport = session.getTransport("smtp");
				transport.connect(host, from, password);
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
