package com.farmerassistant.servlet;

import com.farmerassistant.dao.FarmerDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/mandi-prices")
public class MandiPriceServlet extends HttpServlet {
    private final FarmerDAO farmerDAO = new FarmerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String commodity = request.getParameter("commodity");
            String state = request.getParameter("state");
            String district = request.getParameter("district");
            String latitude = request.getParameter("latitude");
            String longitude = request.getParameter("longitude");
            String action = request.getParameter("action");

            if ("nearby".equals(action) && latitude != null && longitude != null) {
                double lat = Double.parseDouble(latitude);
                double lon = Double.parseDouble(longitude);
                double maxDistance = 50.0;
                String distanceParam = request.getParameter("maxDistance");
                if (distanceParam != null) {
                    maxDistance = Double.parseDouble(distanceParam);
                }
                request.setAttribute("rows", farmerDAO.getNearbyMandiPrices(lat, lon, commodity, maxDistance));
                request.setAttribute("action", "nearby");
            } else if ("best".equals(action) && commodity != null && latitude != null && longitude != null) {
                double lat = Double.parseDouble(latitude);
                double lon = Double.parseDouble(longitude);
                request.setAttribute("rows", farmerDAO.getBestMandiForCrop(commodity, lat, lon));
                request.setAttribute("action", "best");
            } else {
                request.setAttribute("rows", farmerDAO.getMandiPrices(commodity, state, district));
            }

            request.setAttribute("commodity", commodity);
            request.setAttribute("state", state);
            request.setAttribute("district", district);
        } catch (SQLException ex) {
            request.setAttribute("error", "Database error: " + ex.getMessage());
        } catch (NumberFormatException ex) {
            request.setAttribute("error", "Invalid coordinates: " + ex.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/market-price");
    }
}
