<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "Government Scheme"); %>
<%@ include file="includes/header.jspf" %>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Government scheme list</h2>
      <p class="muted">Scheme details are loaded from the government_schemes table.</p>
    </div>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>Scheme</th>
        <th>Eligibility</th>
        <th>Benefits</th>
        <th>Apply</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("rows");
        if (rows != null) {
          for (Map<String, Object> row : rows) {
      %>
      <tr>
        <td><%= row.get("scheme_name") %></td>
        <td><%= row.get("eligibility") %></td>
        <td><%= row.get("benefits") %></td>
        <td><a class="btn secondary" href="<%= row.get("apply_link") %>" target="_blank" rel="noreferrer">Open</a></td>
      </tr>
      <% }} %>
      </tbody>
    </table>
  </div>
</section>

<%@ include file="includes/footer.jspf" %>
