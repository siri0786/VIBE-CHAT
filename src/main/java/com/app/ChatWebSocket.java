package com.app;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@ServerEndpoint("/chat/{username}")
public class ChatWebSocket {
    private static final Map<String, Session> userSessions = Collections.synchronizedMap(new HashMap<>());

    @OnOpen
    public void onOpen(@PathParam("username") String username, Session session) {
        userSessions.put(username, session);
    }

    @OnMessage
    public void onMessage(String message, Session session, @PathParam("username") String sender) throws IOException {
        String to = extractReceiver(message);
        if (to != null && userSessions.containsKey(to)) {
            Session receiverSession = userSessions.get(to);
            if (receiverSession.isOpen()) {
                receiverSession.getBasicRemote().sendText(message);
            }
        }
    }

    @OnClose
    public void onClose(@PathParam("username") String username) {
        userSessions.remove(username);
    }

    private String extractReceiver(String json) {
        try {
            int toIndex = json.indexOf("\"to\"");
            if (toIndex == -1) return null;
            int start = json.indexOf('"', toIndex + 5) + 1;
            int end = json.indexOf('"', start);
            return json.substring(start, end);
        } catch (Exception e) {
            return null;
        }
    }
}
