# Auth strength/context

## Scenario

A single blanket "require MFA" policy treats all resources and all methods as equally risky, but they're not. Viewing a team calendar and approving a $2M wire transfer shouldn't require the same bar of proof. Security teams need two things: a way to define which combinations of authentication methods count as strong enough for a given situation (authentication strength), and a way to tag specific sensitive resources or actions — not just apps — so Conditional Access can require that stronger bar only where it matters (authentication context). This matters for any org with sensitive, high-value actions embedded inside an app rather than gating the whole app.
## Configuration steps
# Authentication strength:
1. In Entra admin center, go to Protection > Authentication methods > Authentication strengths.
2. Review built-in strengths (MFA, Passwordless MFA, Phishing-resistant MFA) or click "New authentication strength."
3. Select which combinations of methods satisfy the custom strength.
4. name and save
# Authentication context:
1. In Entra admin center, go to Protection > Conditional Access > Authentication context.
2. Create a new context, give it a display name and description.
3. Publish it so it becomes selectable.
4. In the target application (or via Microsoft Graph/app registration for a custom app), tag the specific action, page, or API scope with this authentication context ID — this step is app-dependent and often documented conceptually if the app doesn't natively support it.
5. Create a Conditional Access policy scoped to "Authentication context" as the target resource, and set the grant control to require the specific authentication strength you built.
6. Test: access the low-risk part of the app normally, then trigger the tagged sensitive action and confirm the step-up prompt requires the stronger method.
## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out risk-proportional, granular step-up authentication — moving beyond "MFA yes/no at the app level" to enforcing the right strength of proof, at the right moment, for the specific action being taken. Authentication strength proves you can define what "strong enough" actually means in concrete, method-level terms rather than a vague checkbox. Authentication context proves you can apply that bar inside an application rather than being limited to gating entire apps — which is the real-world gap most basic CA setups miss, since sensitive actions are usually a small subset of what an app does. Together they demonstrate the zero-trust principle of least-privilege applied to authentication itself.
