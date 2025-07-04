<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.util.*" %>
<%@ page import="com.app.RegisterServlet" %>
<%@ page import="com.app.User" %>

<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("username") == null || request.getParameter("with") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String sender = session1.getAttribute("username").toString();
    String receiver = request.getParameter("with");
    User receiverUser = null;
    for (User u : RegisterServlet.users) {
        if (u.getUsername().equals(receiver)) {
            receiverUser = u;
            break;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Chat with <%= receiver %> | VibeChat</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      height: 100vh;
      display: flex;
      flex-direction: column;
      background: linear-gradient(270deg,
        #ffeef0, #fffde7, #fff8e1, #e0ffff,
        #e0f7fa, #f3e5f5, #ffeef0);
      background-size: 1200% 1200%;
      animation: animateBG 28s ease infinite;
    }

    @keyframes animateBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .chat-header {
      background: rgba(255, 255, 255, 0.7);
      padding: 14px 18px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .chat-header .left {
      display: flex;
      align-items: center;
    }

    .chat-header img {
      width: 48px;
      height: 48px;
      border-radius: 50%;
      object-fit: cover;
      margin-right: 12px;
      border: 2px solid white;
      box-shadow: 0 0 6px rgba(0,0,0,0.2);
    }

    .chat-header .name {
      font-weight: bold;
      font-size: 1.1em;
      color: #333;
    }

    .chat-header .buttons button {
      background: rgba(255, 255, 255, 0.7);
      border: none;
      border-radius: 50%;
      width: 38px;
      height: 38px;
      margin-left: 8px;
      font-size: 16px;
      cursor: pointer;
      box-shadow: 0 0 6px white;
    }

    .chat-box {
      flex: 1;
      padding: 20px;
      overflow-y: auto;
    }

    .message {
      margin: 10px 0;
      padding: 12px 18px;
      border-radius: 18px;
      max-width: 60%;
      word-wrap: break-word;
      display: inline-block;
      clear: both;
    }

    .sent {
      background-color: #fca311;
      color: white;
      float: right;
      text-align: right;
    }

    .received {
      background-color: white;
      color: #333;
      float: left;
      text-align: left;
    }

    .chat-input {
      background: rgba(255, 255, 255, 0.6);
      padding: 10px 15px;
      display: flex;
      align-items: center;
      border-top: 1px solid #ccc;
    }

    .chat-input input {
      flex: 1;
      padding: 12px;
      border: none;
      border-radius: 20px;
      font-size: 1em;
      background: white;
      margin-right: 10px;
    }

    .chat-input button {
      background: linear-gradient(to right, #fca311, #ff4e50);
      border: none;
      border-radius: 20px;
      color: white;
      padding: 10px 20px;
      font-weight: bold;
      cursor: pointer;
    }
  </style>
</head>
<body>

  <div class="chat-header">
    <div class="left">
      <img src="<%= receiverUser != null && receiverUser.getPhoto() != null ? receiverUser.getPhoto() : "default.png" %>" alt="Profile">
      <div class="name">Chat with <%= receiver %></div>
    </div>
    <div class="buttons">
      <button title="Call">📞</button>
      <button title="Video Call">📹</button>
    </div>
  </div>

  <div class="chat-box" id="chatBox"></div>

  <div class="chat-input">
    <input type="text" id="messageInput" placeholder="Type a message..." />
    <button onclick="sendMessage()">Send</button>
  </div>

  <script>
    const sender = "<%= sender %>";
    const receiver = "<%= receiver %>";
    const chatBox = document.getElementById("chatBox");
    const ws = new WebSocket("ws://localhost:8082/VibeChat/chat/" + sender);

    ws.onmessage = (event) => {
      const msg = JSON.parse(event.data);
      const div = document.createElement("div");
      div.classList.add("message");
      div.classList.add(msg.from === sender ? "sent" : "received");
      div.textContent = msg.text;
      chatBox.appendChild(div);
      chatBox.scrollTop = chatBox.scrollHeight;
    };

    function sendMessage() {
      const input = document.getElementById("messageInput");
      const text = input.value.trim();
      if (text === "") return;

      const msg = { from: sender, to: receiver, text: text };
      ws.send(JSON.stringify(msg));
      input.value = "";

      // Also show message instantly on sender side
      const div = document.createElement("div");
      div.classList.add("message", "sent");
      div.textContent = text;
      chatBox.appendChild(div);
      chatBox.scrollTop = chatBox.scrollHeight;
    }
  </script>

</body>
</html>
