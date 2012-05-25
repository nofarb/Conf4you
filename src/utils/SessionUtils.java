package utils;

import javax.servlet.http.HttpServletRequest;

import daos.UserDao;

import model.User;

public class SessionUtils {

    public static String getUserName (HttpServletRequest request) {
        Object sessionAttribute = request.getSession().getAttribute(ProjConst.SESSION_USER_NAME);
        return sessionAttribute != null ? sessionAttribute.toString() : null;
    }
    
    public static User getUser (HttpServletRequest request) {
        Object sessionAttribute = request.getSession().getAttribute(ProjConst.SESSION_USER_NAME);
        return sessionAttribute != null ? UserDao.getInstance().getUserByUserName(sessionAttribute.toString()) : null;
    }

    public static void clearSession (HttpServletRequest request) {
        request.getSession().invalidate();
    }
}
