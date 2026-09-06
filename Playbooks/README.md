# Microsoft Sentinel playbooks

The playbooks are Azure Logic Apps Consumption workflows deployed from ARM templates. They use the Microsoft Sentinel incident trigger and a system-assigned managed identity.

| Playbook | Purpose | Destructive action |
|---|---|---|
| `IncidentTriage` | Add a structured investigation comment and a `DetectionLab-Triaged` tag | None |
| `HighSeverityEscalation` | Mark High-severity incidents for urgent escalation and add an escalation comment | None |

## Deployment prerequisites

1. Deploy the ARM template to a resource group in the same Azure region as the Sentinel workspace.
2. Assign the Logic App managed identity **Microsoft Sentinel Responder** on the workspace or its resource group.
3. Grant the Microsoft Sentinel service account **Microsoft Sentinel Automation Contributor** on the playbook resource group.
4. Attach the playbook to an incident-created automation rule.
5. Test in a non-production workspace before production enablement.

The templates create the Sentinel API connection with managed-identity authentication. No secrets are stored in this repository.
