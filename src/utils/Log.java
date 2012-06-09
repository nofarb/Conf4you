package utils;

import org.apache.log4j.Logger;

public class Log {
	
	public static void error(String origin, Object message)
	{
		Logger logger = Logger.getLogger(origin);
		logger.error(message);
	}
	
	public static void warn(String origin, Object message)
	{
		Logger logger = Logger.getLogger(origin);
		logger.warn(message);	
	}
	
	public static void info(String origin, Object message)
	{
		Logger logger = Logger.getLogger(origin);
		logger.info(message);
	}
}
