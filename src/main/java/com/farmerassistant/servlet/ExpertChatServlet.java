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

@WebServlet("/expert-chat")
public class ExpertChatServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        try {
            String queryId = request.getParameter("queryId");
            if (queryId != null && !queryId.isEmpty()) {
                request.setAttribute("replies", farmerDAO.getExpertReplies(Integer.parseInt(queryId)));
                request.setAttribute("queryId", queryId);
            }
            request.setAttribute("queries", farmerDAO.getQueriesByUser(user.getId()));
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/queries");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String queryId = request.getParameter("queryId");
            String expertId = request.getParameter("expertId");
            String replyText = request.getParameter("replyText");

            if (queryId != null && expertId != null && replyText != null) {
                farmerDAO.addExpertReply(Integer.parseInt(queryId), Integer.parseInt(expertId), replyText);
                response.sendRedirect(request.getContextPath() + "/queries");
            } else {
                request.setAttribute("error", "Missing required parameters");
                doGet(request, response);
            }
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
            doGet(request, response);
        }
    }
}
