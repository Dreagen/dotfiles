---
name: coding-standards
description: Coding standards covering domain-driven design, explicit types, use when writing or reviewing code.
compatibility: opencode
---

## What I do

- Give coding standards in different languages

## When to use

Use writing code

## CSharp
- The majority of our projects (apart from legacy ones) are built using domain driven design, we strive to keep the business logic in the domain layer and the orchestration logic in the application layer
- Use explicit type declarations for variables, not var.
- Most projects will use the nuget packages Dataglide.Functional and Dataglide.FunctionalExtensions, these provide functional extension methods such as Map, Bind and Match examples below but investigate the package if you need to understand what's available

### Functional extension examples
Note there are Async overloads of most extension methods.

**Map** \
`Map` is used when you want to transform the return type inside the Result, the function you pass to `Map` returns the new Type **not** a Result of the new type. For this see `Bind`.
```csharp
    _service.DoSomethingThatReturnsResult()
        .Map(result => new NewType(result.Value));
```

**Bind** \
`Bind` is also used when you want to transform the return type inside the Result, but the function you pass to `Bind` itself returns a `Result`.
```csharp
    _service.DoSomethingThatReturnsResult()
        .Bind(result => 
        {
            if (result.Value > 10) 
            {
                return new ApplicationError("Value is too big").AsErrorResult<NewType>();
            }

            new NewType(result.Value).AsOkResult();
        });
```

**TapOk** \
`TapOk` is used to run a function when the `Result` is Ok, the function you pass to `TapOk` returns void. This can be used for running side effects like logging.
```csharp
    _service.DoSomethingThatReturnsResult()
        .TapOk(result => _logger.LogInformation("Result is ok!"));
```

**TapError** \
`TapError` is used to run a function when the `Result` is Error, the function you pass to `TapError` returns void. This can be used for running side effects like logging.
```csharp
    _service.DoSomethingThatReturnsResult()
        .TapOk(result => _logger.LogError("Something went wrong!"));
```

**Match** \
`Match` is used to run a function when the `Result` is Ok and another function when the `Result` is Error. The functions you pass to `Match` must return the same type.
```csharp
    _service.DoSomethingThatReturnsResult()
        .Match(
            ok => new NewType(ok.Value),
            error => new NewType(error.Message)
        );
```
**ToOkOr** \
`ToOkOr` is used to transform an `Option` into a `Result`, the function you pass to `ToOkOr` returns the error you want to use in case the `Option` is `None`.
```csharp
    _service.DoSomethingThatReturnsOptionOfString() // returns Option<string>
        .ToOkOr(() => new ApplicationError("Option was None")); // This is now a Result<string, ApplicationError>
```

**Example using Bind, Map, TapOk, TapError, Match and ToOkOr**
```csharp
    _service.DoSomethingThatReturnsOptionOfString() // returns Option<string>
        .ToOkOr(() => new ApplicationError("Option was None")) // This is now a Result<string, ApplicationError>
        .Bind(result => 
        {
            if (result.Length > 10) 
            {
                return new ApplicationError("Value is too big").AsErrorResult<NewType>();
            }

            new NewType(result).AsOkResult();
        }) // This is now a Result<NewType, ApplicationError>
        .Map(result => new AnotherNewType(result.Value)) // This is now a Result<AnotherNewType, ApplicationError>
        .TapOk(result => _logger.LogInformation("Result is ok!")) // This is still a Result<AnotherNewType, ApplicationError>
        .TapError(result => _logger.LogError("Something went wrong!")) // This is still a Result<AnotherNewType, ApplicationError>
        .Match(
            result => new Results.Ok(result.Value),
            error => new Results.BadRequest(error.Message)
        ); // This is now an IResult
```
