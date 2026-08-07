# hybrid

## Scenario
Most established organizations don't start in the cloud — they already have an on-prem Active Directory with tons of user accounts, group policies, and application dependencies built around it. Ripping that out and starting fresh in Entra ID isn't realistic. But those same orgs still want cloud apps (M365, SaaS tools) with modern authentication, MFA, and Conditional Access. IT admins at any organization with an existing on-prem AD footprint — which is most mid-size and large enterprises — need a way to extend their existing identities into the cloud instead of managing two separate, disconnected identity stores (which leads to mismatched passwords, duplicate accounts, and inconsistent access). Hybrid identity solves this by synchronizing on-prem AD accounts into Entra ID so users get one identity that works both on-prem and in the cloud.

## Configuration steps

1. Install Microsoft Entra Connect (or Entra Connect Cloud Sync for a lighter-weight agent-based option) on a server with connectivity to on-prem AD.
2. Configure the sync scope — which OUs, domains, or groups get synchronized to Entra ID 
3. Choose the authentication method: phs/pta/ with seamlesss sso /federation. Password Hash Sync (PHS) a hash of the password hash syncs to Entra ID so users authenticate against the cloud directly; Pass-Through Authentication (PTA) validates against on-prem AD in real time; Federation (ADFS) delegates auth entirely to an on-prem federation server.
4. Enable staging/initial sync and monitor via Entra Connect Health for sync errors
5. Confirm synced users appear in Entra ID with "on-premises sync enabled" and the correct immutableId/sourceAnchor linking them to their on-prem object.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out identity as a single source of truth across environments — the principle that a user should have one authoritative identity and one credential, not fragmented accounts that drift out of sync between on-prem and cloud.
