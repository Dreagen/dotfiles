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

## Test Naming and Layout
- Test method names follow the exact `Scenario_Expected` convention: identify the class or entity under test, describe the scenario, then state the expected outcome. Use the `Given..._When..._Then...` wording within those parts as appropriate. If all tests in the same test class are performing the same `when` operation, then the test name can be abbreviated to `Given..._Then...`.
- Multiple conditions and multiple outcomes should be separated by an underscore.
  - for example, `GivenConditionOne_AndConditionTwo_ThenOutcomeOne_AndOutcomeTwo`
- Do not abbreviate entity names.
  - for example, For an entity named `PropertyCheck`, spell out `PropertyCheck`, not `Check`:

  ```csharp
  PropertyCheck_GivenStaticEntityWithIgnoredProperty_ThenIgnoredCheckIsLeftAloneAndValidCheckIsResolved
  ```

- Use one test class per scenario group, in a separate file. For example, split static, share-class dynamic, and exclusion scenarios into `..._StaticTests`, `..._ShareClassDynamicTests`, and `..._ExclusionTests` classes/files. Scenario-group classes may share a test base that provides builders.
- Keep each test organized into Arrange, Act, and Assert blocks.

## Testing conventions
- We prefer using the Assert.That style of tests. 
  - for example, Assert.That(actual, Is.EqualTo(expect))
- We prefer to create dependencies of the SUT using the builder pattern, so that the test is easy to read and understand.
- Use named arguments for magic numbers passed to builder and repository calls, so the meaning is clear; 
  - for example, `builder.WithLimit(limit: 3)` rather than `builder.WithLimit(3)`.
- Cover all branches of business logic, including variations of business entities represented through inheritance, union-like types (for example, Funds, SubFunds, and ShareClasses as variations of Static types) or enumerations.
- It should be possible to understand the setup and outcome of each independent test in situ.
  - Avoid obfuscating important parts of the "arrange", "act", "assert" stages.
  - Helper methods can be used, but they should not obfuscate the key aspects of the test.
  - The arrange step should clearly identify the key conditions.
  - The assert step should clearly identify the key outcomes.

## Testing directives
- it shouldn't be possible to comment out any logic (whether application layer business logic, domain logic or repository logic) and have all the tests pass
  - examples in the filter criteria of repository methods, or in the application layer business logic, where a developer might be tempted to comment out a line of code to make a test pass. If this is possible, then we don't have enough tests.

## Test Types
- We have 2 main types of tests. 

- The reason we separate into these 2 types is that the application interface rarely changes, so coupling tests to this is fine, and it allows to refactor the domain and get confidence we haven't broken anything. We occasionally write domain tests (unit tests) if there are lots of edge cases to cover for one specific domain entity, this is fairly rare.

### Application level tests 
- The primary purpose of these tests is to ensure that the application layer is correctly orchestrating the business scenarios, so coupling tests to those business scenarios is exactly what we're trying to achieve.

- It also allows refactoring of the domain to get confidence we haven't broken anything
  - refactoring the domain shouldn't necessarily require changes to the application layer 
  - it shouldn't be necessary to write domain level tests for every domain entity, as the application layer is the main entry point for the business scenarios.
    
- use in memory or mocked versions of persistence 

- application test projects will have a base class, for example ApplicationInMemoryRepositoryBaseTests, where we configure in memory versions of our persistence (repositories, queries etc) so each application layer test class can inherit from this.
- In-memory repositories must record the calls they receive. Assert which repository methods were called and which were not called.
- For every exclusion rule, seed an unaffected record with the same `RelatedEntity` and assert that it remains unchanged. Always set `RelatedEntity` on seeded data.

### Persistence tests 
- the preference is to use sqlite in memory database.

- persistence test projects will have a base class, for example IntegrationTestBase, where we configure the in memory sqlite database and provide helper methods to make it easy to use.

- use the InvokeOperationOnDbContextAsync helper method to interact with the dbcontext, for example handling committing dependencies of the SUT.
- Add an EF integration test in `EFPersistence.IntegrationTests` for every new repository method, covering each of its invariants.

## Related skills
Also load the skill for the layer under test: `application`, `persistence` or `domain`.
