package model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

/**
 * This purpose of the class is to store conferences and the rolls the users
 * fill in this conferences. Suppose to hold conference managers and receptionists
 * @author nofar
 *
 */
@Entity
@Table( name = "Conferences_Rolls" )
public class ConferencesRolls implements Serializable {
	
	private static final long serialVersionUID = 741942055847334800L;
	
	private User user; 	//TODO - should be the ID?
	private UserType userType; //the roll the user plays in the conference
	private Conference conference; 	//TODO - should be the ID?
	
	@Id
	@OneToOne(cascade = CascadeType.ALL)
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	
	@Id
	@OneToOne(cascade = CascadeType.ALL)
	public Conference getConference() {
		return conference;
	}
	public void setConference(Conference conference) {
		this.conference = conference;
	}
	
	@Enumerated(EnumType.STRING)
	public UserType getUserType() {
		return userType;
	}
	public void setUserType(UserType userType) {
		this.userType = userType;
	}
	
	

}


