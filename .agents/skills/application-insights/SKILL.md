---
name: application-insights
description: Connect to the configured Azure Application Insights resources, authenticate with the local service-principal environment, select a component from the local inventory, and run read-only KQL queries. Use when investigating telemetry, requests, traces, dependencies, exceptions, or events in Application Insights.
---

# Azure Application Insights

Use this skill to query the Application Insights resources configured on this machine. Queries are read-only; do not make resource, alert, or telemetry configuration changes as part of an investigation.

## Local configuration

- Resource inventory: `~/.config/azure-ai-agent/application-insights.json`
- Service-principal environment: `~/.config/azure-ai-agent/credentials.env`
- The inventory is a JSON array. Each entry has a `name`, `resourceId`, `appId`, and `workspaceResourceId` (which can be `null`). Use `name` to identify a component and `appId` for Application Insights queries.
- The environment file defines `AZURE_TENANT_ID`, `AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, and `AZURE_SUBSCRIPTION_ID`.

Never display, print, or copy the credentials file or any secret value. Do not use shell tracing (`set -x`), put credentials into a script or query, or include them in logs or responses. Load the file only to authenticate as shown below. Do not commit credentials or inventory values into project files.

## Authenticate

In a Bash shell, load the configured environment, check that the required values exist without printing them, then sign in and select the configured subscription:

```bash
source "$HOME/.config/azure-ai-agent/credentials.env"

for name in AZURE_TENANT_ID AZURE_CLIENT_ID AZURE_CLIENT_SECRET AZURE_SUBSCRIPTION_ID; do
    if [[ -z "${!name:-}" ]]; then
        printf 'Missing required environment variable: %s\n' "$name" >&2
        exit 1
    fi
done

az login \
    --service-principal \
    --username "$AZURE_CLIENT_ID" \
    --password "$AZURE_CLIENT_SECRET" \
    --tenant "$AZURE_TENANT_ID" \
    --output none

az account set --subscription "$AZURE_SUBSCRIPTION_ID"
```

Do not run `az account show` without a field projection if it could expose unrelated account details; if needed, verify the selected subscription with `az account show --query id --output tsv`.

## Find a resource

First identify the exact component and environment requested. If the request is ambiguous (especially between dev, test, and parallel resources), ask which one to use rather than guessing. List only the identifying fields from the inventory:

```bash
jq -r '.[] | [.name, .appId] | @tsv' \
    "$HOME/.config/azure-ai-agent/application-insights.json"
```

Select a component by its exact `name` and retrieve its app ID without dumping the full inventory:

```bash
APP_NAME='replace-with-exact-name'
APP_ID=$(jq -er --arg name "$APP_NAME" \
    '[.[] | select(.name == $name) | .appId] | if length == 1 then .[0] else error("expected exactly one matching resource") end' \
    "$HOME/.config/azure-ai-agent/application-insights.json")
```

If no entry is found, the name is not unique, or `jq` is unavailable, inspect the inventory in a way that avoids exposing unrelated values and resolve the target before querying. Do not guess an app ID.

## Run read-only queries

Use the Application Insights CLI query command with the selected `appId`. Keep time windows bounded and results limited; refine the KQL to the user's question.

```bash
az monitor app-insights query \
    --apps "$APP_ID" \
    --analytics-query 'requests | where timestamp > ago(1h) | project timestamp, name, resultCode, success, operation_Id | order by timestamp desc | take 100' \
    --offset 1h \
    --output table
```

Common Application Insights tables include `requests`, `dependencies`, `exceptions`, `traces`, and `customEvents`. For example, start an exception investigation with:

```kusto
exceptions
| where timestamp > ago(1h)
| project timestamp, type, problemId, outerMessage, operation_Id
| order by timestamp desc
| take 100
```

The `application-insights` Azure CLI extension may be installed on first use. If the command is unavailable, allow Azure CLI's normal extension installation or ask before changing CLI configuration. Do not install unrelated tools or extensions without a need.

## Workspace-based queries

If an entry has a non-null `workspaceResourceId` and a workspace-table query is more appropriate, resolve the workspace's customer ID and use the Log Analytics query command:

```bash
WORKSPACE_RESOURCE_ID='copy-the-selected-entry-workspaceResourceId-here'
WORKSPACE_ID=$(az monitor log-analytics workspace show \
    --ids "$WORKSPACE_RESOURCE_ID" \
    --query customerId \
    --output tsv)

az monitor log-analytics query \
    --workspace "$WORKSPACE_ID" \
    --analytics-query 'AppRequests | where TimeGenerated > ago(1h) | project TimeGenerated, Name, ResultCode, Success, OperationId | order by TimeGenerated desc | take 100' \
    --timespan PT1H \
    --output table
```

Common workspace tables include `AppRequests`, `AppDependencies`, `AppExceptions`, `AppTraces`, and `AppEvents`. If `workspaceResourceId` is `null`, use the Application Insights query path instead.

## Safety and reporting

- Keep queries read-only; do not issue Azure commands that create, update, or delete resources.
- Use the narrowest useful time range and a reasonable `take` limit. Avoid retrieving large volumes of telemetry or sensitive data unrelated to the request.
- Do not expose secrets or unnecessarily repeat resource IDs, app IDs, tenant IDs, or subscription IDs in the response.
- Summarize the selected component and time range, report relevant findings, and clearly mention query errors or incomplete results.
