package com.farmerassistant.model;

public class MandiPrice {
    private final String state;
    private final String district;
    private final String market;
    private final String commodity;
    private final String variety;
    private final String arrivalDate;
    private final double minPrice;
    private final double maxPrice;
    private final double modalPrice;
    private final double yesterdayPrice;

    public MandiPrice(String state, String district, String market, String commodity, String variety,
                      String arrivalDate, double minPrice, double maxPrice, double modalPrice, double yesterdayPrice) {
        this.state = state;
        this.district = district;
        this.market = market;
        this.commodity = commodity;
        this.variety = variety;
        this.arrivalDate = arrivalDate;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.modalPrice = modalPrice;
        this.yesterdayPrice = yesterdayPrice;
    }

    public String getState() { return state; }
    public String getDistrict() { return district; }
    public String getMarket() { return market; }
    public String getCommodity() { return commodity; }
    public String getVariety() { return variety; }
    public String getArrivalDate() { return arrivalDate; }
    public double getMinPrice() { return minPrice; }
    public double getMaxPrice() { return maxPrice; }
    public double getModalPrice() { return modalPrice; }
    public double getYesterdayPrice() { return yesterdayPrice; }

    public double getTrendAmount() {
        return modalPrice - yesterdayPrice;
    }

    public String getTrendLabel() {
        if (yesterdayPrice <= 0) {
            return "New";
        }
        double diff = getTrendAmount();
        if (diff > 0) {
            return "Up Rs. " + Math.round(diff);
        }
        if (diff < 0) {
            return "Down Rs. " + Math.round(Math.abs(diff));
        }
        return "No change";
    }
}
