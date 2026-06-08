package com.farmerassistant.model;

public class DiseaseDetection {
    private final int id;
    private final int queryId;
    private final String cropName;
    private final String diseaseName;
    private final Double confidence;
    private final String treatmentAdvice;
    private final String createdAt;

    public DiseaseDetection(int id, int queryId, String cropName, String diseaseName, 
                          Double confidence, String treatmentAdvice, String createdAt) {
        this.id = id;
        this.queryId = queryId;
        this.cropName = cropName;
        this.diseaseName = diseaseName;
        this.confidence = confidence;
        this.treatmentAdvice = treatmentAdvice;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public int getQueryId() { return queryId; }
    public String getCropName() { return cropName; }
    public String getDiseaseName() { return diseaseName; }
    public Double getConfidence() { return confidence; }
    public String getTreatmentAdvice() { return treatmentAdvice; }
    public String getCreatedAt() { return createdAt; }
}
