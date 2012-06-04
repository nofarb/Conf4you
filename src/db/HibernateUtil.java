package db;

import org.hibernate.HibernateException;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;
import org.hibernate.service.ServiceRegistryBuilder;

/**
 * This class is responsible for obtaining and ending sessions with the database.
 * @author nofar
 *
 */
public class HibernateUtil {

    
    private static SessionFactory sessionFactory = configureSessionFactory();
    private static ServiceRegistry serviceRegistry;

    private static SessionFactory configureSessionFactory() throws HibernateException {
        Configuration configuration = new Configuration();
        configuration.configure();
        serviceRegistry = new ServiceRegistryBuilder().applySettings(configuration.getProperties()).buildServiceRegistry();        
        sessionFactory = configuration.buildSessionFactory(serviceRegistry);
        return sessionFactory;
    }

    /**
     * get a session to the database
     * @return
     */
    public static SessionFactory getSessionFactory() {
    	if(sessionFactory== null){
    		sessionFactory = configureSessionFactory();
    	}
        return sessionFactory;
    }
    
    /**
     * close the current session to the database
     */
    public static void closeSession(){
    	sessionFactory.close();
    }
    

}