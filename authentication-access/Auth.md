# Authentication methods

## Scenario

Passwords alone are a well-known weak point — phishable, reusable, and easily compromised. But different users and scenarios have different needs: a frontline worker sharing a kiosk device can't use the same method as an office worker with a personal smartphone, and some orgs want to eliminate passwords entirely for high-value accounts. Security teams need centralized control over which authentication methods are allowed tenant-wide (or scoped to specific groups) — enabling strong methods like Microsoft Authenticator push or FIDO2 security keys, phasing out weak ones like SMS/voice, and rolling out passwordless options — rather than leaving it up to individual user choice or legacy defaults. This matters for any org trying to raise its authentication baseline, meet compliance requirements (e.g., phishing-resistant MFA mandates), or reduce helpdesk password-reset volume.

## Configuration steps
1. In Entra admin center, go to Protection > Authentication methods > Policies.
2.Review the list of available methods (Microsoft Authenticator, FIDO2 security key, Temporary Access Pass, Certificate-based auth) we want to avoid  weak methods(SMS, Voice call)
3. For each method, set Enable/Disable and scope it to "All users" or a specific group
4. For Microsoft Authenticator specifically number matching should be on, since it closes MFA fatigue/push-bombing gaps.
5. Disable weaker legacy methods (SMS, Voice) for users who don't need them, or restrict them to a fallback-only group.
6. Save the policy, confirm changes reflect in the policy list and test.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out authentication assurance as a tiered, policy-driven control — not all MFA is equal, and this exercise demonstrates you understand the difference between phishable methods (SMS, voice — vulnerable to SIM swap and social engineering) and phishing-resistant methods (FIDO2, certificate-based auth, windows hello for enterprize). It shows the ability to deliberately shape an organization's authentication posture — pushing users toward stronger methods and restricting weaker ones — rather than treating "MFA enabled" as a single binary checkbox. That's the practical difference between checking a compliance box and actually reducing account-takeover risk.
