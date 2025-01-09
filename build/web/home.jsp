<%@ page import="java.util.List" %>
<%@page import="com.chatconn.servlets.HomeServlet"%> 
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Home</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
        <link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'>
        <script>
            // Initialize the WebSocket connection with username included
            let username = '<%= request.getAttribute("username") %>'; // Replace this with the actual username from your session or request
            let socket = new WebSocket("ws://localhost:8080/ChatConnect/chat?username=" + encodeURIComponent(username));

            // Function to handle incoming messages
            socket.onmessage = function(event) {
                let chatWindow = document.getElementById("chat-window");
                let message = document.createElement("div");
                message.textContent = event.data;
                chatWindow.appendChild(message);
                chatWindow.scrollTop = chatWindow.scrollHeight;  // Scroll to the bottom to show the latest message
            };

            // Function to send a message
            function sendMessage() {
                let messageInput = document.getElementById("message");
                let message = messageInput.value;
                if (message.trim() !== "") {  // Check if message is not empty
                    socket.send(message);
                    messageInput.value = "";
                }
            }

            // Function to handle WebSocket connection opening
            socket.onopen = function(event) {
                console.log("WebSocket connection established.");
            };

            // Function to handle WebSocket errors
            socket.onerror = function(error) {
                console.error("WebSocket Error: ", error);
            };

            // Function to handle WebSocket connection closure
            socket.onclose = function(event) {
                if (event.wasClean) {
                    console.log(`Connection closed cleanly, code=${event.code}, reason=${event.reason}`);
                } else {
                    console.error('Connection died');
                }
            };
        </script>
    </head>
    <body>
        <div class="container">
            <div class="row my-4">
                <div class="col-md-3"></div>

                <div class="col-md-6 text-center">
                    <h4 class="my-4 display-6" style="font-family: 'Oswald', sans-serif;">Welcome, <%= request.getAttribute("username")%></h4>
                    <a href="./home" style="font-family: 'Oswald', sans-serif;" class="btn btn-success">Conversations</a>
                    <a href="./profile" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Profile</a>
                    <a href="login.html" style="font-family: 'Oswald', sans-serif;" class="btn btn-secondary">Log out</a>

                    <div class="mt-5">
                    <h4 class="display-6" style="font-family: 'Oswald', sans-serif;">Available Chat Groups</h4>
                    <ul class="list-group" style="font-family: 'Oswald', sans-serif;">
                        <%
                            List<String> chatGroups = (List<String>) request.getAttribute("chatGroups");
                            if (chatGroups != null && !chatGroups.isEmpty()) {
                                for (String group : chatGroups) {
                        %>
                        <li class="list-group-item">
                            <a href="chat.jsp?chatGroup=<%= group%>"> <%= group%> </a>
                        </li>
                        <%
                                }
                            } else {
                        %>
                        <li class="list-group-item display-6" style="font-family: 'Oswald', sans-serif;">No groups found.</li>
                        <%
                            }
                        %>
                    </ul>
                    <form action="conversations" method="post" class="mt-4">
                        <div class="form-group">
                            <input type="text" name="groupName" class="form-control" placeholder="Enter new group name">
                        </div>
                        <button type="submit" class="btn btn-primary">Create Group</button>
                    </form>
                </div>
                </div>

                <div class="col-md-3"></div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
</html>
