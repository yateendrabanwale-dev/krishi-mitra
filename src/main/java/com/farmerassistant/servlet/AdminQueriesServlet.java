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

@WebServlet("/admin-queries")
public class AdminQueriesServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String action = request.getParameter("action");
            String queryId = request.getParameter("id");
            
            if ("view".equals(action) && queryId != null) {
                request.setAttribute("query", farmerDAO.getQueryById(Integer.parseInt(queryId)));
                request.setAttribute("replies", farmerDAO.getExpertReplies(Integer.parseInt(queryId)));
                request.getRequestDispatcher("/WEB-INF/views/admin-query-detail.jsp").forward(request, response);
            } else if ("reply".equals(action) && queryId != null) {
                request.setAttribute("query", farmerDAO.getQueryById(Integer.parseInt(queryId)));
                request.getRequestDispatcher("/WEB-INF/views/admin-query-reply.jsp").forward(request, response);
            } else {
                request.setAttribute("queries", farmerDAO.getAllQueries(100));
                request.getRequestDispatcher("/WEB-INF/views/admin-queries.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin-queries.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String queryId = request.getParameter("queryId");
            String replyText = request.getParameter("replyText");
            
            if (queryId != null && replyText != null && !replyText.isEmpty()) {
                farmerDAO.addExpertReply(Integer.parseInt(queryId), user.getId(), replyText);
                response.sendRedirect(request.getContextPath() + "/admin-queries");
            } else {
                request.setAttribute("error", "Please provide a reply");
                doGet(request, response);
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            doGet(request, response);
        }
    }
}
