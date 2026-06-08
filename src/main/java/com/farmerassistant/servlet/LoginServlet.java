package com.farmerassistant.servlet;

import com.farmerassistant.dao.UserDAO;
import com.farmerassistant.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            User user = userDAO.findByEmailAndPassword(email, password);
            if (user == null) {
                request.setAttribute("error", "Invalid email or password.");
                doGet(request, response);
                return;
            }
            request.getSession(true).setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            doGet(request, response);
        }
    }
}

