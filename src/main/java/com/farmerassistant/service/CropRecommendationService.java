package com.farmerassistant.service;

import com.farmerassistant.model.CropRecommendation;
import com.farmerassistant.model.WeatherReport;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;

public class CropRecommendationService {
    private final WeatherService weatherService = new WeatherService();

    public RecommendationResult recommend(String location, String soilType, String season, double landSize)
            throws IOException, InterruptedException {
        WeatherReport weather = weatherService.getLiveWeather(location);
        List<CropRecommendation> recommendations = new ArrayList<>();

        addIfSuitable(recommendations, weather, soilType, season, "Rice", "Kharif", "High",
                "Apply phosphorus at planting and split nitrogen during tillering.",
                score(weather, soilType, season, "Clay", "Kharif", 24, 36, true));
        addIfSuitable(recommendations, weather, soilType, season, "Wheat", "Rabi", "Medium",
                "Use balanced NPK at sowing and top dress nitrogen after first irrigation.",
                score(weather, soilType, season, "Loamy", "Rabi", 10, 28, false));
        addIfSuitable(recommendations, weather, soilType, season, "Tomato", "Rabi / Summer", "Medium",
                "Use compost before transplanting and split nitrogen in three doses.",
                score(weather, soilType, season, "Loamy", "Rabi", 18, 34, false));
        addIfSuitable(recommendations, weather, soilType, season, "Maize", "Kharif", "Medium",
                "Apply farmyard manure and split nitrogen between sowing and knee-high stage.",
                score(weather, soilType, season, "Loamy", "Kharif", 20, 35, false));
        addIfSuitable(recommendations, weather, soilType, season, "Cotton", "Kharif", "Medium",
                "Use potash-rich nutrition and avoid excess nitrogen.",
                score(weather, soilType, season, "Black soil", "Kharif", 22, 38, false));
        addIfSuitable(recommendations, weather, soilType, season, "Groundnut", "Kharif / Summer", "Low to Medium",
                "Use gypsum during pegging and avoid waterlogging.",
                score(weather, soilType, season, "Sandy", "Kharif", 22, 34, false));
        addIfSuitable(recommendations, weather, soilType, season, "Chickpea", "Rabi", "Low",
                "Use seed treatment and phosphorus-rich basal fertilizer.",
                score(weather, soilType, season, "Loamy", "Rabi", 12, 30, false));

        recommendations.sort(Comparator.comparing(CropRecommendation::getSuitability).reversed());
        if (recommendations.size() > 5) {
            recommendations = new ArrayList<>(recommendations.subList(0, 5));
        }

        String landAdvice = landSize > 0
                ? "For " + landSize + " acre(s), start with a small trial plot if this is a new crop for your field."
                : "Enter land size to get more accurate planning notes.";

        return new RecommendationResult(weather, recommendations, landAdvice);
    }

    private void addIfSuitable(List<CropRecommendation> list, WeatherReport weather, String soilType, String season,
                               String crop, String cropSeason, String waterNeed, String fertilizerAdvice, int score) {
        if (score < 35) {
            return;
        }
        String suitability = score >= 80 ? "Excellent" : score >= 60 ? "Good" : "Moderate";
        String reason = crop + " fits the selected " + safe(soilType) + " soil and current weather at "
                + weather.getLocationName() + " with " + weather.getTemperature() + " C temperature, "
                + weather.getHumidity() + "% humidity, and " + weather.getPrecipitation() + " mm rain.";
        list.add(new CropRecommendation(crop, suitability, cropSeason, waterNeed, fertilizerAdvice, reason));
    }

    private int score(WeatherReport weather, String soilType, String selectedSeason, String bestSoil,
                      String bestSeason, double minTemp, double maxTemp, boolean prefersRain) {
        int score = 40;
        String soil = safe(soilType).toLowerCase(Locale.ENGLISH);
        String season = safe(selectedSeason).toLowerCase(Locale.ENGLISH);

        if (soil.contains(bestSoil.toLowerCase(Locale.ENGLISH))) {
            score += 25;
        } else if (soil.contains("loamy")) {
            score += 12;
        }

        if (season.contains(bestSeason.toLowerCase(Locale.ENGLISH)) || season.contains("auto")) {
            score += 15;
        }

        double temperature = weather.getTemperature();
        if (temperature >= minTemp && temperature <= maxTemp) {
            score += 20;
        } else if (Math.abs(temperature - minTemp) <= 4 || Math.abs(temperature - maxTemp) <= 4) {
            score += 8;
        } else {
            score -= 12;
        }

        if (prefersRain && weather.getPrecipitation() > 1) {
            score += 8;
        }
        if (!prefersRain && weather.getPrecipitation() > 8) {
            score -= 10;
        }
        if (weather.getWeatherCode() >= 95) {
            score -= 15;
        }

        return Math.max(0, Math.min(100, score));
    }

    private String safe(String value) {
        return value == null || value.trim().isEmpty() ? "Auto" : value.trim();
    }

    public static class RecommendationResult {
        private final WeatherReport weatherReport;
        private final List<CropRecommendation> recommendations;
        private final String landAdvice;

        public RecommendationResult(WeatherReport weatherReport, List<CropRecommendation> recommendations, String landAdvice) {
            this.weatherReport = weatherReport;
            this.recommendations = recommendations;
            this.landAdvice = landAdvice;
        }

        public WeatherReport getWeatherReport() {
            return weatherReport;
        }

        public List<CropRecommendation> getRecommendations() {
            return recommendations;
        }

        public String getLandAdvice() {
            return landAdvice;
        }
    }
}
