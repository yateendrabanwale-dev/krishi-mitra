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

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        
        // Check if user is admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            request.setAttribute("totalQueries", farmerDAO.countRows("farmer_queries"));
            request.setAttribute("pendingQueries", farmerDAO.getPendingQueriesCount());
            request.setAttribute("totalUsers", farmerDAO.countRows("users"));
            request.setAttribute("totalFAQs", farmerDAO.countRows("faqs"));
            request.setAttribute("recentQueries", farmerDAO.getAllQueries(10));
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }
}
