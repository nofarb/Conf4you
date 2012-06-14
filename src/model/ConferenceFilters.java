package model;

import java.util.Date;

/**
 * Container class for filter classes
 * @author nofar
 *
 */
public class ConferenceFilters {

	/**
	 * Class that supplies predefined conference filters
	 * @author nofar
	 *
	 */
	public enum ConferencePreDefinedFilter {

		ALL, LAST7DAYS, LAST30DAYS, LAST90DAYS
	}
	
	public enum ConferenceTimeFilter {

		ALL, CURRENT, PAST, FUTURE
	}
	
	
	/**
	 * Filter between start date and end date of a conference
	 * @author nofar
	 *
	 */
	public class ConferenceDatesFilter{
		
		private Date fromDate;
		private Date toDate;
		
		public ConferenceDatesFilter(Date fromDate, Date toDate) {
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
