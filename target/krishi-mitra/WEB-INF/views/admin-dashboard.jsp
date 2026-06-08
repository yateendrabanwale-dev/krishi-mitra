<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "Admin Dashboard"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .admin-stats {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
  }
  .stat-card {
    background: linear-gradient(135deg, #2f7d46 0%, #215c34 100%);
    color: white;
    padding: 20px;
    border-radius: 8px;
    text-align: center;
  }
  .stat-card h3 {
    margin: 0 0 10px;
    font-size: 32px;
  }
  .stat-card p {
    margin: 0;
    opacity: 0.9;
  }
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
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Admin Dashboard</h2>
      <p class="muted">Manage queries and system administration</p>
    </div>
  </div>

  <div class="admin-stats">
    <div class="stat-card">
      <h3><%= request.getAttribute("totalQueries") != null ? request.getAttribute("totalQueries") : "0" %></h3>
      <p>Total Queries</p>
    </div>
    <div class="stat-card">
      <h3><%= request.getAttribute("pendingQueries") != null ? request.getAttribute("pendingQueries") : "0" %></h3>
      <p>Pending Queries</p>
    </div>
    <div class="stat-card">
      <h3><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></h3>
      <p>Total Users</p>
    </div>
    <div class="stat-card">
      <h3><%= request.getAttribute("totalFAQs") != null ? request.getAttribute("totalFAQs") : "0" %></h3>
      <p>FAQs</p>
    </div>
  </div>
</section>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Recent Farmer Queries</h2>
      <p class="muted">View and reply to farmer queries</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin-queries" class="btn">View All Queries</a>
  </div>
  <div class="table-wrap">
    <table>
      <thead>
      <tr>
        <th>Subject</th>
        <th>Farmer</th>
        <th>Type</th>
        <th>Status</th>
        <th>Date</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Map<String, Object>> queries = (List<Map<String, Object>>) request.getAttribute("recentQueries");
        if (queries != null && !queries.isEmpty()) {
          for (Map<String, Object> query : queries) {
            String status = (String) query.get("status");
            String statusClass = status.equals("Answered") ? "status-answered" : "status-pending";
      %>
      <tr>
        <td><strong><%= query.get("subject") %></strong></td>
        <td><%= query.get("full_name") %></td>
        <td><%= query.get("query_type") %></td>
        <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
        <td><%= query.get("created_at") %></td>
        <td class="query-actions">
          <button class="btn-reply" onclick="replyToQuery(<%= query.get("id") %>)">Reply</button>
          <button class="btn-view" onclick="viewQuery(<%= query.get("id") %>)">View</button>
        </td>
      </tr>
      <% }} else { %>
      <tr>
        <td colspan="6" style="text-align: center; padding: 20px;">No recent queries found.</td>
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
</script>

<%@ include file="includes/footer.jspf" %>
