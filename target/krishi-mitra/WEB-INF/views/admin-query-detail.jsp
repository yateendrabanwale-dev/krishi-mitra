<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<% request.setAttribute("pageTitle", "Query Details"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .query-detail {
    background: #f5f8ef;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 20px;
  }
  .query-detail h3 {
    margin-top: 0;
    color: #2f7d46;
  }
  .query-info {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    margin-bottom: 16px;
  }
  .query-info label {
    font-weight: 600;
    color: #555;
  }
  .query-message {
    background: white;
    padding: 16px;
    border-radius: 4px;
    margin-top: 12px;
    line-height: 1.6;
  }
  .existing-replies {
    margin-top: 20px;
  }
  .existing-reply {
    background: #f0f7f0;
    border-left: 4px solid #2f7d46;
    padding: 16px;
    margin-bottom: 12px;
    border-radius: 4px;
  }
  .existing-reply-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    font-weight: 600;
  }
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>Query Details</h2>
      <p class="muted">View query and expert replies</p>
    </div>
    <div>
      <a href="${pageContext.request.contextPath}/admin-queries" class="btn">Back to Queries</a>
      <a href="${pageContext.request.contextPath}/admin-queries?action=reply&id=<%= request.getAttribute("queryId") %>" class="btn" style="margin-left: 8px;">Reply</a>
    </div>
  </div>

  <%
    Map<String, Object> query = (Map<String, Object>) request.getAttribute("query");
    if (query != null) {
  %>
  <div class="query-detail">
    <h3><%= query.get("subject") %></h3>
    <div class="query-info">
      <div>
        <label>Farmer:</label>
        <%= query.get("full_name") %>
      </div>
      <div>
        <label>Email:</label>
        <%= query.get("email") %>
      </div>
      <div>
        <label>Type:</label>
        <%= query.get("query_type") %>
      </div>
      <div>
        <label>Language:</label>
        <%= query.get("language") %>
      </div>
      <div>
        <label>Status:</label>
        <%= query.get("status") %>
      </div>
      <div>
        <label>Date:</label>
        <%= query.get("created_at") %>
      </div>
    </div>
    <div class="query-message">
      <label>Message:</label>
      <%= query.get("message") %>
    </div>
    <% if (query.get("detected_issue") != null) { %>
    <div style="margin-top: 12px;">
      <label>Disease Detected:</label>
      <strong><%= query.get("detected_issue") %></strong>
    </div>
    <% } %>
    <% if (query.get("image_path") != null) { %>
    <div style="margin-top: 12px;">
      <label>Attached Image:</label>
      <br>
      <img src="${pageContext.request.contextPath}/<%= query.get("image_path") %>" alt="Uploaded image" style="max-width: 300px; border-radius: 4px; margin-top: 8px;">
    </div>
    <% } %>
  </div>

  <%
    java.util.List<Map<String, Object>> replies = (java.util.List<Map<String, Object>>) request.getAttribute("replies");
    if (replies != null && !replies.isEmpty()) {
  %>
  <div class="existing-replies">
    <h3>Expert Replies</h3>
    <% for (Map<String, Object> reply : replies) { %>
    <div class="existing-reply">
      <div class="existing-reply-header">
        <span>Expert ID: <%= reply.get("expert_id") %></span>
        <small><%= reply.get("reply_date") %></small>
      </div>
      <div><%= reply.get("reply_text") %></div>
    </div>
    <% } %>
  </div>
  <% } else { %>
  <div class="existing-replies">
    <p>No replies yet.</p>
  </div>
  <% } %>

  <% } else { %>
  <p>Query not found.</p>
  <% } %>
</section>

<%@ include file="includes/footer.jspf" %>
