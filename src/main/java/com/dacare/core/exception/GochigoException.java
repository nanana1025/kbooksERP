package com.dacare.core.exception;

import java.text.MessageFormat;
import java.util.Locale;
import org.springframework.context.MessageSource;

public class GochigoException extends RuntimeException {
	private static final long serialVersionUID = 1L;
	protected String message;
	protected String messageKey;
	protected Object[] messageParameters;
	protected Exception wrappedException;

	public String getMessage() {
		return this.message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getMessageKey() {
		return this.messageKey;
	}

	public void setMessageKey(String messageKey) {
		this.messageKey = messageKey;
	}

	public Object[] getMessageParameters() {
		return this.messageParameters;
	}

	public void setMessageParameters(Object[] messageParameters) {
		this.messageParameters = messageParameters;
	}

	public Throwable getWrappedException() {
		return this.wrappedException;
	}

	public void setWrappedException(Exception wrappedException) {
		this.wrappedException = wrappedException;
	}

	public GochigoException() {
		this((String) "BaseException without message", (Object[]) null, (Throwable) null);
	}

	public GochigoException(String defaultMessage) {
		this((String) defaultMessage, (Object[]) null, (Throwable) null);
	}

	public GochigoException(Throwable wrappedException) {
		this((String) "BaseException without message", (Object[]) null, wrappedException);
	}

	public GochigoException(String defaultMessage, Throwable wrappedException) {
		this((String) defaultMessage, (Object[]) null, wrappedException);
	}

	public GochigoException(String defaultMessage, Object[] messageParameters, Throwable wrappedException) {
		super(wrappedException);
		this.message = null;
		this.messageKey = null;
		this.messageParameters = null;
		this.wrappedException = null;
		String userMessage = defaultMessage;
		if (messageParameters != null) {
			userMessage = MessageFormat.format(defaultMessage, messageParameters);
		}

		this.message = userMessage;
	}

	public GochigoException(MessageSource messageSource, String messageKey) {
		this(messageSource, messageKey, (Object[]) null, (String) null, Locale.getDefault(), (Throwable) null);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Throwable wrappedException) {
		this(messageSource, messageKey, (Object[]) null, (String) null, Locale.getDefault(), wrappedException);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Locale locale, Throwable wrappedException) {
		this(messageSource, messageKey, (Object[]) null, (String) null, locale, wrappedException);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Object[] messageParameters, Locale locale,
			Throwable wrappedException) {
		this(messageSource, messageKey, messageParameters, (String) null, locale, wrappedException);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			Throwable wrappedException) {
		this(messageSource, messageKey, messageParameters, (String) null, Locale.getDefault(), wrappedException);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Throwable wrappedException) {
		this(messageSource, messageKey, messageParameters, defaultMessage, Locale.getDefault(), wrappedException);
	}

	public GochigoException(MessageSource messageSource, String messageKey, Object[] messageParameters,
			String defaultMessage, Locale locale, Throwable wrappedException) {
		super(wrappedException);
		this.message = null;
		this.messageKey = null;
		this.messageParameters = null;
		this.wrappedException = null;
		this.messageKey = messageKey;
		this.messageParameters = messageParameters;
		this.message = messageSource.getMessage(messageKey, messageParameters, defaultMessage, locale);
	}
}