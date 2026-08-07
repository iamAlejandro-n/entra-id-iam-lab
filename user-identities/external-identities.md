# External Identities

## Scenario
Every local account an org creates for an external person is an identity it now has to manage forever — provisioning it, remembering it exists, revoking it when the engagement ends. In practice, these accounts are the ones most likely to get forgotten: a contractor's project ends, nobody offboards the account, and it sits active with standing access indefinitely — a classic orphaned-account finding in any security audit.B2B guest access solves this by never creating a duplicate, independently-managed credential in the first place. What you're managing instead is a much smaller surface: the guest object and its resource assignments in your directory, not a full password/MFA-bearing account.

## Configuration steps

1. In Entra admin center, go to Identity > External Identities > Cross-tenant access settings and review/configure default inbound/outbound trust settings (e.g., whether to trust MFA claims from the guest's home tenant).
2. Go to Identity > Users > New user > Invite external user.
3. Enter the guest's email address and send the invite.
4. The guest receives an email, clicks the link, and consents/authenticates with their home tenant credentials — this creates a guest (B2B) object in your directory with userType = Guest.
5. Assign the guest to a group or resource (e.g., add them to a Team, a SharePoint site, or an app) — scope access to only what the collaboration requires.
6. optional: add conditional access
7. verify they can access to resources they are scoped to and nothing more

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

minimizing standing identities you're responsible for is itself a security control — fewer locally-owned credentials means fewer things that can be forgotten, fewer passwords that can be compromised, and a smaller blast radius if something goes wrong.
