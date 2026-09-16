---
name: testing
description: Testing conventions, test naming, assertions, and application-level tests. Use when writing or reviewing tests.
compatibility: opencode
---

## What I do

- Give guidelines on testing convensions in different languages

## When to use

Use this when writing tests

## CSharp
- When writing tests most of the projects will use NUnit
- Our test file name is the <NameOfClassToTest>Tests.cs if there are many tests for one behaviour we will sometimes do <NameOfClassToTest_SpecificBehaviour>Tests.cs
- We name our tests using Given<SomeExistingSetup>_When<SomeAction>_Then<SomeExpectedResult>. The Given or When can sometimes be ommitted if this is obvious.
- We prefer using the Assert.That style of tests. E.g. Assert.That(actual, Is.EqualTo(expect))
- We have 2 main types of tests. Application level tests which cover application and domain logic but use in memory or mocked versions of persistence, and persistence tests which generally use sqlite in memory database. We don't generally test the api layer unless there is a good reason to.
The reason we do this is that the application interface rarely changes, so couple tests to this is fine, and it allows to refactor the domain and get confidence we haven't broken anything because the application level tests will still compile.
We occasionally write domain tests (unit tests) if there are lots of edge cases to cover for one specific domain entity, this is fairly rare.
- In our application level tests most projects will have a base class something like ApplicationInMemoryRepositoryBaseTests where we configure in memory versions of our persistence (repositories, queries etc)

