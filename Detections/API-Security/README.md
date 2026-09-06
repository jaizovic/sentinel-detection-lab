# API security detections

These rules use `MicrosoftGraphActivityLogs` to identify abnormal Graph API request volume and repeated authorization or not-found responses consistent with enumeration.

Enable Microsoft Graph activity-log collection to the Sentinel workspace before deploying. Tune thresholds by application ID and exclude approved scanners, inventory jobs, backup products, and high-volume integration accounts.
