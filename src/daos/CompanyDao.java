package daos;

import java.util.List;

import org.hibernate.Session;
import db.HibernateUtil;
import model.Company;
import model.CompanyType;

/**
 * This class is responsible of supplying services related to the Company entity which require database access.
 * Singleton class.
 */
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
	 * Get a list of all the Companies that are stored in the database
	 */
	@SuppressWarnings("unchecked")
	public List<Company> getAllCompanies() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		List<Company> result = null;
		
		try {
			session.beginTransaction();
			result = (List<Company>) session.createQuery("select comp from Company comp where comp.active = '1'").list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}

	/**
	 * Get a list of all the Companies of type <Company Type> that are stored in the database
	 */
	@SuppressWarnings("unchecked")
	public List<Company> getCompaniesOfType(CompanyType companyType) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		List<Company> results = null;
		
		try {
			session.beginTransaction();
			results = (List<Company>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"from Company where companyType=:companyType")
	                .setString("companyType",  companyType.toString())
	                .list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return results;
	}

	/**
	 * Add a new Company to the database
	 */
	public void addCompany(List<Company> companies) {

		 for (Company comp:companies)
		 {
			 if(!isCompanyNameExists(comp.getName()))
			 {
				 addCompany(comp);
			 }
		 }

	}
	
	public Company addCompany(Company company)
	{
		Company comp = getCompanyByName(company.getName());
		if (comp != null)
		{
			//company already exists
			return company;
		}
		else
		{
			Session session = HibernateUtil.getSessionFactory().getCurrentSession();
			try {
				session.beginTransaction();
				session.merge(company);
				session.getTransaction().commit();
			}
			catch (Exception e) {
				session.getTransaction().rollback();
			}
		}
		return company;
	}
	
	/**
	 * Update an existing company in the database
	 */
	public Company updateCompany(Company company) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		try {
			session.beginTransaction();
			session.update(company); 
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
		return company;
	}
	
	/**
	 * Get a company by its database key ID
	 * @param id
	 * @return
	 */
	public Company getCompanyById(long id){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Company result = null;
		
		try {
			session.beginTransaction();
			
			result = (Company)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"select comp from  Company comp where comp.companyID = :compId")
	                .setLong("compId",id)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}

	/**
	 * Check if company in the database
	 */
	public Boolean isCompanyNameExists(String name)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Boolean result = null;
		
		try {
			session.beginTransaction();
			result = session.createQuery(
					"select comp from  Company comp where comp.name = :name")
	                .setString("name", name)
	                .uniqueResult() != null;
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}

	/**
	 * Delete (set active=false) an existing company
	 */
	public void deleteCompany(String name)
	{	
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		
		try {
			session.beginTransaction();
			Company companyToDelete = getCompanyByName(name);
			session.update(companyToDelete.setActive(false));
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}
	}
	
	/**
	 * Get a company
	 */
	public Company getCompanyByName(String name){
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		Company result = null;
		
		try {
			session.beginTransaction();
			result = (Company)session.createQuery(
					"select comp from  Company comp where comp.name = :name")
	                .setString("name", name)
	                .uniqueResult();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return result;
	}


	@SuppressWarnings("unchecked")
	public List<Company> getCompanyListByName(String name) {
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		List<Company> compenies = null;
		
		try {
			session.beginTransaction();
			compenies = (List<Company>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"from Company where name=:name")
					.setString("name",name)
					.list();
			session.getTransaction().commit();
		}
		catch (Exception e) {
			session.getTransaction().rollback();
		}

		return compenies;
	}
	
}
