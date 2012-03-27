package model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;


@Entity
@Table( name = "Conferences_Users" )
public class ConferencesUsers implements Serializable{

	private static final long serialVersionUID = -3401337605668111437L;
	
	private Conference conference;
	private User user; 

	
	@Id
	@OneToOne(cascade = CascadeType.ALL)
	public Conference getConference() {
		return conference;
	}
	public void setConference(Conference conference) {
		this.conference = conference;
	}
	
	@Id
	@OneToOne(cascade = CascadeType.ALL)
	public User getUser() {
		return user;
	}
	
	public void setUser(User user) {
		this.user = user;
	}

}
