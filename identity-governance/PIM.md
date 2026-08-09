# Privilage identity management

## Scenario

Standing privileged access — an account that's always a Global Admin or User Administrator — is one of the highest-value targets for an attacker, because compromising that one account gives permanent, unmonitored elevated rights. It's also a compliance problem: auditors want to see that privileged access is time-bound, justified, and reviewed, not just handed out and forgotten. IT security teams with admin roles need a way for admins to have no standing privilege by default and instead activate it only when needed, for a limited time, with justification and approval — shrinking the window an attacker  has to cause damage, and creating an audit trail of who had elevated access, when, and why.
## Configuration steps

1. In Entra admin center, go to Identity Governance > Privileged Identity Management > Microsoft Entra roles.
2. Go to Roles, select a role (e.g., User Administrator), and click Add assignment.
3. Assign a user as Eligible (not Active) — this means they can request activation but don't have the role by default.
4. Go to the role's Settings, and configure activation requirements: maximum activation duration (e.g., 8 hours), require MFA on activation, require justification, and require approval (name specific approvers).
5. Save the role settings.
6. As the eligible user, go to PIM > My roles, find the eligible role, and click Activate — enter justification, complete MFA if prompted, and submit.
7. As the approver, go to PIM > Approve requests, review the justification, and approve or deny.
8. Confirm the role becomes Active for the assigned duration, then automatically expires back to Eligible afterward — check the Activity/audit log to show the full activation-to-expiration trail.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out just-in-time (JIT) privileged access — eliminating standing access as a security control. It demonstrates that the safest amount of privilege to hold at any given moment, when you're not actively using it, is none — and that elevation should be temporary, justified, approved, and audited rather than permanent and assumed. This is the practical enforcement of least privilege applied to the time dimension, not just the scope dimension (which custom roles/AUs cover): even a correctly-scoped role is a risk if it's active 24/7 with nobody reviewing whether it's still needed.
