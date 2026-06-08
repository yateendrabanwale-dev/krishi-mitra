package com.farmerassistant.dao;

import com.farmerassistant.model.User;
import com.farmerassistant.util.DBConnection;
import com.farmerassistant.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {
    public User findByEmailAndPassword(String email, String password) throws SQLException {
        String sql = "SELECT id, full_name, email, phone, role FROM users WHERE email = ? AND password_hash = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setString(2, PasswordUtil.sha256(password));
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return new User(
                            resultSet.getInt("id"),
                            resultSet.getString("full_name"),
                            resultSet.getString("email"),
                            resultSet.getString("phone"),
                            resultSet.getString("role")
                    );
                }
            }
        }
        return null;
    }

    public boolean register(String fullName, String email, String phone, String password) throws SQLException {
        String sql = "INSERT INTO users (full_name, email, phone, password_hash, role) VALUES (?, ?, ?, ?, 'Farmer')";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fullName);
            statement.setString(2, email);
            statement.setString(3, phone);
            statement.setString(4, PasswordUtil.sha256(password));
            return statement.executeUpdate() == 1;
        }
    }
}

