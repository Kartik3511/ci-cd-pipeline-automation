# CI/CD Pipeline Automation

This project demonstrates an end-to-end CI/CD pipeline that automates building, testing, containerization, and deployment of a Java Spring Boot application using GitHub Actions and Docker.

# Problem Statement
Manual build and deployment processes are slow, error-prone, and inconsistent. This project automates the entire software delivery lifecycle to ensure faster, reliable, and repeatable deployments.

# Architecture Overview
Developer Pushes Code
        ↓
GitHub Actions (CI)
        ↓
Build & Test (Maven)
        ↓
Docker Image Build
        ↓
Push to Docker Hub
        ↓
Automatic Deployment

# Tech Stack
-Java 17
-Spring Boot
-Maven
-Git & GitHub
-GitHub Actions
-Docker
-Docker Hub

# CI/CD Workflow
-Pipeline triggers on push to main

-Maven builds and runs tests

-Docker image is built and pushed

-Latest image is deployed automatically

# How to Run Locally

 mvn spring-boot:run
 GET /health

# Key Features 
-Automated build & test

-Containerized application

-Secure secrets handling

-Automatic deployment

-Rollback using image tags

## Future Enhancements

- Extend deployment to Kubernetes for container orchestration, scalability, and rolling updates.
- Support multiple environments (dev, staging, production) with environment-specific pipelines.
- Improve rollback strategy using versioned Docker image tags and automated redeployment.
- Add basic monitoring and alerting to track application health and deployment status.

