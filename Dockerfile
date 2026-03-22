# Multi-stage build for optimized image size
# Stage 1: Build stage (not used in CI/CD as we build with GitHub Actions, but useful for local builds)
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /build
COPY app/pom.xml .
COPY app/mvnw .
COPY app/mvnw.cmd .
COPY app/.mvn .mvn
# Download dependencies (cached layer)
RUN ./mvnw dependency:go-offline -B
# Copy source and build
COPY app/src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime stage
FROM eclipse-temurin:17-jre

# Set working directory
WORKDIR /app

# Copy the JAR from either the builder stage or CI build output
# In CI/CD, the JAR is already built, so this layer uses the pre-built artifact
COPY app/target/demo-*.jar app.jar

# Expose application port
EXPOSE 8080

# Add healthcheck for container orchestration
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

# Set environment variables (overridden at runtime)
ENV GOOGLE_VISION_API_KEY="" \
    USDA_API_KEY="" \
    PORT=8080

# Run the application with optimized JVM settings for containers
ENTRYPOINT ["java", \
    "-XX:+UseContainerSupport", \
    "-XX:MaxRAMPercentage=75.0", \
    "-Djava.security.egd=file:/dev/./urandom", \
    "-jar", "app.jar"]
