package kbookERP.core.util.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

//암호화 해시 함수(cryptographic hash function)
public class ShaEncrypt extends Exception{
	private static final long serialVersionUID = 5982340624670901943L;

	private final static Logger log = LoggerFactory.getLogger(ShaEncrypt.class);

	private static volatile ShaEncrypt INSTANCE;

	public ShaEncrypt() {
		super("ShaEncrypt");
	}

	public ShaEncrypt getInstance(){
		if(INSTANCE==null){
		synchronized(ShaEncrypt.class){
			if(INSTANCE==null)
				INSTANCE=new ShaEncrypt();
			}
		}
		return INSTANCE;
	}

	//암호화
	public static String encode(String message, String salt) throws NoSuchAlgorithmException {
		return encode(message, "SHA-512", salt);
	}

	//암호화
	//algorithm
	//MD5(비권장 length:64), SHA(비권장 length:64), SHA-1(비권장 length:64),
	//SHA-256(권장 length:64), SHA-384(권장 length:128), SHA-512(권장 length:128)
	public static String encode(String message, String algorithm, String salt)  throws NoSuchAlgorithmException  {
		MessageDigest md;
		String out = "";

		if(algorithm == null || algorithm.equals("")){
			algorithm = "SHA-512";
		}

		try {
			md= MessageDigest.getInstance(algorithm);

			md.update(salt.getBytes());
			byte[] mb = md.digest(message.getBytes());

			for (int i = 0; i < mb.length; i++) {
				byte temp = mb[i];
				String s = Integer.toHexString(temp);
                while (s.length() < 2) {
                	s = "0" + s;
                }
                s = s.substring(s.length() - 2);
                out += s;
			}
		} catch (NoSuchAlgorithmException e) {
			log.debug("ERROR: " + e.getMessage());
		}

		return out;
	}

	public static void main(String[] ar) throws Exception {
	}
}