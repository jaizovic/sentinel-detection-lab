# Analytics rules

Rules follow the Microsoft Sentinel scheduled analytics template convention. Each YAML file is the source of truth; `scripts/build_arm.rb` converts all rules into one deployable ARM template.

## Data prerequisites

| Rule family | Required table | Connector or diagnostic setting |
|---|---|---|
| Entra ID sign-in | `SigninLogs` | Microsoft Entra ID |
| Entra ID change | `AuditLogs` | Microsoft Entra ID |
| API security | `MicrosoftGraphActivityLogs` | Microsoft Graph activity logs routed to the workspace |

## Promotion workflow

1. Run `ruby scripts/validate.rb`.
2. Run the query manually over representative data.
3. Record expected true positives and known exclusions in the pull request.
4. Generate the ARM template with `ruby scripts/build_arm.rb`.
5. Deploy disabled to a development workspace.
6. Tune, peer-review, enable, and monitor incident volume for seven days.

Thresholds are starter values, not universal baselines. Each organization must tune them for its identity population, normal automation, geographic footprint, and Graph workloads.
