package com.farmerassistant.servlet;

import java.io.IOException;

import com.farmerassistant.service.CropRecommendationService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/crop-recommendation")
public class CropRecommendationServlet extends HttpServlet {
    private final CropRecommendationService cropRecommendationService = new CropRecommendationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String location = request.getParameter("location");
        String soil = request.getParameter("soil");
        String season = request.getParameter("season");
        double landSize = parseLandSize(request.getParameter("landSize"));

        if (location == null || location.trim().isEmpty()) {
            location = "Bhopal";
        }
        if (soil == null || soil.trim().isEmpty()) {
            soil = "Loamy";
        }
        if (season == null || season.trim().isEmpty()) {
            season = "Auto";
        }

        request.setAttribute("location", location);
        request.setAttribute("soil", soil);
        request.setAttribute("season", season);
        request.setAttribute("landSize", landSize > 0 ? landSize : "");

        try {
            request.setAttribute("result", cropRecommendationService.recommend(location, soil, season, landSize));
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            request.setAttribute("error", "Recommendation request was interrupted. Please try again.");
        } catch (IOException ex) {
            request.setAttribute("error", ex.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/crop-recommendation.jsp").forward(request, response);
    }

    private double parseLandSize(String value) {
        try {
            return value == null || value.trim().isEmpty() ? 0 : Double.parseDouble(value);
        } catch (NumberFormatException ex) {
            return 0;
        }
    }
}

