# Tuning and risk acceptance

## Tuning record

Every production threshold or exclusion should record:

- rule ID and environment;
- observation window and event volume;
- false-positive source and business owner;
- proposed query or threshold change;
- security impact and compensating controls;
- approver, expiry date, and review date.

Prefer narrow exclusions using immutable application IDs, object IDs, managed identity IDs, named locations, or controlled network ranges. Avoid broad username, domain, country, or result-code exclusions that can hide attacker behavior.

## Risk acceptance

Risk acceptance is time-bound and must identify the affected asset, threat scenario, business justification, likelihood, impact, compensating controls, accountable executive, and expiry date. Expired exceptions fail closed: the detection returns to its reviewed baseline until renewed.

## Minimum operational targets

| Metric | Initial target |
|---|---|
| Query execution failure | 0% |
| Required data availability | at least 99% |
| High-severity triage | within 15 minutes |
| Medium-severity triage | within 4 hours |
| Rule owner review | quarterly for High, six-monthly otherwise |

Targets are starting points and should be aligned with contractual, regulatory, and incident-response obligations.
