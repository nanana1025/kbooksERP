package com.dacare.spring.config;

import java.security.Principal;
import java.util.Map;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import com.dacare.util.vo.StompPrincipal;

class CustomHandshakeHandler extends DefaultHandshakeHandler {
    // Custom class for storing principal
    @Override
    protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler, Map<String, Object> attributes) {
        return new StompPrincipal(request.getRemoteAddress().getHostString());
    }
}