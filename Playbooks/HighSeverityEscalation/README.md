# HighSeverityEscalation

Checks the incoming incident severity. For High-severity incidents it adds the `Urgent-Escalation` tag and an escalation comment. Lower-severity incidents exit without mutation.

## Deploy

```bash
az deployment group create \
  --resource-group <playbook-resource-group> \
  --template-file Playbooks/HighSeverityEscalation/azuredeploy.json
```

After deployment, grant the workflow managed identity **Microsoft Sentinel Responder** and attach it to an incident-created automation rule. Use the automation-rule conditions to limit execution to this repository's analytics rules where appropriate.

This workflow intentionally does not send to a third-party notification channel. Add an approved Teams, email, PagerDuty, or ITSM connector only after secrets, retention, routing, and failure ownership are governed.
