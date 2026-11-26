---
name: functions
description: Rules for the Functions layer (Functions projects) - Azure Function triggers (Service Bus, timer, durable orchestrators), sending MediatR requests, and handling failed Results. Use when adding or changing a function or message handler.
---

# Functions Layer

## Conventions
- Functions are thin entry points like API endpoints: map the incoming message to a MediatR command/query, send it, handle the Result. No business rules.
- Only call the Application layer via `IMediator` / `ISender`.
- Convert message primitives to domain primitives (e.g. `ClientId.Create(...)`) when building the command.

## Handling Results
- Service Bus handlers (return `Task`): throw on error so the message is retried / dead-lettered. Use `TapError`, not `Match` with a dummy value:

  ```csharp
  Result<Void, ApplicationError> result = await mediator.Send(command);
  result.TapError(error => throw new InvalidOperationException($"... failed: {error.Error}"));
  ```

- Use `Match` only where the function must return a value (e.g. orchestrator/activity results).
- Never discard a returned `Result` without handling the error branch.

## Related skills
- `functional` - Result extension methods (`TapError`, `Match`)
- `application` - the commands and queries functions send
- `contracts` - enums used in messages
- `infrastructure` - new queues/topics need alerts
