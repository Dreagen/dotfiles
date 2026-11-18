---
name: jira
description: Tells you how to access jira tickets
---

The jira api is accessable with PAT in environment variable "JIRA_PAT" example address "https://devopsjira.deutsche-boerse.com/browse/[JIRA TICKET]"

It's generally better to spawn a sub agent to read and summarize the jira ticket to keep your context clean.
