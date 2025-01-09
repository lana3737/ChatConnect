// Initialize the WebSocket connection
let groupName = new URLSearchParams(window.location.search).get('chatGroup');
let username = '<%= request.getAttribute("username") %>';
let socket = new WebSocket(`ws://localhost:8080/ChatConnect/chat?username=${username}&group=${groupName}`);


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