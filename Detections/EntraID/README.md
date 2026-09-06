# Entra ID Detection Rules

Scheduled analytics focused on:

- MFA bypass
- Impossible travel
- Conditional Access gaps
- Legacy authentication
- Suspicious privilege escalation

Each rule includes entity mappings, MITRE ATT&CK coverage, investigation guidance, and false-positive notes. The rules require `SigninLogs` or `AuditLogs` from the Microsoft Entra ID connector.

Before enabling, validate log coverage and add exclusions for approved break-glass accounts, named locations, identity protection services, and authorized automation.
