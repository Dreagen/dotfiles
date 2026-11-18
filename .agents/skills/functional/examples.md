# Functional Programming Examples

Supporting file for the `functional` skill.

**Map** \
`Map` is used when you want to transform the return type inside the Result, the function you pass to `Map` returns the new Type **not** a Result of the new type. For this see `Bind`.

**Bind** \
`Bind` is also used when you want to transform the return type inside the Result, but the function you pass to `Bind` itself returns a `Result`.

**TapOk** \
`TapOk` is used to run a function when the `Result` is Ok, the function you pass to `TapOk` returns void. This can be used for running side effects like logging.

**TapError** \
`TapError` is used to run a function when the `Result` is Error, the function you pass to `TapError` returns void. This can be used for running side effects like logging.

**Match** \
`Match` is used to run a function when the `Result` is Ok and another function when the `Result` is Error. The functions you pass to `Match` must return the same type.

**ToOkOr** \
`ToOkOr` is used to transform an `Option` into a `Result`, the function you pass to `ToOkOr` returns the error you want to use in case the `Option` is `None`.

**Example using Bind, Map, TapOk, TapError, Match and ToOkOr**
```csharp
_service.DoSomethingThatReturnsOptionOfString() // returns Option<string>
    .ToOkOr(() => new ApplicationError("Option was None")) // This is now a Result<string, ApplicationError>
    .Bind(value =>
    {
        if (value.Length > 10)
        {
            return new ApplicationError("Value is too big").AsErrorResult<NewType>();
        }

        return new NewType(value).AsOkResult();
    }) // This is now a Result<NewType, ApplicationError>
    .Map(newType => new AnotherNewType(newType.Value)) // This is now a Result<AnotherNewType, ApplicationError>
    .TapOk(_ => _logger.LogInformation("Result is ok!")) // This is still a Result<AnotherNewType, ApplicationError>
    .TapError(error => _logger.LogError("Something went wrong: {Message}", error.Message)) // This is still a Result<AnotherNewType, ApplicationError>
    .Match(
        ok => Results.Ok(ok.Value),
        error => Results.BadRequest(error.Message)
    ); // This is now an IResult
```

> In API endpoints that return a plain `200 OK`, prefer `.ToOkAsync()` over a manual `Match` (see the `functional` skill). Use `Match` when you need a different response shape.
