# Terms of use

## Scenario
contractors/external partners accessing a SharePoint site with sensitive data. Your org wants to legally document that anyone accessing that resource explicitly agreed to acceptable-use terms — auditable per-user, with a timestamp — before Conditional Access even lets them in.

## Configuration steps
1. go to identity governance, terms of use, new term
2. add pdf and configure settings
3. create a conditional access policy scoped to a target group and resources
4. under grand, select the TOU
5. test and review report

## SCREENSHOTS



## what this demonstrates
Legal/compliance accountability — you have a timestamped, per-user, per-version acceptance record, which is what actually holds up if a contractor claims "I never agreed to that."
Grant controls beyond MFA — shows you understand CA isn't just "require MFA everywhere," it's a flexible policy engine with multiple grant control types that can combine.
Targeted governance for external/B2B identities specifically — ties directly back to your Domain 1 B2B guest work, since ToU is disproportionately used for guests/contractors rather than full-time employees who are typically covered by an HR onboarding agreement instead.
