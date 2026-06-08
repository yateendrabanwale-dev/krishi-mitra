<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "Manage Queries"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .query-actions {
    display: flex;
    gap: 8px;
  }
  .query-actions button {
    padding: 6px 12px;
    font-size: 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  .btn-reply {
    background: #2f7d46;
    color: white;
  }
  .btn-view {
    background: #6c757d;
    color: white;
  }
  .status-badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
  }
  .status-pending {
    background: #fff3cd;
    color: #856404;
  }
  .status-answered {
    background: #d4edda;
    color: #155724;
  }
  .filter-section {
    display: flex;
    gap: 12px;
    margin-bottom: 20px;
    padding: 16px;
    background: #f5f8ef;
    border-radius: 8px;
  }
  .filter-section select,
  .filter-section input {
    padding: 8px;
    border: 1px solid #dce5d8;
    border-radius: 4px;
  }
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Manage Farmer Queries</h2>
      <p class="muted">View and reply to farmer queries</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn">Back to Dashboard</a>
  </div>

  <div class="filter-section">
    <select id="statusFilter" onchange="filterQueries()">
      <option value="">All Status</option>
      <option value="Pending">Pending</option>
      <option value="Answered">Answered</option>
    </select>
    <select id="typeFilter" onchange="filterQueries()">
      <option value="">All Types</option>
      <option value="Text">Text</option>
      <option value="Voice">Voice</option>
      <option value="Image">Image</option>
    </select>
  </div>

  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>ID</th>
        <th>Subject</th>
        <th>Farmer</th>
        <th>Type</th>
        <th>Language</th>
        <th>Status</th>
        <th>Date</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Map<String, Object>> queries = (List<Map<String, Object>>) request.getAttribute("queries");
        if (queries != null && !queries.isEmpty()) {
          for (Map<String, Object> query : queries) {
            String status = (String) query.get("status");
            String statusClass = status.equals("Answered") ? "status-answered" : "status-pending";
      %>
      <tr data-status="<%= status %>" data-type="<%= query.get("query_type") %>">
        <td><%= query.get("id") %></td>
        <td><strong><%= query.get("subject") %></strong></td>
        <td><%= query.get("full_name") %></td>
        <td><%= query.get("query_type") %></td>
        <td><%= query.get("language") %></td>
        <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
        <td><%= query.get("created_at") %></td>
        <td class="query-actions">
          <button class="btn-reply" onclick="replyToQuery(<%= query.get("id") %>)">Reply</button>
          <button class="btn-view" onclick="viewQuery(<%= query.get("id") %>)">View</button>
        </td>
      </tr>
      <% }} else { %>
      <tr>
        <td colspan="8" style="text-align: center; padding: 20px;">No queries found.</td>
      </tr>
      <% } %>
      </tbody>
    </table>
  </div>
</section>

<script>
  function replyToQuery(queryId) {
    window.location.href = '${pageContext.request.contextPath}/admin-queries?action=reply&id=' + queryId;
  }

  function viewQuery(queryId) {
    window.location.href = '${pageContext.request.contextPath}/admin-queries?action=view&id=' + queryId;
  }

  function filterQueries() {
    const statusFilter = document.getElementById('statusFilter').value;
    const typeFilter = document.getElementById('typeFilter').value;
    
    const rows = document.querySelectorAll('tbody tr');
    rows.forEach(row => {
      const rowStatus = row.getAttribute('data-status');
      const rowType = row.getAttribute('data-type');
      
      const statusMatch = statusFilter === '' || rowStatus === statusFilter;
      const typeMatch = typeFilter === '' || rowType === typeFilter;
      
      row.style.display = statusMatch && typeMatch ? '' : 'none';
    });
  }
</script>

<%@ include file="includes/footer.jspf" %>
