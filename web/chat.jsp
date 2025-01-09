<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.html"); // Redirect to login if no user is logged in
        return;
    }

    // Retrieve the chat group from the URL query parameter
    String chatGroup = request.getParameter("chatGroup");
    if (chatGroup == null || chatGroup.trim().isEmpty()) {
        chatGroup = "General"; // Default value if no chat group is specified
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chat</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href='http://fonts.googleapis.com/css?family=Oswald:400,300,700' rel='stylesheet' type='text/css'>
    <script>
        // JavaScript to handle WebSocket connection and chat functionality
        document.addEventListener("DOMContentLoaded", function () {
            const username = "<%= username %>";
            const chatGroup = "<%= chatGroup %>";

            // Initialize the WebSocket connection with the username and chat group included
            let socket = new WebSocket("ws://localhost:8080/ChatConnect/chat?username=" + encodeURIComponent(username) + "&group=" + encodeURIComponent(chatGroup));

            // Function to handle incoming messages
            socket.onmessage = function (event) {
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
            socket.onopen = function (event) {
                console.log("WebSocket connection established.");
            };

            // Function to handle WebSocket errors
            socket.onerror = function (error) {
                console.error("WebSocket Error: ", error);
            };

            // Function to handle WebSocket connection closure
            socket.onclose = function (event) {
                if (event.wasClean) {
                    console.log(`Connection closed cleanly, code=${event.code}, reason=${event.reason}`);
                } else {
                    console.error('Connection died');
                }
            };

            // Add event listener to send message on form submission
            document.getElementById("message-form").addEventListener("submit", function (event) {
                event.preventDefault();  // Prevent the default form submission
                sendMessage();
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <div class="row my-4">
            <div class="col-md-3"></div>
            <div class="col-md-6 text-center">
                <h4 class="my-4 display-6" style="font-family: 'Oswald', sans-serif;">Welcome, <%= username %></h4>
                <a href="./conversations" class="btn btn-success" style="font-family: 'Oswald', sans-serif;">Conversations</a>
                <a href="./profile" class="btn btn-secondary" style="font-family: 'Oswald', sans-serif;">Profile</a>
                <a href="login.html" class="btn btn-secondary" style="font-family: 'Oswald', sans-serif;">Log out</a>
                <h4 class="my-4 display-6" style="font-family: 'Oswald', sans-serif;">Chat in Group: <span id="chat-group"><%= chatGroup %></span></h4>
                <div class="mt-5">
                    <div id="chat-window" style="border:1px solid black; height:300px; overflow:auto;"></div>
                    <form id="message-form">
                        <input class="mt-3" style="width:100%; overflow:auto;" type="text" id="message" placeholder="Type your message..."/>
                        <button class="mt-2 btn btn-success" type="submit" style="font-family: 'Oswald', sans-serif;">Send</button>
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
