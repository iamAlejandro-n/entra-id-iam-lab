# [Dynamic groups]

## Scenario
Static groups require someone to manually add/remove members every time a person joins, moves, or leaves. which doesn't scale and inevitably **drifts out of date** (people keep access after they've moved teams, new hires don't get access on day one). **IT admins and security teams** need group membership to stay accurate automatically, especially when that membership drives real consequences like which Conditional Access policy applies, which licenses get assigned, which apps show up in the user's My Apps, or which distribution list they're on. Any org with regular headcount changes — new hires, transfers, departures — needs dynamic groups so membership self-corrects the moment a user's department, job title, office location change, without IT having to remember to update anything.
## Configuration steps

1. In Entra admin center, go to Identity > Groups > All groups > New group.
2. Choose group type (Security or Microsoft 365), give it a name.
3. Set Membership type to "Dynamic User" (or "Dynamic Device" for device-based rules).**Cannot be changed later.**
4. Click "Add dynamic query" to open the rule builder.
5. Build a rule against user attributes, e.g. (user.department -eq "Sales") and (user.usageLocation -eq "US").
6. Validate the rule using "Validate Rules" against sample users to confirm it catches the right people before saving.
7. Save the group and confirm the membership processing job populates it (can take a few minutes).
8. Attach the group to whatever it's meant to drive — a CA policy, license, or app assignment — and verify a test user with matching attributes gets it automatically.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This demonstrates attribute-based access control (ABAC) through automated group evaluation — the shift from manually-curated membership to policy-as-rule. It proves that access can be tied to who someone is (their attributes) rather than who remembers to add them, so entitlements stay continuously correct as the workforce changes. It's the same principle that makes Conditional Access and entitlement management trustworthy at scale: group membership becomes a live reflection of identity data instead of a static list that goes stale.
