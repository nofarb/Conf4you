package model;

import java.io.Serializable;
import java.util.Date;
import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import model.Company;

/**
 * This class is an entity class that represent the User object in the database.
 * This class holds no logic, only getters, setter and constructors.
 * This class also contains instructions to hibernate that define how the entity should be saved to the database.
 */
@Entity
@Table( name = "Users" )
public class User implements Serializable{

	private static final long serialVersionUID = -3550174731709532722L;

	private String userName; 
	private String pasportID;
	private Company company; 
	private String name;
	private String email;
	private String phone1;
	private String phone2;
	private String password; //may be null/empty , will be kept hashed
	private boolean isAdmin;
	private Date lastLogin; 
	
	User() {} //not public on purpose!


	public User(String userName, String pasportID, Company company,
			String name, String email, String phone1, String phone2,
			String password, boolean isAdmin) {
		this.userName = userName;
		this.pasportID = pasportID;
		this.company = company;
		this.name = name;
		this.email = email;
		this.phone1 = phone1;
		this.phone2 = phone2;
		this.password = password;
		this.isAdmin = isAdmin;
	}


	@Id
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	@ManyToOne(cascade = CascadeType.ALL)
	public Company getCompany() {
		return company;
	}
	
	public void setCompany(Company company) {
		this.company = company;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getPhone1() {
		return phone1;
	}
	public void setPhone1(String phone1) {
		this.phone1 = phone1;
	}
	
	public String getPhone2() {
		return phone2;
	}
	public void setPhone2(String phone2) {
		this.phone2 = phone2;
	}
	
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isAdmin() {
		return isAdmin;
	}

	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}

	@Temporal(TemporalType.TIMESTAMP) 
	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}


	public String getPasportID() {
		return pasportID;
	}


	public void setPasportID(String pasportID) {
		this.pasportID = pasportID;
	}
	
}
