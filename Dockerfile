# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Install Maven
RUN apt-get update && apt-get install -y maven

# Set the working directory in the container
WORKDIR /app

# Copy the project files
COPY pom.xml .
COPY src ./src
COPY checkstyle.xml .

# Copy common_example.properties to the container
COPY src/main/environment/common_example.properties /app/src/main/environment/common_example.properties

# Copy entrypoint script and give execute permissions
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Build the project
RUN mvn clean install -DENV_VAR=local

# Expose the application port
EXPOSE 8092

# Pass ENV_VAR to the application
ARG ENV_VAR=local
ENV ENV_VAR=${ENV_VAR}

# Use entrypoint script (this ensures ENV_VAR is available)
ENTRYPOINT ["/entrypoint.sh"]
