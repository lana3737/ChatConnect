package com.chatconn.servlets;

import javax.websocket.OnMessage;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import javax.websocket.OnClose;
import javax.websocket.OnOpen;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/chat")
public class ChatEndpoint {

    // Map to store sessions by group
    private static final Map<String, Map<String, Session>> groupSessions = new ConcurrentHashMap<>();

    @OnOpen
public void onOpen(Session session) throws IOException {
    // Retrieve the username and group from the query parameter
    String queryString = session.getQueryString();
    if (queryString != null) {
        String[] params = queryString.split("&");
        String username = null;
        String groupName = null;

        for (String param : params) {
            if (param.startsWith("username=")) {
                username = param.substring("username=".length());
            } else if (param.startsWith("group=")) {
                groupName = param.substring("group=".length());
            }
        }

        if (username != null && groupName != null) {
            // Add the session to the appropriate group
            groupSessions.putIfAbsent(groupName, new ConcurrentHashMap<>());
            groupSessions.get(groupName).put(username, session);

            System.out.println("User connected: " + username + " to group " + groupName);
        } else {
            System.out.println("Error: Missing username or group in the query string.");
        }
    } else {
        System.out.println("Error: Query string is null.");
    }
}

    @OnMessage
    public void onMessage(String message, Session senderSession) throws IOException {
        String senderUsername = null;
        String senderGroup = null;

        // Find the sender's username and group based on their session
        for (Map.Entry<String, Map<String, Session>> groupEntry : groupSessions.entrySet()) {
            for (Map.Entry<String, Session> entry : groupEntry.getValue().entrySet()) {
                if (entry.getValue().equals(senderSession)) {
                    senderUsername = entry.getKey();
                    senderGroup = groupEntry.getKey();
                    break;
                }
            }
            if (senderUsername != null) {
                break;
            }
        }

        if (senderUsername != null && senderGroup != null) {
            // Format the message with the sender's username
            String formattedMessage = senderUsername + ": " + message;

            // Broadcast the message to all connected clients in the same group
            for (Session session : groupSessions.get(senderGroup).values()) {
                if (session.isOpen()) {
                    session.getBasicRemote().sendText(formattedMessage);
                }
            }
        } else {
            senderSession.getBasicRemote().sendText("Error: Could not identify sender or group.");
        }
    }

    @OnClose
    public void onClose(Session session) {
        // Find the username and group associated with this session
        String username = null;
        String groupName = null;

        for (Map.Entry<String, Map<String, Session>> groupEntry : groupSessions.entrySet()) {
            for (Map.Entry<String, Session> entry : groupEntry.getValue().entrySet()) {
                if (entry.getValue().equals(session)) {
                    username = entry.getKey();
                    groupName = groupEntry.getKey();
                    break;
                }
            }
            if (username != null && groupName != null) {
                break;
            }
        }

        // Remove the session from the group if the username was found
        if (username != null && groupName != null) {
            groupSessions.get(groupName).remove(username);
            System.out.println("User disconnected: " + username + " from group " + groupName);

            // Remove the group if empty
            if (groupSessions.get(groupName).isEmpty()) {
                groupSessions.remove(groupName);
            }
        }
    }
}
