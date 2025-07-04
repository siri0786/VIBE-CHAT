package com.app;

import java.io.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/RegisterServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024)
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public static List<User> users = new ArrayList<>();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uname = request.getParameter("username");
        String pwd = request.getParameter("password");

        Part filePart = request.getPart("photo");
        String fileName = uname + "_" + filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        filePart.write(uploadPath + File.separator + fileName);

        for (User u : users) {
            if (u.getUsername().equalsIgnoreCase(uname)) {
                response.getWriter().println("<h3>Username already exists</h3>");
                return;
            }
        }

        users.add(new User(uname, pwd, "uploads/" + fileName));
        response.sendRedirect("login.html");
    }
}
