package utils;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import model.Company;
import model.CompanyType;
import model.Conference;
import model.Location;
import model.User;

public class MockCreation {

	private static List<User> users = new LinkedList<User>();
	private static List<Conference> conferences = new LinkedList<Conference>();
	
	
	public static List<User> createMockUsers(){
		
 		Company comp = new Company("yada", CompanyType.C);

		for(int i = 0 ; i < 5; i++){
			User user = new User("userName"+i, "id"+i, comp, "name"+i, "email"+i, "num1 "+i, "num2 "+i, "pass"+i, false);
			user.setLastLogin(new Date());
			users.add(user);
		}
		return users;
		
	}
	
	public static List<Conference> createMockConferences(){
		
		Location location = new Location("locationNameBlah", "ydaa", 30, "moo", "56464654", "54564654");
		
		for(int i = 0 ; i < 5; i++){
			Conference conference = new Conference(location, "conf"+i, "yada", new Date(), new Date());
			conferences.add(conference);
		}
		return conferences;
		
	}
}
