package daos;

import java.util.List;

import org.hibernate.Session;

import db.HibernateUtil;

import model.Company;
import model.CompanyType;


public class CompanyDao {

	private static CompanyDao instance = null;

	private CompanyDao() {}

	public static CompanyDao getInstance() {
		if (instance == null) {
			instance = new CompanyDao();
		}
		return instance;
	}

	/**
	 * get all companies
	 * 
	 * @return
	 */
	private List<Company> getAllCompanies() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		List<Company> result = (List<Company>) session.createQuery("from COMPANIES").list();
		session.getTransaction().commit();
		return result;
	}

	/**
	 * Get all companies of a given type
	 * 
	 * @param companyType
	 * @return
	 */
	public List<Company> getCompaniesOfType(CompanyType companyType) {
		return null;
	}

	/**
	 * Add company to DB
	 * 
	 * @param company
	 * @return
	 */
	public Company addCompany(Company company) {

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();

		session.save(company);

		session.getTransaction().commit();

		return company;
	}

	/**
	 * update company details
	 * 
	 * @param company
	 * @return
	 */
	public Company updateCompany(Company company) {
		return null;
	}

}
