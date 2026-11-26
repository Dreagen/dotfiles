---
name: functional
description: How to use the Dataglide functional libraries (Dataglide.Functional, Dataglide.FunctionalExtensions) - Result<T, ApplicationError>, Option<T>, Void, Bind, Map, TapOk, TapError, Match, ToOkOr,ToOkOr, AsOkResult, ToOkAsync and their namespaces. Use when writing handlers, domain methods that can fail, endpoints that return a Result, or Function/message handlers that consume a Result.
---

# Functional Programming Style — Railway-Oriented Programming

## Overview

All Application layer command handlers must use **Railway-Oriented Programming (ROP)** via the `Result<T, E>` and `Option<T>` monadic types.

---

## Required Namespaces

Functional types and extension methods are split across two packages, with a third used only at the API layer.

| Package | Project layer |
|---|---|
| `Dataglide.Functional` | Domain |
| `Dataglide.FunctionalExtensions` | Domain |
| `Dataglide.FunctionalExtensions.Server` | Api only |

| What you need | Namespace |
|---|---|
| `Result<T,E>`, `Option<T>` | `Dataglide.Functional` |
| `ApplicationError`, `Void` | `Dataglide.FunctionalExtensions` |
| `.AsOkResult()`, `.AsErrorResult<T>()`, `.BindAsync()`, `.TapOkAsync()`, `.Value()`, `.Error()` | `Dataglide.FunctionalExtensions.Results` |
| `.AsOption()` | `Dataglide.FunctionalExtensions.Nullables` |
| `.ToOkOr()`, `.AsSome()` | `Dataglide.FunctionalExtensions.Options` |
| `.ToOk()` / `.ToOkAsync()` (API → `IResult`) | `Dataglide.FunctionalExtensions.Server` |

---

## Core Types

| Type | Purpose |
|---|---|
| `Result<T, ApplicationError>` | Either a success value `T` or an `ApplicationError` |
| `Option<T>` | Either `Some(T)` or `None`; used instead of `null` |
| `ApplicationError` | `Dataglide.FunctionalExtensions.ApplicationError` — the standard error carrier across the Application layer. |
| `Void` | `Dataglide.FunctionalExtensions.Void` — used as the success value when a command produces no output |

---

## Extension Methods

| Method | Usage |
|---|---|
| `.AsOkResult()` | Lifts a plain value into a successful `Result` |
| `.AsErrorResult<T>()` | Produces a typed error `Result` from an `ApplicationError` |
| `.Bind(fn)` | Chains a step that can fail; short-circuits on error |
| `.TapOk(fn)` | Runs a side effect on success without changing the value |
| `.TapError(fn)` | Runs a side effect on error without changing the result (logging, or throwing in a message-triggered function) |
| `.Match(onOk, onError)` | Collapses a `Result` into a single value. Both branches must return the same meaningful type |
| `.AsOption()` | Lifts a type T into an Option<T> where a null becomes Option<T>.None |
| `.ToOkOr(fn)` | Converts an `Option<T>` to a `Result<T, ApplicationError>`; calls the function if None |
| `Void.New.AsOkResult()` | Produces the `Void` success result

Note Async versions of most extension methods exist and should be preferred where appropriate

---

## Rules

- Handlers should return `Result<T, ApplicationError>` if any part of the handler can fail for a business reason.
- Use `Match` only when you need the value it produces (e.g. mapping to an `IResult`). Never use `Match` with a dummy return value (`_ => 0`, `_ => Void.New`) just to run a side effect in one branch. Use `TapOk` / `TapError` instead.
- When only the error path needs handling (e.g. throwing so a message is retried or dead-lettered), use `.TapError(...)`.

### Chaining fallible steps

```csharp
// Bad: manual unwrapping
Result<ValidatedData, ApplicationError> validation = _validationRules.Validate(request);
if (validation.IsError)
{
    return validation.Error().AsErrorResult<Void>();
}
return await DoWorkAsync(validation.Value(), ct);

// Good
return await _validationRules.Validate(request)
    .BindAsync(validated => DoWorkAsync(validated, ct));
```


## Examples
If you are unsure how to chain these methods, read `examples.md` in this skill's directory.

## Related skills
- `application` - handlers must use this style
- `api` - endpoints map Results to HTTP responses
