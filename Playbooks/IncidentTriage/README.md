# IncidentTriage

Adds a standard analyst checklist to the triggering incident and applies the `DetectionLab-Triaged` tag. It does not close the incident, change ownership, block an IP, or disable an identity.

## Deploy

```bash
az deployment group create \
  --resource-group <playbook-resource-group> \
  --template-file Playbooks/IncidentTriage/azuredeploy.json
```

After deployment, grant the workflow managed identity **Microsoft Sentinel Responder** and attach the playbook to an incident-created automation rule.

## Validation

Trigger the workflow from a test incident and verify that exactly one comment and one tag are added. Confirm retry behavior before enabling automatic execution.
