# Identity protection
sign in risk and user risk
## Scenario

Credential theft doesn't announce itself — a stolen password gets used from an unfamiliar country, an account starts showing impossible travel, or a user's credentials show up in a leaked-password dump on the dark web. Static Conditional Access rules (like "require MFA from outside the US") can't catch this kind of behavioral anomaly because it's not about where the sign-in geographically originates in isolation — it's about whether the sign-in pattern looks like the real user or an attacker. Security operations teams and any org that's a target for credential-stuffing or phishing need automated, risk-based detection that scores each sign-in and each user in real time and can respond automatically — blocking, forcing MFA, or forcing a password reset — without waiting for a human analyst to notice and react hours or days later.
## Configuration steps

1. In Entra admin center, go to Protection > Identity Protection.
2. Review the three core policies: Sign-in risk policy, User risk policy, and MFA registration policy.
3. For the sign-in risk policy: set the risk threshold High that triggers action, select the response (require MFA or block access), and choose scope.
4. For the user risk policy: set the threshold, and require a secure password change as the response 
5. Save both policies.
6. Go to the Risky users and Risky sign-ins reports to review real or simulated detections 
7. Walk through remediation: as the flagged user, complete the required MFA/password reset challenge and confirm the risk state clears; as an admin, confirm you can manually dismiss or confirm a risk on a user in the report.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out continuous, adaptive risk evaluation as a security control — moving past the idea that authentication is a one-time gate at sign-in and treating it as an ongoing signal that gets scored and reacted to. It demonstrates the difference between static Conditional Access (fixed rules you wrote in advance) and dynamic risk-based access (Microsoft's threat intelligence and behavioral analytics deciding in real time whether this specific sign-in looks legitimate). This is the practical core of zero trust: never assume a successful password entry means "this is really the user" — keep evaluating risk signals throughout the session and respond automatically when something doesn't look right.
