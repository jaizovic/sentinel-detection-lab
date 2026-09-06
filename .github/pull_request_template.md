## Detection change

- Threat hypothesis and business risk:
- Rules, playbooks, or workbooks changed:
- Required tables and expected ingestion latency:
- Test period and known-positive evidence:
- Before/after result volume:
- Expected false positives and exclusions:
- Performance or cost impact:
- MITRE / NIST / Zero Trust mapping reviewed:
- Rollback owner and criteria:
- Next review date:

## Checklist

- [ ] `ruby scripts/validate.rb` passes.
- [ ] Generated ARM was reviewed and deployed disabled in a development workspace.
- [ ] No tenant IDs, subscription IDs, credentials, or personal destinations are committed.
- [ ] A detection engineer and the relevant service/data owner approved the change.
