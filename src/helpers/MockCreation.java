package helpers;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

import org.apache.commons.lang3.time.DateUtils;

import daos.CompanyDao;
import daos.ConferenceDao;
import daos.ConferencesUsersDao;
import daos.LocationDao;
import daos.UserDao;
import model.Company;
import model.CompanyType;
import model.Conference;
import model.ConferencesUsers;
import model.Location;
import model.User;
import model.UserRole;

public class MockCreation {
	
	public static List<User> createMockUsersAndCompanies(){
 		CompanyDao.getInstance().addCompany(new Company("comp1", CompanyType.Hightech));
 		CompanyDao.getInstance().addCompany(new Company("comp2", CompanyType.Financial));
 		CompanyDao.getInstance().addCompany(new Company("comp3", CompanyType.Manufacturing));
 		
		List<User> newUsers = new LinkedList<User>();

		User adminUser = new User("admin", "123123123", CompanyDao.getInstance().getCompanyByName("comp1"), "admin", "admin@admin.com", "03-3333333", "03-3333331", "pass1", true);
		newUsers.add(adminUser);
		UserDao.getInstance().addUser(adminUser);
		
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
			
			User newUser = new User("userName"+i, "id"+i, CompanyDao.getInstance().getCompanyByName(compName), "name"+i, "email"+i, "num1 "+i, "num2 "+i, "pass"+i, false);
			
			newUsers.add(newUser);
			
			
			UserDao.getInstance().addUser(newUser);
			UserDao.getInstance().getUserByUserName("userName"+i).setLastLogin(new Date());
			
		}	
		return newUsers;

	}
	
	public static List<Conference> createMockConferencesAndLocations(){
		
		Location location = new Location("locationNameBlah", "ydaa", 30, "moo", "56464654", "54564654");
		LocationDao.getInstance().addLocation(location);
		List<Conference> newConfs = new LinkedList<Conference>();
		
		for(int i = 0 ; i < 5; i++){
			Date start = new Date();
			Date end = new Date();
			end = DateUtils.addDays(end, 3);
			
			Conference conf = new Conference("conf"+i, LocationDao.getInstance().getLocationByName("locationNameBlah"), "yada", start, end);
			newConfs.add(conf);
			ConferenceDao.getInstance().addNewConference(conf);
		}
		
		return newConfs;
		
	}
}
