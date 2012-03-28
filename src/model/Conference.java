package model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table( name = "CONFERENCES" )
public class Conference implements Serializable{

	private int conferenceID; //key
	private Location location; 
	private String name;
	private String description;
	private Date startDate;
	private Date endtDate;
	
	Conference() {}  //not public on purpose!
	
	public Conference(Location location, String name, String description,
			Date startDate, Date endtDate) {
		this.location = location;
		this.name = name;
		this.description = description;
		this.startDate = startDate;
		this.endtDate = endtDate;
	}
	
	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public int getConferenceID() {
		return conferenceID;
	}
	public void setConferenceID(int conferenceID) {
		this.conferenceID = conferenceID;
	}
	
	@OneToOne(cascade = CascadeType.ALL)
	public Location getLocation() {
		return location;
	}
	public void setLocation(Location location) {
		this.location = location;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	public Date getEndtDate() {
		return endtDate;
	}
	public void setEndtDate(Date endtDate) {
		this.endtDate = endtDate;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	
	
	
}
