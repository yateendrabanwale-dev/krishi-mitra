<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.farmerassistant.service.CropRecommendationService,com.farmerassistant.model.CropRecommendation,java.util.List" %>
<% request.setAttribute("pageTitle", "Live Crop Recommendation"); %>
<%@ include file="includes/header.jspf" %>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Location, soil and weather based recommendation</h2>
      <p class="muted">Enter farm details to get crop suggestions using live weather data.</p>
    </div>
  </div>

  <form class="search-row" method="get" action="${pageContext.request.contextPath}/crop-recommendation">
    <label>Location
      <input type="text" name="location" value="<%= request.getAttribute("location") == null ? "" : request.getAttribute("location") %>" placeholder="Enter city or district" required>
    </label>
    <label>Soil type
      <select name="soil">
        <option <%= "Loamy".equals(request.getAttribute("soil")) ? "selected" : "" %>>Loamy</option>
        <option <%= "Clay".equals(request.getAttribute("soil")) ? "selected" : "" %>>Clay</option>
        <option <%= "Sandy".equals(request.getAttribute("soil")) ? "selected" : "" %>>Sandy</option>
        <option <%= "Black soil".equals(request.getAttribute("soil")) ? "selected" : "" %>>Black soil</option>
      </select>
    </label>
    <label>Season
      <select name="season">
        <option <%= "Auto".equals(request.getAttribute("season")) ? "selected" : "" %>>Auto</option>
        <option <%= "Kharif".equals(request.getAttribute("season")) ? "selected" : "" %>>Kharif</option>
        <option <%= "Rabi".equals(request.getAttribute("season")) ? "selected" : "" %>>Rabi</option>
        <option <%= "Summer".equals(request.getAttribute("season")) ? "selected" : "" %>>Summer</option>
      </select>
    </label>
    <label>Land size in acres
      <input type="number" min="0" step="0.1" name="landSize" value="<%= request.getAttribute("landSize") == null ? "" : request.getAttribute("landSize") %>" placeholder="2">
    </label>
    <button class="btn" type="submit">Get recommendation</button>
  </form>
</section>

<%
  CropRecommendationService.RecommendationResult result =
      (CropRecommendationService.RecommendationResult) request.getAttribute("result");
  if (result != null) {
%>
<section class="metrics">
  <article class="metric-card">
    <span>Location</span>
    <strong><%= result.getWeatherReport().getLocationName() %></strong>
  </article>
  <article class="metric-card">
    <span>Temperature</span>
    <strong><%= result.getWeatherReport().getTemperature() %> C</strong>
  </article>
  <article class="metric-card">
    <span>Humidity</span>
    <strong><%= result.getWeatherReport().getHumidity() %>%</strong>
  </article>
  <article class="metric-card">
    <span>Rain</span>
    <strong><%= result.getWeatherReport().getPrecipitation() %> mm</strong>
  </article>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Recommended crops</h2>
      <p class="muted"><%= result.getLandAdvice() %></p>
    </div>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>Crop</th>
        <th>Suitability</th>
        <th>Season</th>
        <th>Water need</th>
        <th>Fertilizer advice</th>
        <th>Reason</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<CropRecommendation> recommendations = result.getRecommendations();
        for (CropRecommendation item : recommendations) {
      %>
      <tr>
        <td><%= item.getCropName() %></td>
        <td><span class="badge"><%= item.getSuitability() %></span></td>
        <td><%= item.getSeason() %></td>
        <td><%= item.getWaterNeed() %></td>
        <td><%= item.getFertilizerAdvice() %></td>
        <td><%= item.getReason() %></td>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</section>
<% } %>

<%@ include file="includes/footer.jspf" %>
