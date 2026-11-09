## lab summary
[entra-id-lab-portfolio.pdf](https://github.com/user-attachments/files/32779643/entra-id-lab-portfolio.pdf)
**Microsoft Entra ID Governance Lab**
A self-built Entra ID tenant used to practice hands-on identity and access management: provisioning, Conditional Access, Identity Protection, privileged access (PIM), and the full Identity Governance suite (Access Reviews, Entitlement Management, Terms of Use). Built solo on an Azure free tier + Entra ID P2 trial — no production environment, no prior IAM job experience, just the Microsoft documentation, Graph API/PowerShell, and a lot of deliberate troubleshooting.
This write-up focuses on the design decisions and real problems I ran into, not just a list of features clicked through. Full configuration log available on request.
**Environment**
-Tenant: mini.onmicrosoft.com (Azure Free Account)
-Licensing: Microsoft Entra ID P2 (30-day trial), assigned via group-based licensing rather than per-user
-50ish test user accounts across 5 departments (IT, Sales, Finance, HR, Marketing) and two usage locations (US, Sweden), bulk-provisioned via CSV import
-All work documented as I went, including dead ends and corrected assumptions
**Case studies — real problems I diagnosed and fixed**
1. A "correctly excluded" break-glass account still got MFA-prompted
Built 5 emergency access (break-glass) accounts per Microsoft's standard pattern — default domain, permanent Global Admin, excluded from every Conditional Access policy I'd written. One still got prompted for MFA. Security Defaults was off, per-user MFA was disabled, every custom CA exclusion checked out.
Traced it to a Microsoft-managed Conditional Access policy ("Require multifactor authentication for admins") — auto-created by Microsoft, invisible unless you go looking, and enforced independently of any tenant-authored exclusion. Confirmed it by deliberately un-excluding a test account and reading the exact grant-control failure message, rather than assuming.
Then hit a second layer: my "FIDO2" registration turned out to only be password + Authenticator TOTP (TOTP always needs a password, so it can never satisfy a passwordless policy). A Chrome "sign in with a passkey" prompt I assumed was the fix turned out to belong to my Google account, not Entra, at all. Resolved by registering a genuine device-bound passkey through Microsoft Authenticator.
Takeaway: break-glass accounts need to be tested against Microsoft's own baked-in protections, not just your custom policies — and "it looks registered" isn't the same as "it satisfies this specific requirement."
2. New users couldn't sign in for the first time under MFA enforcement
Once baseline MFA enforcement was live, brand-new accounts got blocked on their very first sign-in: no MFA method registered yet, but can't register a method without signing in first.
Fixed by issuing a Temporary Access Pass (TAP) — a time-limited, admin-issued passcode designed exactly for this scenario. This is the standard real-world onboarding pattern for any MFA-enforced tenant, and it directly informed how I scoped the MFA registration policy's grace period.
3. Designing tiered privileged access instead of one-size-fits-all admin rights
Rather than handing out the built-in Helpdesk Administrator role (which bundles session invalidation and Microsoft support-ticket management alongside password reset), I built a custom role with exactly two permissions: password reset and read-only profile access. Compared the two directly, then used that comparison to design a genuine two-tier structure:
-RoleGroup-HelpdeskLead — custom role, minimal permissions, 1-stage approval, 30-day expiration
-RoleGroup-UserAdmin — built-in role, broader permissions, 2-stage approval, 14-day expiration
Both delivered through Entitlement Management access packages with distinct, specific approval justifications at each stage — not a rubber stamp repeated twice.
4. An access review that actually found something
Ran a scoped access review against a role-assignable group carrying User Administrator rights. Found 4 members with no departmental justification for holding that access (outside IT). Denied and removed them with a written justification, and confirmed the role access was actually revoked, not just recorded as a decision.
Also needed department/job-title context the review UI doesn't surface — pulled it via a direct Microsoft Graph query, which surfaced its own lesson: holding Global Administrator doesn't automatically grant an application (like Graph Explorer) permission to query the directory. Directory roles and API permission scopes are two separate axes of access.
**What I built, by area**
Identity foundation — bulk user provisioning (CSV + Microsoft Graph), attribute-driven dynamic groups and Administrative Units, static vs. role-assignable group design, custom directory role authoring
Conditional Access — baseline MFA, legacy auth blocking, phishing-resistant/passwordless authentication strength for admins, Protected Actions with a custom Authentication Context, risk-based policies (migrated ahead of the legacy Identity Protection retirement in Oct 2026)
Privileged access — PIM for Entra roles and PIM for Groups, tiered custom vs. built-in role design, emergency access account design and incident response
Identity Governance — Access Reviews (with Graph-based investigation), Entitlement Management (catalogs, tiered access packages, multi-stage approval), Terms of Use
Authentication — SSPR with method-eligibility troubleshooting (FIDO2 vs. TOTP vs. passkey), Temporary Access Pass for onboarding
What I'd still like to build
Lifecycle Workflows (joiner/mover/leaver automation) requires the standalone Microsoft Entra ID Governance license, separate from P1/P2. Rather than pay for a feature I could study conceptually, I reviewed the documentation and reference implementations instead — a deliberate scoping decision, not an oversight.
Built independently as a self-directed learning project. Happy to walk through any part of this in more detail.
## access review audit 
[audit-memo.pdf](https://github.com/user-attachments/files/32779563/audit-memo.pdf)
# Access Review Audit Memo Template

Use one of these per completed access review. Keep it to one page — an auditor wants to find the answer fast, not read a narrative.

---

## TEMPLATE

**Memo title:** [System/Group] Access Review — [Period, e.g. Q3 2026]
**Prepared by:** [Name]
**Date prepared:** [Date]

**1. Scope**
- What was reviewed: [group/role/resource name]
- Why it was in scope: [e.g. "carries User Administrator privileged role"]
- Population size: [X members reviewed]

**2. Method**
- Review type: [access review / manual audit / etc.]
- Reviewer(s): [name/title — not just "self" in a real org]
- Review window: [start date – end date]
- Recurrence: [one-time / monthly / quarterly / annually]
- Supporting data used: [e.g. "department and job title pulled via Microsoft Graph, since not shown in the native review UI"]

**3. Findings**
- [Number] members had no clear justification for holding this access: [brief reason, e.g. "outside the department the role is scoped to"]
- [Number] members confirmed appropriate: [brief reason]
- [Any other anomalies: dormant accounts, unclear ownership, etc.]

**4. Decisions & Actions Taken**
- Approved: [list or count, with justification summary]
- Denied/Removed: [list or count, with justification summary]
- Access removal confirmed: [Yes/No — state how verified, e.g. "confirmed removed from group membership post-review"]

**5. Evidence Location**
- [Where the raw review export, screenshots, or approval records are stored]

**6. Next Review Due**
- [Date]

**7. Notes / Follow-ups**
- [Anything flagged for a future review, e.g. "recommend converting group to enforce stricter approval on future additions"]
<img width="963" height="673" alt="top ara memo" src="https://github.com/user-attachments/assets/57805be8-74e8-4737-8a5b-980755e68c2d" />
<img width="961" height="688" alt="mid ara emo" src="https://github.com/user-attachments/assets/3ff2b6d9-e5a1-4bcd-8212-5de0ff9fd4f9" />
<img width="970" height="688" alt="bottom ara memo" src="https://github.com/user-attachments/assets/839598fb-491f-4ad0-9246-bd215c52511f" />

## full log of project in order
[entra_id_lab_project_log.pdf](https://github.com/user-attachments/files/32779702/entra_id_lab_project_log.pdf)
**Entra ID Lab — Audit Log**
**Tenant**: mini***gmail.onmicrosoft.com **Purpose**: Personal Entra ID lab for hands-on IAM practice **Maintained by**: [Alejandro Nunez]
1. Tenant & User Setup
-Set up Azure Free Account ($200 credit, 30-day trial)
-Bulk-created 50 users via CSV import (Bulk create in Entra admin center)
--Departments: IT, Sales, Finance, HR, Marketing (10 users each)
--Usage locations: alternating US / SE (Sweden)
--Attributes set: displayName, department, jobTitle, usageLocation, country
-Confirmed built-in attributes (department, jobTitle, usageLocation) are stored directly on each user's Properties tab — no separate storage location
2. Licensing
-Activated Microsoft Entra ID P2 trial (30 days, up to 100 licenses)
--Note: required payment details on file (known current requirement); does **not** auto-convert to paid — reverts to Free automatically after 30 days if not renewed
--Avoided the generic Microsoft 365 Business trial path (25-user quantity, auto-converts to paid) — confirmed this was the wrong flow before entering payment info
-Investigated Microsoft 365 Developer Program as a no-payment alternative — determined not eligible under current tightened criteria
-Bulk-assigned P2 license to all users via **group-based licensing**:
--Used existing dynamic groups Dynamic-Sweden-Users (usageLocation -eq "SE") and a companion Dynamic-USA-Users (usageLocation -eq "US") — together covering all 50 users regardless of department
--Assigned P2 license to both groups rather than individual users
--Break-glass accounts confirmed **not** members of either group — remain unlicensed by design, consistent with keeping break-glass independent of every premium-dependent system (CA, PIM, dynamic groups)
3. Groups
-Created static security groups (by department, early in lab)
-Created dynamic security groups:
--Dynamic-Sweden-Users — rule: (user.usageLocation -eq "SE")
--Dynamic-IT-Department — rule: (user.department -eq "IT")
--Dynamic-Sales-Department — created via Microsoft Graph API (POST /groups), same rule pattern: (user.department -eq "Sales")
-Created a **role-assignable group** (originally RoleGroup-Helpdesk-Leads / User Admin group)
--Static membership only (required for role-assignable groups)
--Members: all IT department users + users from other departments (test case for access review — 4 non-IT members)
--Assigned User Administrator role to the group
--Used in first access review (see Section 10)
-**Refined into a two-tier role-assignable group structure**:
--RoleGroup-HelpdeskLead — new group, static membership, assigned the **custom Helpdesk Lead role** (password reset + read-only profile). Migrated relevant members over from the original User Admin group.
--RoleGroup-UserAdmin — the original group, renamed and repurposed (rather than rebuilt from scratch) to keep it as the broader tier, still holding the built-in **User Administrator** role
--Deliberately kept simple: two clearly differentiated tiers (custom minimal role vs. built-in broader role), not a Tier 1/Tier 2 helpdesk split — avoids redundant/overlapping options in the eventual access package catalog
--Both use **Active** role assignment (not PIM-eligible) — privileged access is time-bound instead via access package expiration policies rather than per-activation PIM
-**Finding**: custom security attributes cannot be used in dynamic group membership rules — only built-in attributes (department, usageLocation, employeeType, extensionAttribute1-15, etc.) are supported
4. Administrative Units
-Created a standard Administrative Unit ("Sweden Office"), added members manually, assigned Helpdesk Lead role scoped to the AU
-Created as **Restricted Management Administrative Unit** to test stricter scoping (blocks even Global Admins from managing members directly without an AU-scoped role)
-Converted to a **dynamic AU** (Sweden-Dynamic-AU) — rule: (user.usageLocation -eq "SE")
--**Finding:** dynamic AU membership requires every member (not just the admin) to hold a P1/P2 license — different from static AU membership, where only the admin needs the premium license
-**Finding**: adding a dynamic group as a member of an AU only brings the group object into scope, not the group's individual members — does not achieve the same effect as a dynamic AU rule
5. Custom Roles & Custom Security Attributes
-Designed and built a custom role: **Helpdesk Lead**
--Permissions: microsoft.directory/users/password/update, microsoft.directory/users/standard/read
--Deliberately excluded: user deletion, group membership changes, Conditional Access management
--Compared against built-in Helpdesk Administrator role (which additionally includes session invalidation, Microsoft support ticket management, and service health monitoring — a broader, fixed bundle vs. the itemized 2-permission custom role)
-Created a custom security attribute set with attribute BreakGlass (value: True)
--Assigned to all 5 break-glass accounts
--**Finding**: custom security attributes are useful for audit/reporting (e.g. Graph queries) but cannot drive dynamic group rules, dynamic AU rules, or Conditional Access user exclusions — used built-in employeeType attribute instead for actual exclusion logic
6. Break-Glass (Emergency Access) Accounts
-Created 5 break-glass accounts following Microsoft's recommended pattern:
--Default *.onmicrosoft.com domain (not custom/federated)
--Generic, non-personal display names
--Long, random passwords; password never expires
--Permanent (not PIM-eligible) Global Administrator assignment
--No license assigned
--Excluded from all Conditional Access policies via a dedicated Break-Glass-Accounts group
-**Incident**: experienced a full CA lockout (AADSTS53003) after enabling the phishing-resistant MFA admin policy without a registered method
--Resolved via break-glass account sign-in, switched offending policy back to Report-only, registered Windows Hello for Business, re-enabled
-**Finding**: even correctly CA-excluded break-glass accounts were still prompted for MFA. Root cause identified as a **Microsoft-managed Conditional Access policy, "Require multifactor authentication for admins"** — auto-created by Microsoft (not authored by tenant admin), targets admin roles, and enforces **Authentication strength: Passwordless MFA** (accepts FIDO2, Windows Hello for Business, or Microsoft Authenticator passwordless phone sign-in). This policy applies independently of custom CA policy exclusions.
-Confirmed by testing: un-excluding a personal test account from custom policies surfaced the Microsoft-managed policy's grant-control failure directly ("The user could satisfy this authentication strength by registering for one or more MFA methods") — verifying the policy is real, active, and evaluated separately from any tenant-authored policy.
-**Action**: admin/break-glass accounts need a registered Passwordless-MFA-eligible method (FIDO2, Windows Hello for Business, or Authenticator passwordless) to satisfy this Microsoft-managed policy, regardless of exclusions configured elsewhere.
-**Troubleshooting note**: initial attempt to resolve using an existing "FIDO2" registration failed — investigation revealed the account only had password + Authenticator TOTP registered (TOTP always requires a password, so it can never satisfy a passwordless tier). A Chrome "sign in with a passkey" prompt was also found to be a **Google account passkey**, unrelated to Entra. Resolved by enabling the Passkey (FIDO2) authentication method policy in Entra and registering a genuine **passkey in Microsoft Authenticator** (device-bound FIDO2 credential) via Security info — confirmed working, satisfies both Passwordless MFA and Phishing-resistant MFA authentication strengths.
7. Conditional Access Policies
All policies built Report-only first, verified via sign-in logs, then switched to On. All exclude Break-Glass-Accounts.
| Policy | Assignment |	Grant Control |
|-----|-----|-----|
Require MFA - All Standard Users	"All users, All resources"	Require multifactor authentication
Block Legacy Authentication	"All users, legacy client apps only"	Block access
Require MFA - Azure Management	"All users, Azure Management app"	Require multifactor authentication
Require Phishing-Resistant MFA - Admins	Directory roles (admin roles)	Require authentication strength: Phishing-resistant MFA
Require MFA - Protect CA Changes	"All users (test group), Authentication context"	Require multifactor authentication
Sign-in Risk - Require MFA	"All users, sign-in risk Medium/High"	Require multifactor authentication + Sign-in frequency: Every time
User Risk - Require Risk Remediation	"All users, user risk High"	Require risk remediation (replaces manual MFA + password change combo)


-Created an **Authentication Context** ("Protect CA Changes") and linked it to a **Protected Action** (modifying Conditional Access policies) — requires step-up MFA even for an already-authenticated admin before CA policies can be changed
-Set up the **MFA registration policy** (Identity Protection) — 14-day grace period for users without a registered MFA method, excludes break-glass
**Finding — new user first sign-in blocked by CA:** signing in as a newly created user for the first time triggered a block from the "Require MFA" policy, since a brand-new account has no MFA method registered yet and therefore can't satisfy the grant control — a chicken-and-egg problem (can't sign in without MFA, can't register MFA without signing in). Resolved by issuing a **Temporary Access Pass (TAP)** for the new user: a time-limited, admin-generated passcode that lets a user sign in and complete MFA registration without needing a password or existing method first. This is the standard, documented pattern for onboarding new users into an MFA-enforced tenant, and ties directly into the MFA registration policy above — TAP is generally how that 14-day registration grace period is actually satisfied for brand-new accounts in practice.
8. Identity Protection
-Migrated risk policies to Conditional Access ahead of the legacy Identity Protection risk policy retirement (Oct 1, 2026), rather than using the deprecated standalone pages
-Confirmed distinction: sign-in risk (per-attempt suspicious signal, remediated via MFA) vs. user risk (account-level compromise signal, remediated via risk remediation / password reset)
9. Authentication & SSPR
-Enabled and configured Self-Service Password Reset (SSPR)
--Scope tested on a subset before considering tenant-wide rollout
--Required 2 authentication methods
--**Finding**: FIDO2 is authentication-only and not eligible as an SSPR method; Microsoft Authenticator (push/"tap") and software OATH tokens are SSPR-eligible, but "tap" and standard Authenticator push count as the same method, not two independent ones
-Registered a software OATH token (via Microsoft Authenticator's "different authenticator app" / OTP mode) as a distinct second method
10. Identity Governance — Access Reviews
-Completed first full access review cycle:
--**Scope**: RoleGroup-Helpdesk-Leads (User Administrator role-assignable group)
--**Reviewer**: self
--**Duration:** weekly recurrence
--**Settings**: justification required on all decisions, recommendations enabled
--**Findings**: 4 of the group's members had no departmental justification for User Administrator access (outside IT)
--**Decisions**: approved all IT department members based on job function; denied and removed the 4 non-IT members per least privilege
--**Applied results** — role access removed automatically for denied members (role-assignable group)
**Supporting technique — Microsoft Graph query for reviewer context:** The access review UI doesn't surface department/job title, so pulled group membership with those attributes directly via Microsoft Graph in Graph Explorer:
GET https://graph.microsoft.com/v1.0/groups/{group-id}/members?$select=displayName,department,jobTitle,userPrincipalName
-Troubleshooting encountered: initial attempt failed with "This API is not supported for MSA accounts" — resolved by signing into Graph Explorer with the tenant admin account instead of a personal Microsoft account
-Second failure: "Insufficient privileges" — resolved by consenting to the GroupMember.Read.All permission scope within Graph Explorer itself (a separate requirement from holding the Global Administrator directory role)
-**Finding**: directory roles (portal permissions) and Graph API permission scopes (app-level consent) are two independent axes — holding Global Administrator does not automatically grant an application like Graph Explorer permission to query the directory on your behalf
11. Identity Governance — Entitlement Management
-Created Privileged-Access-Catalog — dedicated catalog for role-assignable groups, kept separate from general resource access so it can have distinct ownership/oversight
--Added RoleGroup-HelpdeskLead and RoleGroup-UserAdmin as resources
--**Built two tiered access packages in Privileged-Access-Catalog:**
--**Helpdesk Lead Access** — grants RoleGroup-HelpdeskLead (Member role). Requesters: Dynamic-IT-Department. Approval: 1 stage, requestor + approver justification required. Expiration: 30 days, extension allowed with re-approval.
--**User Administrator Access** — grants RoleGroup-UserAdmin (Member role). Requesters: Dynamic-IT-Department. Approval: 2 stages, requestor + approver justification required. Expiration: 14 days (shorter, reflecting broader privilege), extension allowed with re-approval.
--Confirmed **Member** (not Owner) is the correct resource role selection — Owner only grants group-management rights, not the inherited directory role
-**Tested full request → approve → grant flow** for both packages using a test user removed from the role groups beforehand (simulating a lapsed-access/re-request scenario rather than a fresh onboarding)
--Wrote distinct, specific requestor justifications for each package (Helpdesk Lead: routine re-request tied to ongoing ticket work; User Administrator: explicitly justified the need for the broader role's session-invalidation capability, not just restating "I need access")
--Wrote distinct approver justifications per stage — stage 1 focused on validating the request itself, stage 2 (User Administrator only) focused on final review of scope/expiration/conflicts, to keep the two-stage process meaningful rather than a duplicate rubber stamp
-**Finding**: plain "Catalog owner" (an entitlement management role) is explicitly insufficient to manage role-assignable groups within a catalog — even User Administrator is blocked from this. Managing a role-assignable group in entitlement management requires either Global Administrator/Privileged Role Administrator, or being both Catalog owner and an owner of that specific role-assignable group. A deliberate protection preventing catalog delegation from becoming a backdoor into privileged groups.
-**Finding**: dynamic groups can be added to an entitlement management catalog/access package, but only the "Owner" role is selectable for them — "Member" isn't available, since membership is rule-driven and can't be manually granted via a request. Used a static/assigned group instead where the goal was granting membership access.
12. Identity Governance — Lifecycle Workflows
-**Finding:** Lifecycle Workflows requires the standalone **Microsoft Entra ID Governance** add-on license, separate from P1/P2 — unlike Access Reviews and Entitlement Management, which run on P1/P2 alone. Confirmed by attempting to access Lifecycle Workflows under the active P2 trial and hitting a license requirement.
-Concept understood — automates joiner (welcome email, group/access assignment, Temporary Access Pass), mover (role/attribute-change-triggered access updates), and leaver (account disable, license/group removal) scenarios based on attribute or date-based triggers, using dynamic scoping rules similar to dynamic groups.
-**Decision**: rather than activating an additional paid license tier for a single feature, chose to study Lifecycle Workflows conceptually (documentation/video walkthroughs) instead of hands-on lab implementation. Reasonable tradeoff given the rest of the Governance suite (Access Reviews, Entitlement Management, PIM) was already implemented hands-on with real configuration decisions and troubleshooting.
13. Identity Governance — Terms of Use
-Created a one-page PDF ("Lab Environment Acceptable Use Terms") covering authorized use, privileged access expectations, logging/review, and incident reporting
-Uploaded via Identity governance > Terms of use > New terms ("Lab Environment Acceptable Use")
-Configured to expire per-user starting on the date of consent (rather than a shared publish date), set to a short window for lab testing purposes — chosen specifically so re-prompt/expiration behavior could be observed without waiting on a long shared calendar date
-Built a Conditional Access policy requiring acceptance ("Require Terms of Use Acceptance"), targeting All resources with Terms of use as the grant control
-Tested and confirmed: test user prompted to view/accept before proceeding; consent recorded with timestamp/IP under Terms of use > View acceptance status
14. Privileged Identity Management (PIM)
**PIM for Microsoft Entra roles:**
-Assigned built-in **Helpdesk Administrator** role directly to a test user as **Eligible** (not the custom Helpdesk Lead role, since that's already in active use via the role-assignable group/access package flow — kept this exercise independent to isolate PIM mechanics)
-Configured activation settings: max duration 4 hours, justification required, approval required, MFA on activation
-Tested full cycle: activated as test user with justification → approved as admin → confirmed Active status during window → reviewed Audit history
**PIM for Groups — two scenarios tested:**
-Considered enabling PIM for Groups on RoleGroup-HelpdeskLead, but identified a conflict: the test user already held standing membership via the access package's 30-day expiration grant, which would run in parallel with PIM eligibility and be confusing to test cleanly — deferred in favor of a cleaner, independent scenario below
-Built HR-CompensationData-Access — a plain (non-role-assignable) static security group modeling a common real-world PIM-for-Groups use case: just-in-time access to sensitive compensation/payroll data, rather than standing access
--Activation settings: 4-hour max duration, justification required, approval required
--Assigned an **HR Manager** test user as Eligible Member — deliberately chosen over an HR Coordinator, since Manager-level HR staff are a more realistic candidate for compensation data visibility (mirrors the department-vs-actual-need reasoning from the earlier access review)
--Tested full cycle: activation → approval → verified active membership during window → audit history reviewed
-**Finding**: dynamic groups cannot be enabled in PIM for Groups at all (as the target/protected group). Considered whether a dynamic group could instead be used as the eligible member being granted access (nesting), rather than the protected group itself — documentation confirms one group can be an eligible member of another, but only static-group examples are given; no clear confirmation either way for dynamic groups in that specific role. Decided against it regardless: tying PIM eligibility to a dynamic group would let anyone matching the group's rule become automatically eligible with no individual review, undermining the entire point of requiring deliberate, reviewed eligibility assignment. Used an individual named user instead.
Status: Core lab complete
All planned areas covered hands-on except Lifecycle Workflows, which was studied conceptually rather than implemented due to its separate license requirement (see Section 12).
Log started retroactively covering all work completed to date. Update after each new lab session.
