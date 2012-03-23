package model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


@Entity
@Table( name = "Conferences_Speakers" )
public class ConferencesSpeakers implements Serializable{

	private static final long serialVersionUID = -3401337605668111437L;
	
	private Conference conference; //TODO - should be the ID?
	private User speaker; 	//TODO - should be the ID?

	
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
		return speaker;
	}
	public void setUser(User user) {
		this.speaker = user;
	}

}
