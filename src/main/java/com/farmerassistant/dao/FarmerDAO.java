package com.farmerassistant.dao;

import com.farmerassistant.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class FarmerDAO {
    public List<Map<String, Object>> getCropRecommendations(String crop, String soil) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM crop_recommendations WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (crop != null && !crop.trim().isEmpty()) {
            sql.append(" AND crop_name LIKE ?");
            params.add("%" + crop.trim() + "%");
        }
        if (soil != null && !soil.trim().isEmpty()) {
            sql.append(" AND soil_type LIKE ?");
            params.add("%" + soil.trim() + "%");
        }
        sql.append(" ORDER BY crop_name");
        return query(sql.toString(), params);
    }

    public List<Map<String, Object>> getWeatherForecasts() throws SQLException {
        return query("SELECT * FROM weather_forecasts ORDER BY forecast_date", new ArrayList<>());
    }

    public List<Map<String, Object>> getMarketPrices() throws SQLException {
        return query("SELECT * FROM market_prices ORDER BY price_date DESC, crop_name", new ArrayList<>());
    }

    public List<Map<String, Object>> getGovernmentSchemes() throws SQLException {
        return query("SELECT * FROM government_schemes ORDER BY scheme_name", new ArrayList<>());
    }

    public List<Map<String, Object>> getQueriesByUser(int userId) throws SQLException {
        List<String> params = new ArrayList<>();
        params.add(String.valueOf(userId));
        return query("SELECT * FROM farmer_queries WHERE user_id = ? ORDER BY created_at DESC", params);
    }

    public void addQuery(int userId, String subject, String message, String queryType, String language, String imagePath) throws SQLException {
        String sql = "INSERT INTO farmer_queries (user_id, subject, message, query_type, language, image_path) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, userId);
            statement.setString(2, subject);
            statement.setString(3, message);
            statement.setString(4, queryType);
            statement.setString(5, language);
            statement.setString(6, imagePath);
            statement.executeUpdate();
        }
    }

    public int addQueryWithReturn(int userId, String subject, String message, String queryType, String language, String imagePath) throws SQLException {
        String sql = "INSERT INTO farmer_queries (user_id, subject, message, query_type, language, image_path) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, userId);
            statement.setString(2, subject);
            statement.setString(3, message);
            statement.setString(4, queryType);
            statement.setString(5, language);
            statement.setString(6, imagePath);
            statement.executeUpdate();
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }

    public List<Map<String, Object>> getMandiPrices(String commodity, String state, String district) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM mandi_prices WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (commodity != null && !commodity.trim().isEmpty()) {
            sql.append(" AND commodity LIKE ?");
            params.add("%" + commodity.trim() + "%");
        }
        if (state != null && !state.trim().isEmpty()) {
            sql.append(" AND state LIKE ?");
            params.add("%" + state.trim() + "%");
        }
        if (district != null && !district.trim().isEmpty()) {
            sql.append(" AND district LIKE ?");
            params.add("%" + district.trim() + "%");
        }
        sql.append(" ORDER BY arrival_date DESC, modal_price DESC");
        return query(sql.toString(), params);
    }

    public List<Map<String, Object>> getNearbyMandiPrices(Double latitude, Double longitude, String commodity, double maxDistanceKm) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT *, " +
                "((ACOS(SIN(RADIANS(?)) * SIN(RADIANS(latitude)) + " +
                "COS(RADIANS(?)) * COS(RADIANS(latitude)) * " +
                "COS(RADIANS(?) - RADIANS(longitude))) * 6371)) AS distance " +
                "FROM mandi_prices WHERE latitude IS NOT NULL AND longitude IS NOT NULL");
        List<String> params = new ArrayList<>();
        params.add(String.valueOf(latitude));
        params.add(String.valueOf(latitude));
        params.add(String.valueOf(longitude));
        
        if (commodity != null && !commodity.trim().isEmpty()) {
            sql.append(" AND commodity LIKE ?");
            params.add("%" + commodity.trim() + "%");
        }
        
        sql.append(" HAVING distance <= ? ORDER BY distance ASC, modal_price DESC");
        params.add(String.valueOf(maxDistanceKm));
        
        return query(sql.toString(), params);
    }

    public List<Map<String, Object>> getBestMandiForCrop(String commodity, Double latitude, Double longitude) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT *, " +
                "((ACOS(SIN(RADIANS(?)) * SIN(RADIANS(latitude)) + " +
                "COS(RADIANS(?)) * COS(RADIANS(latitude)) * " +
                "COS(RADIANS(?) - RADIANS(longitude))) * 6371)) AS distance, " +
                "(modal_price - yesterday_price) AS price_gain " +
                "FROM mandi_prices WHERE commodity = ? AND latitude IS NOT NULL AND longitude IS NOT NULL");
        List<String> params = new ArrayList<>();
        params.add(String.valueOf(latitude));
        params.add(String.valueOf(latitude));
        params.add(String.valueOf(longitude));
        params.add(commodity);
        
        sql.append(" ORDER BY price_gain DESC, distance ASC LIMIT 5");
        
        return query(sql.toString(), params);
    }

    public List<Map<String, Object>> getFAQs(String category, String language) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM faqs WHERE 1=1");
        List<String> params = new ArrayList<>();
        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category LIKE ?");
            params.add("%" + category.trim() + "%");
        }
        if (language != null && !language.trim().isEmpty()) {
            sql.append(" AND language = ?");
            params.add(language);
        }
        sql.append(" ORDER BY views DESC, created_at DESC");
        return query(sql.toString(), params);
    }

    public void incrementFAQView(int faqId) throws SQLException {
        String sql = "UPDATE faqs SET views = views + 1 WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, faqId);
            statement.executeUpdate();
        }
    }

    public void addExpertReply(int queryId, int expertId, String replyText) throws SQLException {
        String sql = "INSERT INTO expert_replies (query_id, expert_id, reply_text) VALUES (?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, queryId);
            statement.setInt(2, expertId);
            statement.setString(3, replyText);
            statement.executeUpdate();
        }
        
        String updateQuery = "UPDATE farmer_queries SET status = 'Answered', replied_at = NOW(), expert_id = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {
            statement.setInt(1, expertId);
            statement.setInt(2, queryId);
            statement.executeUpdate();
        }
    }

    public List<Map<String, Object>> getExpertReplies(int queryId) throws SQLException {
        List<String> params = new ArrayList<>();
        params.add(String.valueOf(queryId));
        return query("SELECT * FROM expert_replies WHERE query_id = ? ORDER BY reply_date ASC", params);
    }

    public void addDiseaseDetection(int queryId, String cropName, String diseaseName, Double confidence, String treatmentAdvice) throws SQLException {
        String sql = "INSERT INTO disease_detections (query_id, crop_name, disease_name, confidence, treatment_advice) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, queryId);
            statement.setString(2, cropName);
            statement.setString(3, diseaseName);
            if (confidence != null) {
                statement.setDouble(4, confidence);
            } else {
                statement.setNull(4, java.sql.Types.DOUBLE);
            }
            statement.setString(5, treatmentAdvice);
            statement.executeUpdate();
        }
        
        String updateQuery = "UPDATE farmer_queries SET detected_issue = ? WHERE id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(updateQuery)) {
            statement.setString(1, diseaseName);
            statement.setInt(2, queryId);
            statement.executeUpdate();
        }
    }

    public int countRows(String tableName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    public int getPendingQueriesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM farmer_queries WHERE status = 'Pending'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            resultSet.next();
            return resultSet.getInt(1);
        }
    }

    public List<Map<String, Object>> getAllQueries(int limit) throws SQLException {
        String sql = "SELECT fq.*, u.full_name FROM farmer_queries fq " +
                     "JOIN users u ON fq.user_id = u.id " +
                     "ORDER BY fq.created_at DESC LIMIT " + limit;
        return query(sql, new ArrayList<>());
    }

    public Map<String, Object> getQueryById(int queryId) throws SQLException {
        String sql = "SELECT fq.*, u.full_name, u.email FROM farmer_queries fq " +
                     "JOIN users u ON fq.user_id = u.id " +
                     "WHERE fq.id = ?";
        List<String> params = new ArrayList<>();
        params.add(String.valueOf(queryId));
        List<Map<String, Object>> results = query(sql, params);
        return results.isEmpty() ? null : results.get(0);
    }

    private List<Map<String, Object>> query(String sql, List<String> params) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                statement.setString(i + 1, params.get(i));
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                int columnCount = resultSet.getMetaData().getColumnCount();
                while (resultSet.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        row.put(resultSet.getMetaData().getColumnLabel(i), resultSet.getObject(i));
                    }
                    rows.add(row);
                }
            }
        }
        return rows;
    }
}

