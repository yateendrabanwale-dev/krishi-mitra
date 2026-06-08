package com.farmerassistant.servlet;

import com.farmerassistant.dao.FarmerDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/market-price")
public class MarketPriceServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setAttribute("rows", farmerDAO.getMarketPrices());
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/market-price.jsp").forward(request, response);
    }
}

