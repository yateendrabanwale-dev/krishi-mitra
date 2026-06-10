<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login | Krishi Mitra</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<main class="auth-page">
  <section class="auth-card">
    <h1 class="brand-title">Krishi Mitra</h1>
    <p class="muted">A one stop solution for farmers. Login to manage crop advice, live weather, market prices, schemes, and queries.</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="message error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
      <div class="message success"><%= request.getAttribute("success") %></div>
    <% } %>

    <form class="form-stack" method="post" action="${pageContext.request.contextPath}/login">
      <label>Email
        <input type="email" name="email" required autocomplete="off">
      </label>
      <label>Password
        <input type="password" name="password" required autocomplete="new-password">
      </label>
      <button class="btn" type="submit">Login</button>
    </form>
    <p class="muted">New farmer? <a href="${pageContext.request.contextPath}/register">Create account</a></p>
  </section>
</main>
</body>
</html>
