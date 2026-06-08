-- Add missing columns to farmer_queries table for new query system features
ALTER TABLE farmer_queries 
ADD COLUMN IF NOT EXISTS query_type VARCHAR(30) NOT NULL DEFAULT 'Text',
ADD COLUMN IF NOT EXISTS language VARCHAR(30) NOT NULL DEFAULT 'English',
ADD COLUMN IF NOT EXISTS image_path VARCHAR(255),
ADD COLUMN IF NOT EXISTS detected_issue VARCHAR(255),
ADD COLUMN IF NOT EXISTS expert_id INT,
ADD COLUMN IF NOT EXISTS replied_at TIMESTAMP NULL;

-- Add role column to users table for admin functionality
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'Farmer';

-- Update existing users to have Farmer role
UPDATE users SET role = 'Farmer' WHERE role IS NULL OR role = '';

-- Delete existing admin user if exists
DELETE FROM users WHERE email = 'admin@krishimitra.com';

-- Insert admin user
INSERT INTO users (id, full_name, email, phone, password_hash, role) VALUES
(2, 'Admin User', 'admin@krishimitra.com', '8888888888', 'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f', 'Admin');

-- Create mandi_prices table for nearby mandi and best mandi features
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

-- Insert sample mandi prices data
INSERT INTO mandi_prices (state, district, market_name, commodity, variety, arrival_date, min_price, max_price, modal_price, yesterday_price, latitude, longitude) VALUES
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Tomato', 'Local', CURDATE(), 1800.00, 2200.00, 1950.00, 1850.00, 18.5204, 73.8567),
('Maharashtra', 'Nashik', 'Nashik Mandi', 'Tomato', 'Local', CURDATE(), 1750.00, 2100.00, 1900.00, 1820.00, 19.9975, 73.7898),
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Onion', 'Red', CURDATE(), 1200.00, 1500.00, 1350.00, 1300.00, 18.5204, 73.8567),
('Maharashtra', 'Nashik', 'Nashik Mandi', 'Onion', 'Red', CURDATE(), 1150.00, 1450.00, 1300.00, 1250.00, 19.9975, 73.7898),
('Maharashtra', 'Pune', 'Agricultural Produce Market Committee', 'Wheat', 'Lokwan', CURDATE(), 2300.00, 2600.00, 2450.00, 2400.00, 18.5204, 73.8567),
('Maharashtra', 'Nagpur', 'Nagpur Mandi', 'Cotton', 'Long Staple', CURDATE(), 6200.00, 6800.00, 6500.00, 6400.00, 21.1458, 79.0882);

-- Create expert_replies table for expert chat feature
CREATE TABLE IF NOT EXISTS expert_replies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  query_id INT NOT NULL,
  expert_id INT NOT NULL,
  reply_text TEXT NOT NULL,
  reply_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (query_id) REFERENCES farmer_queries(id) ON DELETE CASCADE
);

-- Create faqs table for FAQ system
CREATE TABLE IF NOT EXISTS faqs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category VARCHAR(100) NOT NULL,
  question VARCHAR(255) NOT NULL,
  answer TEXT NOT NULL,
  language VARCHAR(30) NOT NULL DEFAULT 'English',
  views INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample FAQ data
INSERT INTO faqs (category, question, answer, language) VALUES
('Crop Diseases', 'What are the common signs of tomato leaf curl?', 'Tomato leaf curl is characterized by upward curling of leaves, yellowing, and stunted growth. It is caused by whitefly transmission of the virus. Use yellow sticky traps and remove affected plants.', 'English'),
('Irrigation', 'How often should I water my crops in summer?', 'In summer, most crops need watering every 2-3 days. Early morning or late evening irrigation is best to reduce evaporation. Check soil moisture before watering.', 'English'),
('Fertilizers', 'When should I apply nitrogen fertilizer?', 'Nitrogen should be applied in split doses - basal application at sowing, and top dressing during critical growth stages like tillering or flowering. Avoid excess nitrogen as it promotes vegetative growth over yield.', 'English'),
('Pest Control', 'How can I control aphids naturally?', 'Use neem oil spray, introduce ladybugs, or use a strong water spray to dislodge them. Avoid over-fertilizing with nitrogen as it attracts aphids.', 'English'),
('Market', 'What is the best time to sell crops?', 'Sell when prices are high, typically during scarcity periods. Monitor mandi prices regularly and avoid selling immediately after harvest when supply is high and prices are low.', 'English');

-- Create disease_detections table for disease detection feature
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
