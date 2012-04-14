package model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table( name = "CONFERENCES" )
public class Conference implements Serializable{

	private static final long serialVersionUID = -5770762179112826708L;
	
	private long conferenceID; //key
	private Location location; 
	private String name;
	private String description;
	private Date startDate;
	private Date endDate;
	
	public Conference()
	{
		
	}
	
	public Conference(Location location, String name, String description, Date startDate, Date endtDate) 
	{
		this.location = location;
		this.name = name;
		this.description = description;
		this.startDate = startDate;
		this.setEndDate(endtDate);
	}
	
	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public long getConferenceID() {
		return conferenceID;
	}
	public void setConferenceID(long conferenceID) {
		this.conferenceID = conferenceID;
	}
	
	@ManyToOne(cascade = CascadeType.ALL)
	public Location getLocation() {
		return location;
	}
	public Conference setLocation(Location location) {
		this.location = location;
		return this;
	}
	
	public String getName() {
		return name;
	}
	public Conference setName(String name) {
		this.name = name;
		return this;
	}
	public String getDescription() {
		return description;
	}
	public Conference setDescription(String description) {
		this.description = description;
		return this;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	public Date getStartDate() {
		return startDate;
	}
	public Conference setStartDate(Date startDate) {
		this.startDate = startDate;
		return this;
	}
	
	@Temporal(TemporalType.TIMESTAMP)
	public Date getEndDate() {
		return endDate;
	}

	public Conference setEndDate(Date endDate) {
		this.endDate = endDate;
		return this;
	}

	
}
