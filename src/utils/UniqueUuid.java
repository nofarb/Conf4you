package utils;
import java.util.UUID;

public class UniqueUuid {
	
	public static String GenarateUniqueId()
	{
		String uuid = UUID.randomUUID().toString().replaceAll("-", "");
		return uuid;
	}
		
}
