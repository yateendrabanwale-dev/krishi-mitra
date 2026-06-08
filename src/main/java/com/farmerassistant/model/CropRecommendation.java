package com.farmerassistant.model;

public class CropRecommendation {
    private final String cropName;
    private final String suitability;
    private final String season;
    private final String waterNeed;
    private final String fertilizerAdvice;
    private final String reason;

    public CropRecommendation(String cropName, String suitability, String season, String waterNeed,
                              String fertilizerAdvice, String reason) {
        this.cropName = cropName;
        this.suitability = suitability;
        this.season = season;
        this.waterNeed = waterNeed;
        this.fertilizerAdvice = fertilizerAdvice;
        this.reason = reason;
    }

    public String getCropName() {
        return cropName;
    }

    public String getSuitability() {
        return suitability;
    }

    public String getSeason() {
        return season;
    }

    public String getWaterNeed() {
        return waterNeed;
    }

    public String getFertilizerAdvice() {
        return fertilizerAdvice;
    }

    public String getReason() {
        return reason;
    }
}
