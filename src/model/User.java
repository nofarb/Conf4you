package model;

import helpers.OwaspAuthentication;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.GenericGenerator;

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

	private long userId;
	private String userName; 
	private String pasportID;
	private Company company; 
	private String name;
	private String email;
	private String phone1;
	private String phone2;
	private String password; //may be null/empty , will be kept hashed
	private boolean admin;
	private Date lastLogin;
	private boolean active; 
	private String salt;
	
	public User() {}


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
		this.admin = isAdmin;
		this.active = true;
		changePassword(password);
	}

	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public long getUserId() {
		return userId;
	}


	public void setUserId(long userId) {
		this.userId = userId;
	}

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
	
	public void changePassword(String password)
	{
		try
		{
			byte[] bSalt = OwaspAuthentication.getBsalt();
			this.password = OwaspAuthentication.getUserPassword(this.userName, password, bSalt);
			this.salt = OwaspAuthentication.byteToBase64(bSalt);
		}
		catch (Exception e)
		{
			//TODO: OwaspAuthentication failed
		}
	}

	@Basic
	@Column(columnDefinition = "BIT", length = 1)
	public boolean isAdmin() {
		return admin;
	}

	public void setAdmin(boolean isAdmin) {
		this.admin = isAdmin;
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

	@Basic
	@Column(columnDefinition = "BIT", length = 1)
	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
	
	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}


}
