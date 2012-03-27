package model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import model.UserType;


@Entity
@Table( name = "Users" )
public abstract class User implements Serializable{

	private int userID;
	private int countryID;
	private Company company; //TODO - should be the ID? 
	private String name;
	private String email;
	private String phone1;
	private String phone2;
	private String password; //may be null/empty , will be kept hashed
	private UserType userType;
	
	
	
	private User() {} //not public on purpose!
	
	public User(int countryID, Company company, String name, String email,
			String phone1, String phone2, String password, UserType userType) {
		this.countryID = countryID;
		this.company = company;
		this.name = name;
		this.email = email;
		this.phone1 = phone1;
		this.phone2 = phone2;
		this.password = password;
		this.userType = userType;
	}



	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public int getUserID() {
		return userID;
	}
	public void setUserID(int userID) {
		this.userID = userID;
	}
	public int getStateID() {
		return countryID;
	}
	public void setStateID(int stateID) {
		this.countryID = stateID;
	}
	
	@OneToOne(cascade = CascadeType.ALL)
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
	
	@Enumerated(EnumType.STRING)
	public UserType getUserType() {
		return userType;
	}
	public void setUserType(UserType userType) {
		this.userType = userType;
	}
	
	
}
