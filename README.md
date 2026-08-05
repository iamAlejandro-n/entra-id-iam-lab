# Entra ID IAM Lab

A hands-on Microsoft Entra ID lab built to learn and demonstrate identity and access management
concepts, aligned to Microsoft's **SC-300: Identity and Access Administrator** exam objectives.

Rather than just studying for the exam, this repo documents each concept as a real configuration —
built, screenshotted, and explained in terms of the problem it solves, not just the steps to click through.

**Jump to:** [User Identities](user-identities) · [Authentication & Access](authentication-access) · [Identity Governance](identity-governance)

## Scope

This lab focuses on three of the four SC-300 domains:

| # | SC-300 Domain | Weight | Covered here |
|---|----------------|--------|--------------|
| 1 | Implement and manage user identities | 20-25% | ✅ [user-identities](user-identities) |
| 2 | Implement authentication and access management | 25-30% | ✅ [authentication-access](authentication-access) |
| 3 | Plan and implement workload identities | 20-25% | ⛔ out of scope |
| 4 | Plan and implement identity governance | 20-25% | ✅ [identity-governance](identity-governance) |

## Environment

- Microsoft 365 Developer Program tenant (free, sample users/groups)
- Microsoft Entra ID P2 trial (required for PIM, access reviews, entitlement management,
  Identity Protection risk policies)

### Reproducing this lab

1. Sign up for the [Microsoft 365 Developer Program](https://developer.microsoft.com/microsoft-365/dev-program) — free tenant with sample users/groups
2. Activate a free Entra ID P2 trial from the Entra admin center (**Identity Governance** → **Licenses**)
3. Follow the write-ups under `User Identities · Authentication & Access · Identity Governance`

## Repo structure

```
entra-id-iam-lab/
├── README.md
├── 01-user-identities/
├── 02-authentication-access/
├── 04-identity-governance/

```

## How each topic is documented

Every write-up under `User Identities · Authentication & Access · Identity Governance` follows the same format:

1. **Scenario** — the real-world problem this configuration solves
2. **Configuration steps** — what was built in the portal/PowerShell/Graph
3. **Screenshot(s)** — redacted evidence of the working configuration
4. **What this demonstrates** — the underlying IAM concept

