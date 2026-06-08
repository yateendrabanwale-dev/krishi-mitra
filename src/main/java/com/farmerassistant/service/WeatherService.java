package com.farmerassistant.service;

import com.farmerassistant.model.WeatherReport;

import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WeatherService {
    private static final String GEOCODING_URL = "https://geocoding-api.open-meteo.com/v1/search?count=1&language=en&format=json&name=";
    private static final String FORECAST_URL = "https://api.open-meteo.com/v1/forecast?current=temperature_2m,relative_humidity_2m,precipitation,wind_speed_10m,weather_code&timezone=auto";

    private final HttpClient httpClient = HttpClient.newHttpClient();

    public WeatherReport getLiveWeather(String location) throws IOException, InterruptedException {
        String search = location == null || location.trim().isEmpty() ? "New Delhi" : location.trim();
        String encodedLocation = URLEncoder.encode(search, StandardCharsets.UTF_8);
        String geocodeJson = sendGet(GEOCODING_URL + encodedLocation);

        String firstResult = firstObjectFromResults(geocodeJson);
        if (firstResult == null) {
            throw new IOException("Location not found. Please try a nearby city or district name.");
        }

        String name = textValue(firstResult, "name");
        String country = textValue(firstResult, "country");
        double latitude = numberValue(firstResult, "latitude");
        double longitude = numberValue(firstResult, "longitude");

        String weatherUrl = FORECAST_URL + "&latitude=" + latitude + "&longitude=" + longitude;
        String weatherJson = sendGet(weatherUrl);
        String current = objectValue(weatherJson, "current");
        if (current == null) {
            throw new IOException("Live weather data is not available for this location right now.");
        }

        double temperature = numberValue(current, "temperature_2m");
        double humidity = numberValue(current, "relative_humidity_2m");
        double precipitation = numberValue(current, "precipitation");
        double windSpeed = numberValue(current, "wind_speed_10m");
        int weatherCode = (int) numberValue(current, "weather_code");
        String time = textValue(current, "time");
        String condition = conditionFor(weatherCode);
        String advice = farmingAdvice(temperature, humidity, precipitation, windSpeed, weatherCode);

        return new WeatherReport(name, country, latitude, longitude, time, temperature, humidity,
                precipitation, windSpeed, weatherCode, condition, advice);
    }

    private String sendGet(String url) throws IOException, InterruptedException {
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Accept", "application/json")
                .GET()
                .build();
        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IOException("Weather API request failed with status " + response.statusCode());
        }
        return response.body();
    }

    private String firstObjectFromResults(String json) {
        int resultsIndex = json.indexOf("\"results\"");
        if (resultsIndex < 0) {
            return null;
        }
        int start = json.indexOf('{', resultsIndex);
        if (start < 0) {
            return null;
        }
        int depth = 0;
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '{') {
                depth++;
            } else if (c == '}') {
                depth--;
                if (depth == 0) {
                    return json.substring(start, i + 1);
                }
            }
        }
        return null;
    }

    private String objectValue(String json, String key) {
        int keyIndex = json.indexOf("\"" + key + "\"");
        if (keyIndex < 0) {
            return null;
        }
        int start = json.indexOf('{', keyIndex);
        if (start < 0) {
            return null;
        }
        int depth = 0;
        for (int i = start; i < json.length(); i++) {
            char c = json.charAt(i);
            if (c == '{') {
                depth++;
            } else if (c == '}') {
                depth--;
                if (depth == 0) {
                    return json.substring(start, i + 1);
                }
            }
        }
        return null;
    }

    private String textValue(String json, String key) {
        Matcher matcher = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*\"([^\"]*)\"").matcher(json);
        return matcher.find() ? matcher.group(1) : "";
    }

    private double numberValue(String json, String key) {
        Matcher matcher = Pattern.compile("\"" + Pattern.quote(key) + "\"\\s*:\\s*(-?\\d+(?:\\.\\d+)?)").matcher(json);
        return matcher.find() ? Double.parseDouble(matcher.group(1)) : 0;
    }

    private String conditionFor(int code) {
        if (code == 0) {
            return "Clear sky";
        }
        if (code <= 3) {
            return "Cloudy";
        }
        if (code == 45 || code == 48) {
            return "Fog";
        }
        if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
            return "Rain";
        }
        if (code >= 95) {
            return "Thunderstorm";
        }
        return "Changing weather";
    }

    private String farmingAdvice(double temperature, double humidity, double precipitation, double windSpeed, int weatherCode) {
        if (weatherCode >= 95) {
            return "Avoid field spraying and keep workers away from open fields during thunderstorm conditions.";
        }
        if (precipitation > 2) {
            return "Rain is active. Delay irrigation and avoid pesticide spraying until leaves are dry.";
        }
        if (windSpeed > 25) {
            return "Wind is high. Avoid spraying and support young plants if needed.";
        }
        if (temperature > 35) {
            return "Heat stress is possible. Irrigate early morning or evening and use mulch for vegetables.";
        }
        if (humidity > 80) {
            return "High humidity can increase fungal disease risk. Inspect leaves and improve field ventilation.";
        }
        return "Weather is suitable for normal field work. Check soil moisture before irrigation.";
    }
}
