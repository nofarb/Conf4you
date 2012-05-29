package utils;

import java.util.Date;
import daos.CompanyDao;
import daos.ConferenceDao;
import daos.LocationDao;
import daos.UserDao;
import model.Company;
import model.CompanyType;
import model.Conference;
import model.Location;
import model.User;

public class MockCreation {
	
	public static void createMockUsersAndCompanies(){
 		CompanyDao.getInstance().addCompany(new Company("comp1", CompanyType.A));
 		CompanyDao.getInstance().addCompany(new Company("comp2", CompanyType.B));
 		CompanyDao.getInstance().addCompany(new Company("comp3", CompanyType.C));

		for(int i = 0 ; i < 15; i++)
		{	
			String compName;
			
			if(i%3 == 0){
				compName = "comp1";
			}else if(i%3 == 1){
				compName = "comp2";
			}else{
				compName = "comp3";
			}
			
			UserDao.getInstance().addUser(new User("userName"+i, "id"+i, CompanyDao.getInstance().getCompanyByName(compName), "name"+i, "email"+i, "num1 "+i, "num2 "+i, "pass"+i, true));
			UserDao.getInstance().getUserByUserName("userName"+i).setLastLogin(new Date());
		}	
	}
	
	public static void createMockConferencesAndLocations(){
		
		Location location = new Location("locationNameBlah", "ydaa", 30, "moo", "56464654", "54564654");
		LocationDao.getInstance().addLocation(location);
		
		for(int i = 0 ; i < 5; i++){
			ConferenceDao.getInstance().addNewConference(new Conference("conf"+i, LocationDao.getInstance().getLocationByName("locationNameBlah"), "yada", new Date(), new Date()));
		}
	}
}
