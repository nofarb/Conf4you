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
	//private static List<Company> companies = new LinkedList<Company>();
	
	public static List<User> createMockUsers(){
		
 		Company comp1 = new Company("comp1", CompanyType.A);
 		Company comp2 = new Company("comp2", CompanyType.B);
 		Company comp3 = new Company("comp3", CompanyType.C);


		for(int i = 0 ; i < 15; i++)
		{	
			Company comp;
			
			if(i%3 == 0){
				comp = comp1;
			}else if(i%3 == 1){
				comp = comp2;
			}else{
				comp = comp3;
			}
			
			User user = new User("userName"+i, "id"+i, comp, "name"+i, "email"+i, "num1 "+i, "num2 "+i, "pass"+i, false);
			user.setLastLogin(new Date());
			users.add(user);
		}
		return users;
		
	}
	
	public static List<Conference> createMockConferences(){
		
		Location location = new Location("locationNameBlah", "ydaa", 30, "moo", "56464654", "54564654");
		
		for(int i = 0 ; i < 5; i++){
			Conference conference = new Conference("conf"+i, location, "yada", new Date(), new Date());
			conferences.add(conference);
		}
		return conferences;
	}

	/*public static List<Company> createMockCompanies(){
		
		CompanyType type = CompanyType.A;

		for(int i = 0 ; i < 5; i++)
		{
			if(i%3 == 0)
			{
				type = CompanyType.A;
			}else if(i%3 == 1)
			{
				type = CompanyType.B;
			}else
			{
				type = CompanyType.C;
			}
			
			Company comp = new Company("comp" + i + i, type);
			companies.add(comp);
		}
		
		return companies;
	}*/

}
