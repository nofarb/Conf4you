package model;

import java.util.Date;

public class Filters {

	public enum ConferencePreDefinedFilter {

		ALL, LAST7DAYS, LAST30DAYS, LAST90DAYS
	}
	
	
	
	public class ConferenceDatesFIlter{
		
		private Date fromDate;
		private Date toDate;
		
		private ConferenceDatesFIlter(){} // private on purpose!
		
		
		public ConferenceDatesFIlter(Date fromDate, Date toDate) {
			super();
			this.fromDate = fromDate;
			this.toDate = toDate;
		}
		
		public Date getFromDate() {
			return fromDate;
		}
		public void setFromDate(Date fromDate) {
			this.fromDate = fromDate;
		}
		public Date getToDate() {
			return toDate;
		}
		public void setToDate(Date toDate) {
			this.toDate = toDate;
		}
	}
	
}
