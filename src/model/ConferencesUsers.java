package model;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.sun.istack.internal.Nullable;


/**
 * This class is an entity class that represents the connection between conferences and their participants in 
 * in the database (i.e. which user is associated to which conference).
 * This class holds no logic, only getters, setter and constructors.
 * This class also contains instructions to hibernate that define how the entity should be saved to the database.
 */
@Entity
@Table( name = "Conferences_Users" )
public class ConferencesUsers implements Serializable{

	private static final long serialVersionUID = -3401337605668111437L;
	
	private Conference conference;
	private User user; 
	private int userRole;
	private UserAttendanceStatus attendanceStatus; //APPROVED, DECLINED, MAYBE
	private boolean notifiedByMail;  //means user invited to conference
	private String uniqueIdForEmailNotification;
	
	ConferencesUsers() {}  //not public on purpose!
	
	public ConferencesUsers(Conference conf, User user, int userRole) 
	{
		this.conference = conf;
		this.user = user;
		this.userRole = userRole;
		this.attendanceStatus = null;
		this.notifiedByMail = false;
	}
	
	public ConferencesUsers(Conference conf, User user, int userRole, UserAttendanceStatus attendanceStatus, boolean notifiedByMail) 
	{
		this.conference = conf;
		this.user = user;
		this.userRole = userRole;
		this.attendanceStatus = attendanceStatus;
		this.notifiedByMail = notifiedByMail;
	}
	
	@Id
	@ManyToOne(cascade = CascadeType.ALL)
	public Conference getConference() {
		return conference;
	}
	public void setConference(Conference conference) {
		this.conference = conference;
	}
	
	@Id
	@ManyToOne(cascade = CascadeType.ALL)
	public User getUser() {
		return user;
	}
	
	public void setUser(User user) {
		this.user = user;
	}
	
	@Enumerated(EnumType.STRING)
	public int getUserRole() {
		return userRole;
	}
	public void setUserRole(int userRole) {
		this.userRole = userRole;
	}

	@Nullable
	@Basic
	@Column(columnDefinition = "BIT", length = 1)
	public boolean isNotifiedByMail() {
		return notifiedByMail;
	}
	public void setNotifiedByMail(boolean notifiedByMail) {
		this.notifiedByMail = notifiedByMail;
	}
	
	public UserAttendanceStatus getAttendanceStatus() {
		return attendanceStatus;
	}
	public ConferencesUsers setAttendanceStatus(UserAttendanceStatus attendanceStatus) {
		this.attendanceStatus = attendanceStatus;
		return this;
	}
	
	@Nullable
	public String getUniqueIdForEmailNotification() {
		return uniqueIdForEmailNotification;
	}

	public void setUniqueIdForEmailNotification(
			String uniqueIdForEmailNotification) {
		this.uniqueIdForEmailNotification = uniqueIdForEmailNotification;
	}
}
