package model;

import java.io.Serializable;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * This class is an entity class that represent connection between a conference and the status of an invitee 
 * in the database (e.g. whether a user approved coming to a conference)
 * This class holds no logic, only getters, setter and constructors.
 * This class also contains instructions to hibernate that define how the entity should be saved to the database.
 */
@Entity
@Table( name = "Conference_Participant_Status" )
public class ConferenceParticipantStatus implements Serializable {

	private static final long serialVersionUID = 1698853675165927660L;
	
	private long id;
	private Conference conference;
	private User user;
	private UserAttendanceStatus attendanceStatus;
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
	public boolean isNotifiedByMail() {
		return notifiedByMail;
	}
	public void setNotifiedByMail(boolean notifiedByMail) {
		this.notifiedByMail = notifiedByMail;
	}
	public UserAttendanceStatus getAttendanceStatus() {
		return attendanceStatus;
	}
	public void setAttendanceStatus(UserAttendanceStatus attendanceStatus) {
		this.attendanceStatus = attendanceStatus;
	}
}
