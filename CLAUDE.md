# CLAUDE.md - BeneficiaryID-Generation-API

## Project Overview

BeneficiaryID-Generation-API is a Spring Boot microservice that generates unique beneficiary registration IDs for new beneficiaries in the AMRIT platform. It uses Quartz scheduling to pre-generate ID batches and provides an API to fetch available IDs.

## Tech Stack

- Java 17
- Spring Boot 3.2.2
- Spring Data JPA / Hibernate
- MySQL 8.0
- Redis (session management)
- Quartz Scheduler (batch ID generation)
- Maven (build tool)
- Swagger/OpenAPI (API documentation)
- Lombok
- WAR packaging (deploys to Wildfly)

## Build and Run

```bash
# Build
mvn clean install -DENV_VAR=local

# Run locally (start Redis first)
mvn spring-boot:run -DENV_VAR=local

# Package WAR
mvn -B package --file pom.xml -P <profile>   # profiles: dev, uat
```

### Configuration

- Copy `src/main/environment/bengen_example.properties` to `bengen_local.properties` and edit.
- Environment selected via `-DENV_VAR=<env>`.
- Swagger UI: `http://localhost:8092/swagger-ui.html`

## Package Structure

Base package: `com.iemr.common.bengen`

| Package | Description |
|---------|-------------|
| `controller` | REST endpoint for ID generation (`GenerateBeneficiaryController`) |
| `controller.version` | Version/health endpoint |
| `service` | Business logic for ID generation |
| `domain` | JPA entities: `BeneficiaryId`, `M_BeneficiaryRegidMapping`, `KeyStack`, `SaltStack` |
| `repo` | JPA repositories |
| `config` | Swagger config, interceptor config |
| `config.quartz` | Quartz scheduler configuration for batch generation |
| `utils` | Shared utilities (HTTP, Redis, validation, mapper, session, exception) |

## Key Classes

- **`BengenSlow.java`**: Main Spring Boot application entry point
- **`GenerateBeneficiaryController`**: Primary REST controller for ID generation
- **`Verhoeff.java`**: Implements Verhoeff checksum algorithm for ID validation
- **`Generator.java`**: Core ID generation logic

## Architecture Notes

- IDs are pre-generated in batches via Quartz scheduled jobs to ensure availability
- Verhoeff checksum algorithm is used to generate self-validating beneficiary IDs
- Redis stores session data; requires running Redis instance
- HTTP interceptor validates auth tokens against Common-API
- Small, focused microservice with a single responsibility

## CI/CD

- GitHub Actions: `sast.yml`, build workflows
- Checkstyle configuration in `checkstyle.xml`
- Dockerfile with `entrypoint.sh` for containerized deployment
