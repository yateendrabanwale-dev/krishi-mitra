<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "Live Market Prices"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .price-tabs {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    border-bottom: 1px solid #dce5d8;
    padding-bottom: 10px;
  }
  .price-tab {
    padding: 8px 16px;
    background: #e8f2e8;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 600;
    color: #215c34;
  }
  .price-tab.active {
    background: #2f7d46;
    color: white;
  }
  .price-section {
    display: none;
  }
  .price-section.active {
    display: block;
  }
  .trend-up {
    color: #2f7d46;
    font-weight: 600;
  }
  .trend-down {
    color: #b65f35;
    font-weight: 600;
  }
  .mandi-card {
    border: 1px solid #dce5d8;
    border-radius: 8px;
    padding: 16px;
    margin-bottom: 12px;
    background: #fbfdf9;
  }
  .mandi-card h4 {
    margin: 0 0 8px;
    color: #18221b;
  }
  .mandi-card .price-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  .mandi-card .price-info strong {
    font-size: 18px;
    color: #2f7d46;
  }
  .location-form {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
    margin-bottom: 20px;
    padding: 16px;
    background: #f5f8ef;
    border-radius: 8px;
  }
  .best-mandi {
    background: linear-gradient(135deg, #2f7d46 0%, #215c34 100%);
    color: white;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 20px;
  }
  .best-mandi h3 {
    margin: 0 0 10px;
  }
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Market Prices</h2>
      <p class="muted">Real-time crop prices with trends and mandi recommendations</p>
    </div>
  </div>

  <div class="price-tabs">
    <button class="price-tab active" onclick="showSection('live-prices')">Live Prices</button>
    <button class="price-tab" onclick="showSection('nearby-mandi')">Nearby Mandi</button>
    <button class="price-tab" onclick="showSection('best-mandi')">Best Mandi</button>
  </div>

  <!-- Live Prices Section -->
  <div id="live-prices" class="price-section active">
    <div class="table-wrap">
      <table>
        <thead>
        <tr>
          <th>Crop</th>
          <th>Market</th>
          <th>Price per quintal</th>
          <th>Date</th>
        </tr>
        </thead>
        <tbody>
        <%
          List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("rows");
          if (rows != null) {
            for (Map<String, Object> row : rows) {
        %>
        <tr>
          <td><%= row.get("crop_name") %></td>
          <td><%= row.get("market_name") %></td>
          <td><strong>Rs. <%= row.get("price_per_quintal") %></strong></td>
          <td><%= row.get("price_date") %></td>
        </tr>
        <% }} %>
        </tbody>
      </table>
    </div>
  </div>

  <!-- Nearby Mandi Section -->
  <div id="nearby-mandi" class="price-section">
    <form action="mandi-prices" method="get" class="location-form">
      <input type="hidden" name="action" value="nearby">
      <label>
        Latitude
        <input type="number" step="any" name="latitude" placeholder="e.g., 18.5204" required>
      </label>
      <label>
        Longitude
        <input type="number" step="any" name="longitude" placeholder="e.g., 73.8567" required>
      </label>
      <label>
        Crop (optional)
        <select name="commodity">
          <option value="">All crops</option>
          <option>Tomato</option>
          <option>Onion</option>
          <option>Wheat</option>
          <option>Rice</option>
          <option>Cotton</option>
          <option>Maize</option>
        </select>
      </label>
      <button type="submit" style="grid-column: span 3;">Find Nearby Mandi</button>
    </form>
    <button onclick="getCurrentLocation()" style="margin-bottom: 16px;">📍 Use My Current Location</button>
    <div id="nearby-results">
      <p class="muted">Enter your location or use current location to find nearby mandi prices.</p>
    </div>
  </div>

  <!-- Best Mandi Section -->
  <div id="best-mandi" class="price-section">
    <form action="mandi-prices" method="get" class="location-form">
      <input type="hidden" name="action" value="best">
      <label>
        Latitude
        <input type="number" step="any" name="latitude" placeholder="e.g., 18.5204" required>
      </label>
      <label>
        Longitude
        <input type="number" step="any" name="longitude" placeholder="e.g., 73.8567" required>
      </label>
      <label>
        Crop
        <select name="commodity" required>
          <option value="">Select crop</option>
          <option>Tomato</option>
          <option>Onion</option>
          <option>Wheat</option>
          <option>Rice</option>
          <option>Cotton</option>
          <option>Maize</option>
        </select>
      </label>
      <button type="submit" style="grid-column: span 3;">Find Best Mandi to Sell</button>
    </form>
    <button onclick="getCurrentLocation()" style="margin-bottom: 16px;">📍 Use My Current Location</button>
    <div id="best-results">
      <p class="muted">Enter your location and crop to find the best mandi for selling.</p>
    </div>
  </div>
</section>

<script>
  function showSection(sectionId) {
    document.querySelectorAll('.price-section').forEach(section => {
      section.classList.remove('active');
    });
    document.querySelectorAll('.price-tab').forEach(tab => {
      tab.classList.remove('active');
    });
    document.getElementById(sectionId).classList.add('active');
    event.target.classList.add('active');
  }

  function getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        function(position) {
          const lat = position.coords.latitude;
          const lon = position.coords.longitude;
          document.querySelectorAll('input[name="latitude"]').forEach(input => {
            input.value = lat;
          });
          document.querySelectorAll('input[name="longitude"]').forEach(input => {
            input.value = lon;
          });
          alert('Location captured: ' + lat.toFixed(4) + ', ' + lon.toFixed(4));
        },
        function(error) {
          alert('Unable to get location: ' + error.message);
        }
      );
    } else {
      alert('Geolocation not supported by your browser.');
    }
  }
</script>

<%@ include file="includes/footer.jspf" %>
