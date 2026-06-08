package com.farmerassistant.model;

public class WeatherReport {
    private final String locationName;
    private final String country;
    private final double latitude;
    private final double longitude;
    private final String time;
    private final double temperature;
    private final double humidity;
    private final double precipitation;
    private final double windSpeed;
    private final int weatherCode;
    private final String condition;
    private final String advice;

    public WeatherReport(String locationName, String country, double latitude, double longitude, String time,
                         double temperature, double humidity, double precipitation, double windSpeed,
                         int weatherCode, String condition, String advice) {
        this.locationName = locationName;
        this.country = country;
        this.latitude = latitude;
        this.longitude = longitude;
        this.time = time;
        this.temperature = temperature;
        this.humidity = humidity;
        this.precipitation = precipitation;
        this.windSpeed = windSpeed;
        this.weatherCode = weatherCode;
        this.condition = condition;
        this.advice = advice;
    }

    public String getLocationName() {
        return locationName;
    }

    public String getCountry() {
        return country;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getTime() {
        return time;
    }

    public double getTemperature() {
        return temperature;
    }

    public double getHumidity() {
        return humidity;
    }

    public double getPrecipitation() {
        return precipitation;
    }

    public double getWindSpeed() {
        return windSpeed;
    }

    public int getWeatherCode() {
        return weatherCode;
    }

    public String getCondition() {
        return condition;
    }

    public String getAdvice() {
        return advice;
    }
}
