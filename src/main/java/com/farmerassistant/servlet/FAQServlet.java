package com.farmerassistant.servlet;

import com.farmerassistant.dao.FarmerDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/faq")
public class FAQServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String category = request.getParameter("category");
            String language = request.getParameter("language");
            String faqId = request.getParameter("faqId");

            if (faqId != null && !faqId.isEmpty()) {
                farmerDAO.incrementFAQView(Integer.parseInt(faqId));
            }

            request.setAttribute("rows", farmerDAO.getFAQs(category, language));
            request.setAttribute("category", category);
            request.setAttribute("language", language);
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/faq.jsp").forward(request, response);
    }
}
