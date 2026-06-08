<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Register | Krishi Mitra</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<main class="auth-page">
  <section class="auth-card">
    <h1 class="brand-title">Create Account</h1>
    <p class="muted">Register farmer details to start using the system.</p>

    <% if (request.getAttribute("error") != null) { %>
      <div class="message error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form class="form-stack" method="post" action="${pageContext.request.contextPath}/register">
      <label>Full name
        <input type="text" name="fullName" required>
      </label>
      <label>Email
        <input type="email" name="email" required>
      </label>
      <label>Phone
        <input type="text" name="phone">
      </label>
      <label>Password
        <input type="password" name="password" required>
      </label>
      <button class="btn" type="submit">Register</button>
    </form>
    <p class="muted">Already registered? <a href="${pageContext.request.contextPath}/login">Login</a></p>
  </section>
</main>
</body>
</html>
