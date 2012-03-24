package model;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table( name = "Conference_Participant_Status" )
public class ConferenceParticipantStatus {

	private long id;
	private Conference conference;
	private User user;
	private boolean approved;
	private boolean notifiedByMail;
	
	
	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public long getId() {
		return id;
	}
	public void setId(long id) {
		this.id = id;
	}
	
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
	public boolean isApproved() {
		return approved;
	}
	public void setApproved(boolean approved) {
		this.approved = approved;
	}
	public boolean isNotifiedByMail() {
		return notifiedByMail;
	}
	public void setNotifiedByMail(boolean notifiedByMail) {
		this.notifiedByMail = notifiedByMail;
	}
	
	
	
	

}
