# Detection governance

This folder supplies the operating controls around the analytics content. Technical validity alone is not sufficient for production promotion.

## Required gates

| Gate | Evidence |
|---|---|
| Ownership | Named team in the rule `owner` field |
| Threat coverage | MITRE ATT&CK tactics and techniques in the rule and `control-mapping.yaml` |
| Risk alignment | NIST CSF 2.0 outcome and Zero Trust pillar mapping |
| Data readiness | Required tables are ingesting, normalized, and within expected latency |
| Test evidence | True-positive fixture or reproducible test procedure |
| Tuning | Documented threshold rationale and approved exclusions |
| Response | Investigation guidance, escalation route, and rollback owner |
| Review | Independent peer approval and scheduled review date |

Read [Rule lifecycle](rule-lifecycle.md) and [Tuning and risk acceptance](tuning-and-risk-acceptance.md) before production deployment.

`control-mapping.yaml` is machine-checked against every detection ID during validation.
