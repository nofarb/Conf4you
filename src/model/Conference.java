package model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.GeneratedValue;

import org.hibernate.annotations.GenericGenerator;

@Entity
@Table(name = "CONFERENCES")
public class Conference implements Serializable {

	private static final long serialVersionUID = -5770762179112826708L;

	private long conferenceId; //auto incremented key
	private Location location;
	private String name;
	private String description;
	private Date startDate;
	private Date endDate;
	private boolean active;
	

	public Conference() {

	}

	public Conference(String name, Location location, String description,
			Date startDate, Date endtDate) {
		this.name = name;
		this.location = location;
		this.description = description;
		this.startDate = startDate;
		this.setEndDate(endtDate);
		this.active = true;
	}
	

	@Id
	@GeneratedValue(generator="increment")
	@GenericGenerator(name="increment", strategy = "increment")
	public long getConferenceId() {
		return conferenceId;
	}
	
	public void setConferenceId(long conferenceId) {
		this.conferenceId = conferenceId;
	}

	public String getName() {
		return name;
	}

	public Conference setName(String name) {
		this.name = name;
		return this;
	}
	
	@ManyToOne(cascade = CascadeType.ALL)
	public Location getLocation() {
		return location;
	}

	public Conference setLocation(Location location) {
		this.location = location;
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

	public boolean isActive() {
		return active;
	}

	public Conference setActive(boolean active) {
		this.active = active;
		return this;
	}

}
