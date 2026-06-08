<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% request.setAttribute("pageTitle", "Dashboard"); %>
<%@ include file="includes/header.jspf" %>

<section class="hero">
  <div class="panel">
    <h2>Farm Decision Center</h2>
    <p class="muted">Krishi Mitra is a one stop solution for farmers to check live location, soil and weather based crop recommendations, market price details, government schemes, and farmer queries.</p>
    <a class="btn" href="${pageContext.request.contextPath}/crop-recommendation">Start crop planning</a>
  </div>
  <div class="field-art" aria-label="Farm field illustration"></div>
</section>

<section class="metrics">
  <article class="metric-card">
    <span>Crop recommendation</span>
    <strong><%= request.getAttribute("cropCount") == null ? 0 : request.getAttribute("cropCount") %></strong>
  </article>
  <article class="metric-card">
    <span>Weather report</span>
    <strong><%= request.getAttribute("weatherCount") == null ? 0 : request.getAttribute("weatherCount") %></strong>
  </article>
  <article class="metric-card">
    <span>Market prices</span>
    <strong><%= request.getAttribute("marketCount") == null ? 0 : request.getAttribute("marketCount") %></strong>
  </article>
  <article class="metric-card">
    <span>Schemes</span>
    <strong><%= request.getAttribute("schemeCount") == null ? 0 : request.getAttribute("schemeCount") %></strong>
  </article>
</section>

<%@ include file="includes/footer.jspf" %>
