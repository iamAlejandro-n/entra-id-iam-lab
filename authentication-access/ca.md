# Conditional access

## Scenario
A username and password alone doesn't tell you how risky a sign-in is — the same valid credentials could be entering from a company laptop on the corporate network, or from an unknown device in a country the user has never traveled to. Applying the same access rule to every sign-in regardless of context is both too loose (real threats get through) and too strict (legitimate users get friction they don't need). Security teams need to make access decisions dynamically, based on who is signing in, what they're trying to access, and the conditions around it (device compliance, location, app sensitivity, sign-in risk) — granting or blocking access accordingly. Every org handling sensitive data or regulated compliance requirements needs this, since "MFA for everyone everywhere" is a blunt instrument and "no controls" is a breach waiting to happen.
## Configuration steps

1. In Entra admin center, go to Conditional Access > Policies > New policy. disable security default if haven't already.
2. Define Users: who the policy applies to (all users, a specific role like Global Admin, or a group) and explicitly exclude a break-glass emergency access account to avoid tenant lockout.
3. Define Target resources: which apps or actions this policy covers .
4. Define Conditions: the context that triggers the policy — e.g., locations, device platforms, or sign-in risk level.
5. Define Grant controls: what's required to get in — require MFA, require compliant device, require hybrid-joined device, or block access.
6. Set the policy to "Report-only" if you would like to review how the policy would behave though logs
7. test policies
8. we are going to block legacy authentication protocols entirely, require MFA for all admin roles (passwordless MFA strength), require mfa for standard users
## Screenshot
First before we create conditional access policies I made break glass accounts that are used as emergency accounts incase i get locked out of my tenant. I exclude these accounts from all CA policies. After i create new policy from template or from scratch, name it, select admin directory roles, exclude breakglass, grant access requiring mfa authentication strength.
<img width="1920" height="1080" alt="ca creation" src="https://github.com/user-attachments/assets/0ec08698-3766-4a97-956f-e5fb19e1f794" />


<img width="1920" height="1080" alt="lockout result" src="https://github.com/user-attachments/assets/edac20f4-d7d0-4d91-9997-cb9cde3085c5" />
Here i show the policy is created, on and not in report only. I was locked out of my admin account and blocked from login which is why its recommended to start in report only. In sign in logs is where i looked for further troubleshooting. Failed the admin mfa policy.

## What this demonstrates

This proves out zero trust access control: "never trust, always verify" applied per sign-in, not once at account creation. It demonstrates that access decisions should be made from an if-then policy engine evaluating real-time signals (identity, device, location, risk) rather than a static allow/deny list. Conditional Access is the mechanism that ties together everything else in this lab — authentication strength, risk signals from Identity Protection, device compliance — into enforceable rules. Documenting a set of layered policies (not just one) also shows you understand defense in depth: no single policy covers every threat, so multiple targeted policies stacked together close different gaps.
