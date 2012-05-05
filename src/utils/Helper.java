package utils;

import java.util.UUID;

public class Helper {

	/**
	 * this method generates 8 random chars
	 * @return
	 */
	public static String generateRandomChars() {

		String uuid = UUID.randomUUID().toString(); // for example, uuid = 2d7428a6-b58c-4008-8575-f05549f16316
		uuid = uuid.replaceAll("-", "");
		return uuid.substring(0, 8);

	}
}
