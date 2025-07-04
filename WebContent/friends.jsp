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
        #ffeef0, #fffde7, #fff8e1, #e0ffff,
        #e0f7fa, #f3e5f5, #ffeef0);
      background-size: 1400% 1400%;
      animation: animateBG 28s ease infinite;
      color: #333;
    }

    @keyframes animateBG {
      0% { background-position: 0% 50%; }
      50% { background-position: 100% 50%; }
      100% { background-position: 0% 50%; }
    }

    .header {
      padding: 20px;
      font-size: 1.8em;
      font-weight: bold;
      text-align: center;
      text-shadow: 0 0 8px rgba(255,255,255,0.7);
      color: #222;
    }

    .user-list {
      max-width: 500px;
      margin: 0 auto;
      padding: 10px 20px 40px;
    }

    .chat-user {
      display: flex;
      align-items: center;
      background: rgba(255, 255, 255, 0.4);
      border-radius: 16px;
      padding: 14px;
      margin-bottom: 14px;
      cursor: pointer;
      box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .chat-user:hover {
      transform: scale(1.02);
      box-shadow: 0 0 18px rgba(255,255,255,0.5);
    }

    .chat-user img {
      width: 52px;
      height: 52px;
      border-radius: 50%;
      margin-right: 16px;
      object-fit: cover;
      border: 2px solid #fff;
      box-shadow: 0 0 5px rgba(255,255,255,0.6);
    }

    .chat-user strong {
      font-size: 1.1em;
      display: block;
      color: #222;
    }

    .chat-user small {
      color: #666;
      font-size: 0.85em;
    }
  </style>
</head>
<body>

  <div class="header">Hello, <%= currentUser %>!</div>

  <div class="user-list">
    <%
      for (User u : userList) {
        if (!u.getUsername().equalsIgnoreCase(currentUser)) {
    %>
      <div class="chat-user" onclick="startChat('<%= u.getUsername() %>')">
        <img src='<%= u.getPhoto() != null ? u.getPhoto() : "default.png" %>' alt="Photo">
        <div>
          <strong><%= u.getUsername() %></strong>
          <small>Tap to chat</small>
        </div>
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
