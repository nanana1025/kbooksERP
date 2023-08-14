package com.dacare.core.mngm;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.AbstractJsonpResponseBodyAdvice;

@ControllerAdvice
public class JsonAdviceController extends AbstractJsonpResponseBodyAdvice {
    public JsonAdviceController() {
        super("callback");
    }
}
