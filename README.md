# Microsoft Sentinel Detection Lab

An enterprise-aligned detection-as-code starter library for Microsoft Sentinel. It connects analytics engineering, incident automation, operational visibility, and governance in one version-controlled repository.

## What is included

| Area | Content |
|---|---|
| Entra ID | MFA fatigue, risky sign-ins without MFA, legacy authentication, impossible travel, privileged role assignment, and service-principal credential changes |
| API security | Microsoft Graph request-volume and enumeration-failure analytics |
| Playbooks | Safe incident triage and high-severity escalation workflows using managed identity |
| Workbooks | Identity security and API abuse operational dashboards |
| Governance | MITRE ATT&CK, NIST CSF 2.0, and Zero Trust mappings plus lifecycle and tuning controls |
| Delivery | Rule validation, ARM-template generation, deployment helper, and GitHub Actions CI |

## Repository layout

```text
Detections/           Sentinel scheduled analytics rules in YAML
Governance/           Control mappings and operating procedures
Playbooks/            Deployable Logic Apps Consumption ARM templates
Workbooks/            Deployable Azure Monitor workbook ARM templates
scripts/              Validation, build, and deployment helpers
.github/workflows/    Pull-request validation
```

## Quick start

Prerequisites: Microsoft Sentinel enabled on a Log Analytics workspace, the Microsoft Entra ID connector for identity rules, and Microsoft Graph activity logs for API rules.

```bash
ruby scripts/validate.rb
ruby scripts/build_arm.rb
az deployment group create \
  --resource-group <sentinel-resource-group> \
  --template-file dist/analytics-rules.json \
  --parameters workspaceName=<workspace-name> enabled=false
```

Rules deploy disabled by default. Validate their data coverage and tune exclusions in a development workspace before enabling them.

See [Detections](Detections/README.md), [Governance](Governance/README.md), [Playbooks](Playbooks/README.md), and [Workbooks](Workbooks/README.md) for operating guidance.

## Objective

Build practical, enterprise-aligned detection content that bridges security architecture, governance, and operational defense.

## Security model

- No tenant IDs, subscription IDs, workspace IDs, credentials, or notification destinations are committed.
- Playbooks use a system-assigned managed identity and perform non-destructive actions.
- Every rule has an owner, test guidance, false-positive guidance, entity mappings, and governance mappings.
- Production rollout requires peer review, a tuning record, and rollback ownership.
