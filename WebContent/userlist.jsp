<%@ page import="java.util.*" %>
<%@ page import="com.app.RegisterServlet" %>
<%@ page import="com.app.User" %>

<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("username") == null) {
        response.sendRedirect("login.html");
        return;
    }

    String currentUser = currentSession.getAttribute("username").toString();
    List<User> userList = RegisterServlet.users;
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Chats | VibeChat</title>
  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(270deg,
        #ffb3ba, #ffe082, #ffcc80, #a5f1e9,
        #81ecec, #b388ff, #ffb3ba);
      background-size: 1200% 1200%;
      animation: animateBG 25s ease infinite;
      color: white;
    }

    @keyframes animateBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .header {
      padding: 20px;
      font-size: 1.6em;
      font-weight: bold;
      text-align: center;
      text-shadow: 0 0 10px white;
    }

    .search-box {
      display: flex;
      justify-content: center;
      margin-bottom: 10px;
    }

    .search-box input {
      width: 80%;
      padding: 12px;
      font-size: 1em;
      border-radius: 20px;
      border: none;
      background: rgba(255, 255, 255, 0.3);
      color: white;
    }

    .search-box input::placeholder {
      color: #f0f0f0;
    }

    .user-list {
      max-width: 420px;
      margin: 0 auto;
      padding: 10px 20px 40px;
    }

    .chat-user {
      background: rgba(255, 255, 255, 0.15);
      border-radius: 16px;
      padding: 16px;
      margin-bottom: 12px;
      cursor: pointer;
      box-shadow: 0 0 12px rgba(255, 255, 255, 0.3);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .chat-user:hover {
      transform: scale(1.03);
      box-shadow: 0 0 20px white;
    }

    .chat-user strong {
      font-size: 1.1em;
      display: block;
    }

    .chat-user small {
      color: #f0f0f0;
      font-size: 0.85em;
    }
  </style>
</head>
<body>

  <div class="header">Hello <%= currentUser %></div>

  <div class="search-box">
    <input type="text" placeholder="Search or start a new chat..." />
  </div>

  <div class="user-list">
    <%
      for (User u : userList) {
        if (!u.getUsername().equalsIgnoreCase(currentUser)) {
    %>
      <div class="chat-user" onclick="startChat('<%= u.getUsername() %>')">
        <strong><%= u.getUsername() %></strong>
        <small>Tap to chat</small>
      </div>
    <%
        }
      }
    %>
  </div>

  <script>
    function startChat(friend) {
      window.location.href = "chat.jsp?with=" + friend;
    }
  </script>

</body>
</html>
