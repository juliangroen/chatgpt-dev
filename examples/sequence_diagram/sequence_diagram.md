# Deployment Request API

## User Story
As a DevOps engineer, I want to be able to submit a deployment request to an API that creates the request in a database for further processing. If the request already exists, I want to receive a notification that the request has already been created. This will allow me to streamline the deployment process and ensure that all requests are properly tracked and processed.

## Sequence Diagram
```mermaid
sequenceDiagram
DevOps Engineer->>API: Submit Deployment Request
API->>Database: Check if Deployment Request exists

alt Deployment Request does not exist
Database-->>API: Deployment Request does not exist
API->>Database: Create Deployment Request
Database-->>API: Deployment Request created
API-->>DevOps Engineer: Deployment Request created successfully
end

alt Deployment Request exists
Database-->>API: Deployment Request exists
API-->>DevOps Engineer: Deployment Request already exists
end
