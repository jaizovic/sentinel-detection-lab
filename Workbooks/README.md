# Microsoft Sentinel workbooks

| Workbook | Required tables | Purpose |
|---|---|---|
| `IdentitySecurity` | `SigninLogs`, `AuditLogs` | Identity risk, MFA, legacy authentication, and privileged-change visibility |
| `APIAbuse` | `MicrosoftGraphActivityLogs` | Graph request volume, failures, applications, IP addresses, and endpoints |

Deploy a workbook to the Sentinel workspace resource group:

```bash
az deployment group create \
  --resource-group <sentinel-resource-group> \
  --template-file Workbooks/IdentitySecurity/azuredeploy.json \
  --parameters workspaceName=<workspace-name>
```

Repeat with the API workbook template. The templates derive the workspace resource ID from parameters and contain no fixed tenant or subscription identifiers.
