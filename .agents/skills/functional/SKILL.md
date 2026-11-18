---
name: functional
description: How to use the Dataglide functional libraries (Dataglide.Functional, Dataglide.FunctionalExtensions) - Result<T, ApplicationError>, Option<T>, Void, Bind, Map, TapOk, Match, ToOkOr, AsOkResult, ToOkAsync and their namespaces. Use when writing handlers, domain methods that can fail, or endpoints that return a Result.
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

Note Async versions of most extension methods exist.

| Method | Usage |
|---|---|
| `.AsOkResult()` | Lifts a plain value into a successful `Result` |
| `.AsErrorResult<T>()` | Produces a typed error `Result` from an `ApplicationError` |
| `.Bind(fn)` | Chains a step that can fail; short-circuits on error |
| `.TapOk(fn)` | Runs a side effect on success without changing the value |
| `.AsOption()` | Lifts a type T into an Option<T> where a null becomes Option<T>.None |
| `.ToOkOr(fn)` | Converts an `Option<T>` to a `Result<T, ApplicationError>`; calls the function if None |
| `Void.New.AsOkResult()` | Produces the `Void` success result

---

## Rules

- Handlers should return `Result<T, ApplicationError>` if any part of the handler can fail for a business reason.

## API Endpoints

Minimal API endpoints map `Result<T, ApplicationError>` values returned by MediatR handlers directly to `IResult` HTTP responses.

When the response is a plain `200 OK`, call `.ToOkAsync()` directly on the result. It handles both the success and error cases.

```csharp
umbrella.MapGet("/", async (ISender sender) =>
{
    return await sender.Send(new GetAllUmbrellaWrappersQuery()).ToOkAsync();
});
```

## Examples
If you are unsure how to chain these methods, read `examples.md` in this skill's directory.

## Related skills
- `application` - handlers must use this style
- `api` - endpoints map Results to HTTP responses
