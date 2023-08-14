package com.dacare.core.files;

public class FileStorageException extends RuntimeException {
	private static final long serialVersionUID = -125975846851124475L;

	public FileStorageException(String message) {
        super(message);
    }

    public FileStorageException(String message, Throwable cause) {
        super(message, cause);
    }
}
