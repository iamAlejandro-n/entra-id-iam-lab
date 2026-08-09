# Access Review 

## Scenario

Even with good provisioning controls, access naturally goes stale over time — a contractor's engagement ends but nobody removes their group membership, an employee changes teams but keeps access to their old team's resources, a PIM-eligible admin role was granted for a project that finished months ago. Nobody proactively goes back and checks "does this person still need this?" unless something forces them to. Compliance frameworks require organizations to periodically prove that access is still appropriate. Auditors want evidence of recurring review, not just a one-time grant decision. Resource owners, managers, and compliance teams need a structured, recurring process that surfaces "who has access to this right now" and forces an explicit decision to keep or remove on a schedule, rather than relying on someone remembering to clean up manually.

## Configuration steps

1. In Entra admin center, go to Identity Governance > Access reviews > New access review.
2. Choose the scope: a specific group's membership, an application's assigned users, or a PIM role assignment (eligible or active).
3. Set the name, description, and recurrence
4. Choose reviewers: the resource owner, managers, or specific named reviewers.
5. Configure decision helpers: enable "show recommendations" (Entra suggests removal for users with no recent sign-in activity) to make reviewer decisions easier and more accurate.
6. Set auto-apply behavior: what happens automatically if a reviewer doesn't respond in time (e.g., auto-remove, or no change) — and what happens on a "deny" decision (automatic removal from the group/role).
7. Start the review.
8. As the reviewer, go to My Access reviews, review each user and approve or deny access.
9. Confirm at the review's end date that denied users were automatically removed from the group/role, and check the review's results/history for an audit trail.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out access certification as a recurring control, not a one-time event — the principle that granting access correctly once isn't enough; access needs to be periodically re-justified or it should expire. It closes the loop that provisioning tools like entitlement management and PIM open: those control how access is granted, access reviews control whether it should still exist. Together they demonstrate the full lifecycle view of IAM — grant, use, and continuously validate — rather than treating identity governance as "set access once and move on."
