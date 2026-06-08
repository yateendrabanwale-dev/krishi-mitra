<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.util.Map" %>
<% request.setAttribute("pageTitle", "FAQ - Common Farming Problems"); %>
<%@ include file="includes/header.jspf" %>

<style>
  .faq-category-filter {
    display: flex;
    gap: 10px;
    margin-bottom: 20px;
    flex-wrap: wrap;
  }
  .category-btn {
    padding: 8px 16px;
    background: #e8f2e8;
    border: 1px solid #dce5d8;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 600;
    color: #215c34;
  }
  .category-btn.active {
    background: #2f7d46;
    color: white;
    border-color: #2f7d46;
  }
  .faq-item {
    border: 1px solid #dce5d8;
    border-radius: 8px;
    margin-bottom: 16px;
    background: #fbfdf9;
    overflow: hidden;
  }
  .faq-question {
    padding: 16px;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f5f8ef;
    font-weight: 600;
  }
  .faq-question:hover {
    background: #e8f2e8;
  }
  .faq-category-tag {
    background: #2f7d46;
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    margin-right: 8px;
  }
  .faq-answer {
    padding: 16px;
    display: none;
    line-height: 1.6;
    color: #334334;
  }
  .faq-answer.show {
    display: block;
  }
  .faq-toggle {
    font-size: 20px;
    transition: transform 0.3s;
  }
  .faq-toggle.rotate {
    transform: rotate(180deg);
  }
  .search-box {
    margin-bottom: 20px;
  }
  .search-box input {
    width: 100%;
    padding: 12px;
    border: 1px solid #dce5d8;
    border-radius: 8px;
    font-size: 16px;
  }
</style>

<section class="panel">
  <div class="panel-head">
    <div>
      <h2>FAQ - Common Farming Problems</h2>
      <p class="muted">Find answers to frequently asked questions about farming</p>
    </div>
  </div>

  <div class="search-box">
    <input type="text" id="faqSearch" placeholder="Search FAQs..." onkeyup="filterFAQs()">
  </div>

  <div class="faq-category-filter">
    <button class="category-btn active" onclick="filterByCategory('')">All Categories</button>
    <button class="category-btn" onclick="filterByCategory('Crop Diseases')">Crop Diseases</button>
    <button class="category-btn" onclick="filterByCategory('Irrigation')">Irrigation</button>
    <button class="category-btn" onclick="filterByCategory('Fertilizers')">Fertilizers</button>
    <button class="category-btn" onclick="filterByCategory('Pest Control')">Pest Control</button>
    <button class="category-btn" onclick="filterByCategory('Market')">Market</button>
  </div>

  <div id="faqList">
    <%
      List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("rows");
      if (rows != null) {
        for (Map<String, Object> row : rows) {
    %>
    <div class="faq-item" data-category="<%= row.get("category") %>">
      <div class="faq-question" onclick="toggleFAQ(this)">
        <div>
          <span class="faq-category-tag"><%= row.get("category") %></span>
          <%= row.get("question") %>
        </div>
        <span class="faq-toggle">▼</span>
      </div>
      <div class="faq-answer">
        <%= row.get("answer") %>
      </div>
    </div>
    <% }} %>
  </div>
</section>

<script>
  function toggleFAQ(element) {
    const answer = element.nextElementSibling;
    const toggle = element.querySelector('.faq-toggle');
    
    answer.classList.toggle('show');
    toggle.classList.toggle('rotate');
  }

  function filterByCategory(category) {
    // Update button states
    document.querySelectorAll('.category-btn').forEach(btn => {
      btn.classList.remove('active');
    });
    event.target.classList.add('active');

    // Filter FAQ items
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
      if (category === '' || item.dataset.category === category) {
        item.style.display = 'block';
      } else {
        item.style.display = 'none';
      }
    });
  }

  function filterFAQs() {
    const searchTerm = document.getElementById('faqSearch').value.toLowerCase();
    const faqItems = document.querySelectorAll('.faq-item');

    faqItems.forEach(item => {
      const question = item.querySelector('.faq-question').textContent.toLowerCase();
      const answer = item.querySelector('.faq-answer').textContent.toLowerCase();
      
      if (question.includes(searchTerm) || answer.includes(searchTerm)) {
        item.style.display = 'block';
      } else {
        item.style.display = 'none';
      }
    });
  }
</script>

<%@ include file="includes/footer.jspf" %>
