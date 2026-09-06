# Analytics rule lifecycle

## 1. Propose

Define the threat hypothesis, protected asset, attacker behavior, expected telemetry, business impact, and accountable owner. A rule should answer a risk question rather than merely match a log pattern.

## 2. Develop

- Use the minimum data window needed to express the behavior.
- Return investigation-ready fields and map stable Sentinel entities.
- Avoid embedding tenant identifiers, personal data, secrets, or environment-specific allowlists.
- Put organization-specific thresholds and exclusions in a clearly marked section of the query.

## 3. Test

- Confirm the required table and columns exist.
- Run against at least seven days of representative data.
- Replay or safely generate a known-positive scenario when possible.
- Record result count, query duration, scanned volume, known benign sources, and expected incident grouping.
- Run `ruby scripts/validate.rb` and inspect the generated ARM template.

## 4. Approve and deploy

Require a detection engineer and a service or data owner to approve production use. Deploy disabled first, validate the rendered rule, then enable during a monitored change window.

## 5. Operate

Track daily alert volume, true-positive rate, false-positive rate, mean time to triage, query failures, and data latency. Treat a sudden drop to zero as a possible telemetry failure.

## 6. Review or retire

Review high-severity rules quarterly and all other rules at least every six months. Retire a rule when the threat is prevented, telemetry is removed, coverage is replaced, or operational cost exceeds accepted value. Preserve the decision and replacement reference in version control.

## Emergency rollback

Disable the analytics rule first; do not delete it during an incident. Disable related automation rules or Logic Apps if response actions are misbehaving. Record the rollback time, impact, owner, and recovery criteria.
