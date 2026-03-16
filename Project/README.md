# MusicWeb_ASM_PRJ301
Java web application using Servlet, JSP, Maven, and Hibernate for database CRUD operations.
# Music Web App

## Overview
A **team-based music web application** built with **Java Servlet, JSP, Maven, and Hibernate**.  
Users can **browse songs, manage playlists, and perform CRUD operations** on music data.  
The project follows the **MVC design pattern**.

## Technologies
- **Backend:** Java Servlet & JSP  
- **Project Management:** Maven  
- **Database ORM:** Hibernate  
- **Database:**  SQL Server  
- **Frontend:** HTML, CSS, JavaScript  

## Project Structure

## Railway Deploy

This project can be deployed to Railway with the `Dockerfile` at the project root.

Required environment variables:
- `DATABASE_URL` or `JDBC_DATABASE_URL`
- `DB_USERNAME` and `DB_PASSWORD` if you do not use `DATABASE_URL`
- `OTP_MAIL_FROM`
- `OTP_MAIL_FROM_NAME`
- `OTP_MAIL_APP_PASSWORD`

Recommended Railway setup:
- Add a PostgreSQL service
- Reference `DATABASE_URL` from the Railway Postgres service
- Generate a public domain for the app service

Runtime notes:
- The Docker container deploys the app as `ROOT.war`, so Railway serves it at `/`
- Tomcat listens on Railway's provided `PORT`
