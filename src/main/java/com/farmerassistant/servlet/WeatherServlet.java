package com.farmerassistant.servlet;

import java.io.IOException;

import com.farmerassistant.service.WeatherService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/weather")
public class WeatherServlet extends HttpServlet {
    private final WeatherService weatherService = new WeatherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String location = request.getParameter("location");
        if (location == null || location.trim().isEmpty()) {
            location = "Bhopal";
        }
        request.setAttribute("location", location);
        try {
            request.setAttribute("report", weatherService.getLiveWeather(location));
        } catch (InterruptedException ex) {
            Thread.currentThread().interrupt();
            request.setAttribute("error", "Weather request was interrupted. Please try again.");
        } catch (IOException ex) {
            request.setAttribute("error", ex.getMessage());
        }
        request.getRequestDispatcher("/WEB-INF/views/weather.jsp").forward(request, response);
    }
}

