package com.dacare.core.files;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class KFileNotFoundException extends RuntimeException {
    public KFileNotFoundException(String message) {
        super(message);
    }

    public KFileNotFoundException(String message, Throwable cause) {
        super(message, cause);
    }
}
