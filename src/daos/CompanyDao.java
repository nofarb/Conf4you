package daos;

import java.util.List;

import org.hibernate.Query;
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
	public List<Company> getAllCompanies() {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		@SuppressWarnings("unchecked")
		List<Company> result = (List<Company>) session.createQuery("select comp from Company comp where comp.active = '1'").list();
		session.getTransaction().commit();
		return result;
	}

	/**
	 * Get a list of all the Companies of type <Company Type> that are stored in the database
	 */
	public List<Company> getCompaniesOfType(CompanyType companyType) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		
		@SuppressWarnings("unchecked")
		List<Company> companies = (List<Company>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
				"from Company where companyType=:companyType")
                .setString("companyType",  companyType.toString())
                .list();
		session.getTransaction().commit();
		return companies;
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
		if (isCompanyNameExists(company.getName()))
		{
			return null;
		}
		else
		{
			Session session = HibernateUtil.getSessionFactory().getCurrentSession();
			session.beginTransaction();
			session.merge(company);
			session.getTransaction().commit();
			return company;
		}
	}
	/*public Company addCompany(Company company)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		try
		{
			session.beginTransaction();
			session.merge(company);			
			session.getTransaction().commit();
			return company;
		}
		catch (org.hibernate.exception.ConstraintViolationException  e)
		{
			e.printStackTrace();
			return null;
		}
		
	}*/
	
	/**
	 * Update an existing company in the database
	 */
	public Company updateCompany(Company company) {
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(company); 
		session.getTransaction().commit();
		return company;
	}
	
	/**
	 * Get a company by its database key ID
	 * @param id
	 * @return
	 */
	public Company getCompanyById(long id){

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Company comp = (Company)session.createQuery(
				"select comp from  Company comp where comp.companyID = :compId")
                .setLong("compId", id)
                .uniqueResult();
		session.getTransaction().commit();
		return comp;
	}

	/**
	 * Check if company in the database
	 */
	public Boolean isCompanyNameExists(String name)
	{
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Boolean exists = session.createQuery(
				"select comp from  Company comp where comp.name = :name")
                .setString("name", name)
                .uniqueResult() != null;
		session.getTransaction().commit();
		return exists;
	}

	/**
	 * Delete (set active=false) an existing company
	 */
	public void deleteCompany(String name)
	{
		Company companyToDelete = getCompanyByName(name);
		
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		session.update(companyToDelete.setActive(false));
		session.getTransaction().commit();
	}
	
	/**
	 * Get a company
	 */
	public Company getCompanyByName(String name){
		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();
		Company comp = (Company)session.createQuery(
				"select comp from  Company comp where comp.name = :name")
                .setString("name", name)
                .uniqueResult();
		session.getTransaction().commit();
		return comp;
	}


	public List<Company> getCompanyListByName(String name) {
			Session session = HibernateUtil.getSessionFactory().getCurrentSession();
			session.beginTransaction();
			@SuppressWarnings("unchecked")
			List<Company> compenies = (List<Company>)HibernateUtil.getSessionFactory().getCurrentSession().createQuery(
					"from Company where name=:name")
					.setString("name",name)
					.list();
			session.getTransaction().commit();
			return compenies;
}
	
}
