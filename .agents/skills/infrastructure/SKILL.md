---
name: infrastructure
description: Conventions for infrastructure changes, including Service Bus monitoring alerts, should be read when making any bicep file changes.
---

# Infrastructure

- Add every new Service Bus queue or topic to the alerts Bicep file, if one exists, so DevOps are informed for monitoring.
- When creating resources with `bicep`:
  - always use the latest stable api version.
  - do not use preview versions, unless this is the only option. In this case, highlight as part of the planning process.
