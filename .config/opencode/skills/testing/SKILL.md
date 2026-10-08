---
name: testing
description: Testing conventions for all *.Tests / *.IntegrationTests projects - test types (application-level vs persistence vs domain), test class and method naming, Assert.That style, builders, in-memory repository base classes and SQLite in-memory persistence tests. Use when writing or reviewing any C# tests.
---

# Overview
- Each layer has its own dedicated test project.
- All tests must be deterministic and isolated.
- We don't generally test the api layer unless there is a good reason to.

## Test project folder structure
- Each test project must have a folder structure that mirrors the layer it tests. 

## Test Class Naming
- Use the pattern: `Given<State>_Then<ExpectedResult>`
- If the test class has greater than 5 test scenarios then separate each scenario into common operational behaviour and place those into their own test class, with multiple test methods for different states and expected results, so that each test class has a single responsibility and is easy to read and maintain.

  ```csharp
  HoldNavsFailingReleaseCriteriaCommand_ModificationCheckTests
  HoldNavsFailingReleaseCriteriaCommand_ThresholdBreachTests
  ```

- Use the pattern `Given<State>_With<Context>_Then<ExpectedResult>` to add variations of tests with specific contexts, such as different input parameters or preconditions, to ensure that the tests cover a wide range of scenarios and edge cases.

## Testing conventions
- We prefer using the Assert.That style of tests. E.g. Assert.That(actual, Is.EqualTo(expect))
- We prefer to create dependencies of the SUT using the builder pattern, so that the test is easy to read and understand.

## Test Types
- We have 2 main types of tests. 

- The reason we separate into these 2 types is that the application interface rarely changes, so coupling tests to this is fine, and it allows to refactor the domain and get confidence we haven't broken anything. We occasionally write domain tests (unit tests) if there are lots of edge cases to cover for one specific domain entity, this is fairly rare.

### Application level tests 
- The primary purpose of these tests is to ensure that the application layer is correctly orchestrating the business scenarios, so coupling tests to those business scenarios is exactly what we're trying to achieve.

- It also allows refactoring of the domain to get confidence we haven't broken anything
  - refactoring the domain shouldn't necessarily require changes to the application layer 
    
- use in memory or mocked versions of persistence 

- application test projects will have a base class, for example ApplicationInMemoryRepositoryBaseTests, where we configure in memory versions of our persistence (repositories, queries etc) so each application layer test class can inherit from this.

### Persistence tests 
- the preference is to use sqlite in memory database.

- persistence test projects will have a base class, for example IntegrationTestBase, where we configure the in memory sqlite database and provide helper methods to make it easy to use.

- use the InvokeOperationOnDbContextAsync helper method to interact with the dbcontext, for example handling committing dependencies of the SUT.

## Related skills
Also load the skill for the layer under test: `application`, `persistence` or `domain`.
