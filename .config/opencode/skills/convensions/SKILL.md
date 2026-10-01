---
name: conventions
description: Provides general coding conventions. Use when writing any c# code
compatibility: opencode
---

# Conventions

## Naming
- Commands end with `Command`
- Queries end with `Query`
- Handlers end with `Handler`
- Validators end with `Validator`
- Repositories end with `Repository`

## Folder Structure
- Domain and Persistence mirror each other
- Tests mirror the structure of the layer they test

## Domain Events Naming Convention
- Events should be named in past tense: `<Entity><Action>Event`

## Coding Style
- Do not implement a `CancellationToken` style in methods, unless required by the signature.
