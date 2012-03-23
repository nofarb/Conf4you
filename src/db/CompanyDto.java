package db;

import java.util.List;

import model.Company;
import model.CompanyType;

import org.hibernate.Session;

public class CompanyDto {

	private void addCompany(String name, CompanyType companyType) {

		Company company = new Company(name, companyType);

		Session session = HibernateUtil.getSessionFactory().getCurrentSession();
		session.beginTransaction();

		session.save(company);

		session.getTransaction().commit();
	}
	
	private List<Company> getCompanies() {
        Session session = HibernateUtil.getSessionFactory().getCurrentSession();
        session.beginTransaction();
        List<Company> result = (List<Company>)session.createQuery("from COMPANIES").list();
        session.getTransaction().commit();
        return result;
    }

}
