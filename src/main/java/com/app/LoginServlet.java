package com.app;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pwd = request.getParameter("password");

        for (User u : RegisterServlet.users) {
            if (u.getUsername().equalsIgnoreCase(uname) && u.getPassword().equals(pwd)) {
                HttpSession session = request.getSession();
                session.setAttribute("username", uname);
                response.sendRedirect("friends.jsp");
                return;
            }
        }

        response.getWriter().println("<h3>Invalid credentials. Try again.</h3>");
    }
}
