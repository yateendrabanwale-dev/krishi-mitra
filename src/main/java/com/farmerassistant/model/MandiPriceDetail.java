package com.farmerassistant.model;

public class MandiPriceDetail {
    private final int id;
    private final String state;
    private final String district;
    private final String marketName;
    private final String commodity;
    private final String variety;
    private final String arrivalDate;
    private final double minPrice;
    private final double maxPrice;
    private final double modalPrice;
    private final double yesterdayPrice;
    private final Double latitude;
    private final Double longitude;

    public MandiPriceDetail(int id, String state, String district, String marketName, String commodity,
                           String variety, String arrivalDate, double minPrice, double maxPrice,
                           double modalPrice, double yesterdayPrice, Double latitude, Double longitude) {
        this.id = id;
        this.state = state;
        this.district = district;
        this.marketName = marketName;
        this.commodity = commodity;
        this.variety = variety;
        this.arrivalDate = arrivalDate;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.modalPrice = modalPrice;
        this.yesterdayPrice = yesterdayPrice;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public int getId() { return id; }
    public String getState() { return state; }
    public String getDistrict() { return district; }
    public String getMarketName() { return marketName; }
    public String getCommodity() { return commodity; }
    public String getVariety() { return variety; }
    public String getArrivalDate() { return arrivalDate; }
    public double getMinPrice() { return minPrice; }
    public double getMaxPrice() { return maxPrice; }
    public double getModalPrice() { return modalPrice; }
    public double getYesterdayPrice() { return yesterdayPrice; }
    public Double getLatitude() { return latitude; }
    public Double getLongitude() { return longitude; }

    public double getTrendAmount() {
        return modalPrice - yesterdayPrice;
    }

    public String getTrendLabel() {
        if (yesterdayPrice <= 0) {
            return "New";
        }
        double diff = getTrendAmount();
        if (diff > 0) {
            return "↑ Rs. " + Math.round(diff);
        }
        if (diff < 0) {
            return "↓ Rs. " + Math.round(Math.abs(diff));
        }
        return "→ No change";
    }

    public boolean isPriceUp() {
        return getTrendAmount() > 0;
    }

    public double getDistanceFrom(Double userLat, Double userLon) {
        if (latitude == null || longitude == null || userLat == null || userLon == null) {
            return Double.MAX_VALUE;
        }
        final int R = 6371;
        double latDistance = Math.toRadians(userLat - latitude);
        double lonDistance = Math.toRadians(userLon - longitude);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(latitude)) * Math.cos(Math.toRadians(userLat))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}
