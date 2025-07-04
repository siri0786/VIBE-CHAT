package com.app;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ChatServlet")
public class ChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String sender = req.getParameter("sender");
        String receiver = req.getParameter("receiver");
        String message = req.getParameter("message");

        String key1 = "chat_" + sender + "_" + receiver;
        String key2 = "chat_" + receiver + "_" + sender;

        ServletContext context = getServletContext();
        List<String> chat = (List<String>) context.getAttribute(key1);
        if (chat == null) chat = (List<String>) context.getAttribute(key2);
        if (chat == null) chat = new ArrayList<>();

        chat.add(sender + ": " + message);
        context.setAttribute(key1, chat);

        res.sendRedirect("chat.jsp?with=" + receiver);
    }
}
