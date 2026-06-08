# Krishi Mitra

A one stop solution for farmers.

Java Servlet, JSP, Maven, Tomcat, and MySQL project.

## Pages

- Login
- Register
- Dashboard
- Live Crop Recommendation
- Location Based Live Weather Report
- Market Price
- Government Scheme
- Query Management

## Database Setup

1. Open MySQL Workbench.
2. Run `database/schema.sql`.
3. Edit `src/main/resources/db.properties` if your MySQL username or password is different.

## Run

```bash
mvn clean package
```

Deploy `target/krishi-mitra.war` to Tomcat 10.1.

Live crop recommendation and live weather report require internet access on the Tomcat server.

