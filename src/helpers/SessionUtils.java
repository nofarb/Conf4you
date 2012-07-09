package helpers;

import javax.servlet.http.HttpServletRequest;

import daos.UserDao;

import model.User;

public class SessionUtils {

    public static String getUserIdAttribute (HttpServletRequest request) {
        String sessionAttribute = request.getSession().getAttribute(ProjConst.SESSION_USER_ID).toString();
        return sessionAttribute != null ? sessionAttribute : null;
    }
    
    public static User getUser (HttpServletRequest request) {
        String sessionAttribute = request.getSession().getAttribute(ProjConst.SESSION_USER_ID).toString();
        Long userId = new Long(sessionAttribute);
        return sessionAttribute != null ? UserDao.getInstance().getUserById(userId) : null;
    }

    public static void clearSession (HttpServletRequest request) {
        request.getSession().invalidate();
    }
}
