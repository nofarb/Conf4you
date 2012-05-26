package model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table( name = "Company" )
/**
 * This class is an entity class that represent the company object in the database.
 * This class holds no logic, only getters, setter and constructors.
 */
public class Company implements Serializable {
	

	private static final long serialVersionUID = -4809404779999217296L;
	
	private long companyID;
	private CompanyType companyType;
	private String name;
	private boolean active;
	
	public Company() {
		
	} 
	
	public Company(String name, CompanyType companyType) {
		this.companyType = companyType;
		this.name = name;
		this.active = true;
	}

	@Id
	public String getName() {
		return name;
	}
	
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public long getCompanyID() {
		return companyID;
	}
	
	public void setCompanyID(long companyID) {
		this.companyID = companyID;
	}
	
	
	@Enumerated(EnumType.STRING)
	public CompanyType getCompanyType() {
		return companyType;
	}
	
	public Company setCompanyType(CompanyType companyType) {
		this.companyType = companyType;
		return this;
	}
	

	
	public Company setName(String name) {
		this.name = name;
		return this;
	}

	public boolean isActive() {
		return active;
	}

	public Company setActive(boolean active) {
		this.active = active;
		return this;
	}
}
