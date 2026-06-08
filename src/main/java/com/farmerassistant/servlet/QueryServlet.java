package com.farmerassistant.servlet;

import com.farmerassistant.dao.FarmerDAO;
import com.farmerassistant.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/queries")
public class QueryServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        try {
            request.setAttribute("rows", farmerDAO.getQueriesByUser(user.getId()));
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/queries.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        try {
            String queryType = request.getParameter("queryType");
            String language = request.getParameter("language");
            String imagePath = request.getParameter("imagePath");
            
            if (queryType == null || queryType.isEmpty()) {
                queryType = "Text";
            }
            if (language == null || language.isEmpty()) {
                language = "English";
            }
            
            farmerDAO.addQuery(user.getId(), request.getParameter("subject"), request.getParameter("message"), 
                              queryType, language, imagePath);
            response.sendRedirect(request.getContextPath() + "/queries");
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            doGet(request, response);
        }
    }
}

