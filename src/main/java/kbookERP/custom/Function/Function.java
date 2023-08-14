package kbookERP.custom.Function;

import java.security.MessageDigest;

public class Function {

	public static String EncryptionSHA256(String pwd) {
		try{

			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(pwd.getBytes("UTF-8"));
			StringBuffer hexString = new StringBuffer();

			for (int i = 0; i < hash.length; i++) {
				String hex = Integer.toHexString(0xff & hash[i]);
				if(hex.length() == 1) hexString.append('0');
				hexString.append(hex);
			}

			//출력
			return hexString.toString();

		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	}

	public static String HashSHA256(String pwd) {
		try{

			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] hash = digest.digest(pwd.getBytes("UTF-8"));

			String hashResult = new String(hash);

			//출력
			return hashResult;

		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	}

	public static String Password(String id, String pwd) {
		try{

			String data = id + pwd;
            for (int i = 0; i < 5; i++){
                data = EncryptionSHA256(data);
                data = data.replaceAll(Integer.toString(i), Integer.toString(9-i));
            }

            return data;

		} catch(Exception ex){
			throw new RuntimeException(ex);
		}
	}
}