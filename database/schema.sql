CREATE DATABASE IF NOT EXISTS farmer_assistant;
USE farmer_assistant;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  phone VARCHAR(20),
  password_hash VARCHAR(64) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'Farmer',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS crop_recommendations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  crop_name VARCHAR(80) NOT NULL,
  soil_type VARCHAR(80) NOT NULL,
  season VARCHAR(80) NOT NULL,
  water_need VARCHAR(80) NOT NULL,
  fertilizer_advice VARCHAR(255) NOT NULL,
  description TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS weather_forecasts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  location VARCHAR(100) NOT NULL,
  forecast_date DATE NOT NULL,
  temperature_c INT NOT NULL,
  rainfall_mm DECIMAL(6,2) NOT NULL,
  condition_text VARCHAR(120) NOT NULL,
  advice VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS market_prices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  crop_name VARCHAR(80) NOT NULL,
  market_name VARCHAR(120) NOT NULL,
  price_per_quintal DECIMAL(10,2) NOT NULL,
  price_date DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS government_schemes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  scheme_name VARCHAR(160) NOT NULL,
  eligibility VARCHAR(255) NOT NULL,
  benefits VARCHAR(255) NOT NULL,
  apply_link VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS farmer_queries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  subject VARCHAR(160) NOT NULL,
  message TEXT NOT NULL,
 
  language VARCHAR(30) NOT NULL DEFAULT 'English',
  image_path VARCHAR(255),
  detected_issue VARCHAR(255),
  status VARCHAR(30) NOT NULL DEFAULT 'Pending',
  reply TEXT,
  expert_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  replied_at TIMESTAMP NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS mandi_prices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  state VARCHAR(100) NOT NULL,
  district VARCHAR(100) NOT NULL,
  market_name VARCHAR(120) NOT NULL,
  commodity VARCHAR(80) NOT NULL,
  variety VARCHAR(80),
  arrival_date DATE NOT NULL,
  min_price DECIMAL(10,2) NOT NULL,
  max_price DECIMAL(10,2) NOT NULL,
  modal_price DECIMAL(10,2) NOT NULL,
  yesterday_price DECIMAL(10,2),
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS expert_replies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  query_id INT NOT NULL,
  expert_id INT NOT NULL,
  reply_text TEXT NOT NULL,
  reply_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (query_id) REFERENCES farmer_queries(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS faqs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  question VARCHAR(255) NOT NULL,
  answer TEXT NOT NULL,
  language VARCHAR(30) NOT NULL DEFAULT 'English',
  views INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS disease_detections (
  id INT AUTO_INCREMENT PRIMARY KEY,
  query_id INT NOT NULL,
  crop_name VARCHAR(80) NOT NULL,
  disease_name VARCHAR(120) NOT NULL,
  confidence DECIMAL(5,2),
  treatment_advice TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (query_id) REFERENCES farmer_queries(id) ON DELETE CASCADE
);

INSERT IGNORE INTO users (id, full_name, email, phone, password_hash, role) VALUES
(1, 'Sample Farmer', 'farmer@example.com', '9999999999', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Farmer'),
(2, 'Admin User', 'admin@krishimitra.com', '8888888888', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Admin');

INSERT INTO crop_recommendations (crop_name, soil_type, season, water_need, fertilizer_advice, description) VALUES
('Tomato', 'Loamy', 'Rabi / Summer', 'Medium', 'Use compost before transplanting and split nitrogen doses.', 'Best for well-drained loamy soil with regular irrigation.'),
('Rice', 'Clay', 'Kharif', 'High', 'Apply phosphorus at planting and nitrogen in split doses.', 'Suitable where water availability is strong.'),
('Wheat', 'Loamy', 'Rabi', 'Medium', 'Use balanced NPK and top dress nitrogen after first irrigation.', 'Grows well in cool weather with timely irrigation.'),
('Cotton', 'Black soil', 'Kharif', 'Medium', 'Use potash-rich nutrition and avoid excess nitrogen.', 'Suitable for deep black soil with good drainage.');

INSERT INTO weather_forecasts (location, forecast_date, temperature_c, rainfall_mm, condition_text, advice) VALUES
('Local Farm', CURDATE(), 31, 2.50, 'Partly cloudy', 'Irrigate vegetables early morning if soil is dry.'),
('Local Farm', DATE_ADD(CURDATE(), INTERVAL 1 DAY), 30, 12.00, 'Light rain expected', 'Delay pesticide spraying until leaves are dry.'),
('Local Farm', DATE_ADD(CURDATE(), INTERVAL 2 DAY), 33, 0.00, 'Sunny', 'Mulch young plants and monitor soil moisture.');

INSERT INTO market_prices (crop_name, market_name, price_per_quintal, price_date) VALUES
('Tomato', 'Main Mandi', 1850.00, CURDATE()),
('Rice', 'Main Mandi', 2220.00, CURDATE()),
('Wheat', 'Main Mandi', 2410.00, CURDATE()),
('Maize', 'Main Mandi', 2050.00, CURDATE());

INSERT INTO government_schemes (scheme_name, eligibility, benefits, apply_link) VALUES
('PM-KISAN', 'Eligible small and marginal farmers', 'Income support paid in installments', 'https://pmkisan.gov.in/'),
('Soil Health Card', 'Farmers with cultivable land', 'Soil testing and nutrient recommendation', 'https://soilhealth.dac.gov.in/'),
('PM Fasal Bima Yojana', 'Farmers growing notified crops in notified areas', 'Crop insurance support', 'https://pmfby.gov.in/');

INSERT INTO mandi_prices (state, district, market_name, commodity, variety, arrival_date, min_price, max_price, modal_price, yesterday_price, latitude, longitude) VALUES
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Tomato', 'Local', CURDATE(), 1800.00, 2200.00, 1950.00, 1850.00, 18.5204, 73.8567),
('Maharashtra', 'Nashik', 'Nashik Mandi', 'Tomato', 'Local', CURDATE(), 1750.00, 2100.00, 1900.00, 1820.00, 19.9975, 73.7898),
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Onion', 'Red', CURDATE(), 1200.00, 1500.00, 1350.00, 1300.00, 18.5204, 73.8567),
('Maharashtra', 'Nashik', 'Nashik Mandi', 'Onion', 'Red', CURDATE(), 1150.00, 1450.00, 1300.00, 1250.00, 19.9975, 73.7898),
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Wheat', 'Lokwan', CURDATE(), 2300.00, 2600.00, 2450.00, 2400.00, 18.5204, 73.8567),
('Maharashtra', 'Nagpur', 'Nagpur Mandi', 'Cotton', 'Long Staple', CURDATE(), 6200.00, 6800.00, 6500.00, 6400.00, 21.1458, 79.0882);

INSERT INTO faqs (category, question, answer, language) VALUES
('Crop Diseases', 'What are the common signs of tomato leaf curl?', 'Tomato leaf curl is characterized by upward curling of leaves, yellowing, and stunted growth. It is caused by whitefly transmission of the virus. Use yellow sticky traps and remove affected plants.', 'English'),
('Irrigation', 'How often should I water my crops in summer?', 'In summer, most crops need watering every 2-3 days. Early morning or late evening irrigation is best to reduce evaporation. Check soil moisture before watering.', 'English'),
('Fertilizers', 'When should I apply nitrogen fertilizer?', 'Nitrogen should be applied in split doses - basal application at sowing, and top dressing during critical growth stages like tillering or flowering. Avoid excess nitrogen as it promotes vegetative growth over yield.', 'English'),
('Pest Control', 'How can I control aphids naturally?', 'Use neem oil spray, introduce ladybugs, or use a strong water spray to dislodge them. Avoid over-fertilizing with nitrogen as it attracts aphids.', 'English'),
('Market', 'What is the best time to sell crops?', 'Sell when prices are high, typically during scarcity periods. Monitor mandi prices regularly and avoid selling immediately after harvest when supply is high and prices are low.', 'English');

