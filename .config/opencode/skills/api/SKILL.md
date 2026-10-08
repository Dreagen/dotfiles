---
name: api
description: Rules for the Api layer (Api / Server projects) - minimal API endpoints, REST route and resource naming, sending MediatR requests, mapping Result to IResult, and DI registration in Program.cs (the sole composition root). Use when adding or changing endpoints, routes or service registration.
---

## Conventions
- Use minimal APIs where possible
- Only call Application layer via MediatR
- Keep API logic thin and free of business rules
- The API project is the **sole composition root** for the application.

## Endpoint Routing Conventions
- All endpoints must follow RESTful conventions.

## Resource Naming
- Resource names must be lowercase and pluralised, without using hyphens to split entity names
  ```csharp
  /api/investmentwrappers
  ```

## Command-Specific Subroutes
- Avoid RPC style naming for state changing operations, instead use RESTFUL conventions e.g.
  ```
  PUT /api/investmentwrappers/{id}/status
  ```

## Related skills
- `functional` - mapping `Result<T, ApplicationError>` to HTTP responses (`ToOkAsync`)
- `application` - the commands and queries endpoints send
