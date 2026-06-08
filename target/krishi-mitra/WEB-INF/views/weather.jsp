<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.farmerassistant.model.WeatherReport" %>
<% request.setAttribute("pageTitle", "Location Based Live Weather Report"); %>
<%@ include file="includes/header.jspf" %>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Live weather by location</h2>
      <p class="muted">Enter a city or district to fetch current weather using live APIs.</p>
    </div>
  </div>

  <form class="search-row" method="get" action="${pageContext.request.contextPath}/weather">
    <label>Location
      <input type="text" name="location" value="<%= request.getAttribute("location") == null ? "" : request.getAttribute("location") %>" placeholder="Enter city or district" required>
    </label>
    <button class="btn" type="submit">Get live report</button>
  </form>

  <%
    WeatherReport report = (WeatherReport) request.getAttribute("report");
    if (report != null) {
  %>
  <section class="metrics">
    <article class="metric-card">
      <span>Temperature</span>
      <strong><%= report.getTemperature() %> C</strong>
    </article>
    <article class="metric-card">
      <span>Humidity</span>
      <strong><%= report.getHumidity() %>%</strong>
    </article>
    <article class="metric-card">
      <span>Rain</span>
      <strong><%= report.getPrecipitation() %> mm</strong>
    </article>
    <article class="metric-card">
      <span>Wind</span>
      <strong><%= report.getWindSpeed() %> km/h</strong>
    </article>
  </section>

  <div class="panel">
    <h2><%= report.getLocationName() %>, <%= report.getCountry() %></h2>
    <p><span class="badge"><%= report.getCondition() %></span></p>
    <p class="muted">Updated time: <%= report.getTime() %> | Coordinates: <%= report.getLatitude() %>, <%= report.getLongitude() %></p>
    <h2>Farming advice</h2>
    <p><%= report.getAdvice() %></p>
  </div>
  <% } %>
</section>

<%@ include file="includes/footer.jspf" %>
