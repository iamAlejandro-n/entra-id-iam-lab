# identity lifecycle

## Scenario

Onboarding and offboarding are usually handled by a patchwork of manual steps across different teams — HR updates a system, IT gets a ticket days later, someone eventually creates the account, and on the way out, disabling access often lags behind the person's actual last day (or gets missed entirely). That gap is a real risk: a departed employee with active credentials for days or weeks is a classic audit finding and a genuine attack vector. HR, IT, and security teams at any org with regular hiring and turnover need onboarding/offboarding to be automatic and triggered directly by an authoritative HR event (a hire date, a termination date), not by someone remembering to file or process a ticket on time.

## Configuration steps

1. In Entra admin center, go to Identity Governance > Lifecycle workflows > Workflows > New workflow.
2. Choose a template (e.g., "Onboard pre-hire employee," "Offboard employee" — or build custom).
3. Define the trigger: an attribute-based event, e.g., employeeHireDate equals today (for onboarding) or employeeLeaveDateTime equals today (for offboarding). In this lab, since there's no real HR feed, set/simulate these attributes manually on a test user to trigger the workflow.
4. Define scope: which users this workflow applies to (e.g., a dynamic rule matching a department or employee type).
5. Add tasks: for onboarding — generate a temporary access pass, add to onboarding groups, send a welcome email. for offboarding — remove all group/app role memberships, revoke sign-in sessions, disable the account, remove from the org chart.
6. Set the workflow schedule or run it on-demand for testing.(Entra runs lifecycle workflows on a recurring schedule, e.g., every 3 hours)
7. Enable the workflow.
8. Test: update the trigger attribute on a test user, run the workflow on-demand, and check the Workflow history/run details to confirm each task executed successfully (account disabled, groups removed, etc.).

## Screenshot
do to license restrictions ive decided that i would do it the manual way.



## Joiner

Trigger: HR enters the new hire in the HR system . That either creates an onboarding ticket or feeds the identity platform automatically. Often the account is created before the start date.

What the analyst does:

Confirm the request is legitimate. The ticket should come from HR or the hiring manager, not just anyone claiming someone is starting.
Create the account (or verify the automation created it) with the correct attributes: department, job title, manager, location. These attributes matter because dynamic groups and policies key off them. Your lab showed this: a wrong usageLocation or department breaks licensing and group membership.
Assign baseline access. Most orgs define a role-based access bundle per job role such as email, Teams, and the department’s shared drive.
Handle credentials safely. Give the user a Temporary Access Pass or a first-login process so they can register MFA, instead of emailing a password. I experienced this in my lab.
Document = ticket with what was granted and who approved it.

Common failures: Missing manager attribute, access copied from “another person in the same role” (which copies their creep too), and accounts created late so the person starts with no access.

<img width="419" height="336" alt="onboarding" src="https://github.com/user-attachments/assets/602104df-a84b-4e60-ab6b-388388fa628d" /> first the account is created with attributes for dynamic access. in this example the It department will join the user to the IT group. This is used for RBAC.
<img width="922" height="299" alt="b4 access" src="https://github.com/user-attachments/assets/5b55cb01-8e75-4f0d-bcc6-1d25aa1cf36e" /> here are the entitlement resources only requested and access by the IT group
<img width="784" height="104" alt="app james" src="https://github.com/user-attachments/assets/0db9d749-e4f7-4012-952b-a3f38254326a" /> here are the apps assigned to the IT group

## Mover (transfer, promotion, department change)

This one is the most error-prone, so it’s where analysts add the most value.

Trigger: HR records a job or department change, or the manager submits a transfer ticket.

What the analyst does:

Update the attributes (department, title, manager). If dynamic groups exist, some access updates automatically.
Add the new role’s access through the normal request process.
Remove the old role’s access. Nobody asks for this, so the analyst has to look for it. Compare what the person has against what the new role should have.
Check for conflicts. The new role plus leftover old access might create a segregation of duties problem, such as someone who moved from Accounts Payable to Vendor Management and can now both create vendors and approve payments.
Review privileged access. If the old role had admin rights, confirm they’re gone.

Common failure: Access creep. New access gets added and old access never gets removed. This is what periodic access reviews exist to catch, like the four non-IT users I found with User Administrator rights.
<img width="1540" height="286" alt="group update" src="https://github.com/user-attachments/assets/99879638-a542-46b4-b3cb-0c64ce7c1af5" /> After changing departments from IT to sales the groups automatically changed
<img width="1807" height="574" alt="new access package" src="https://github.com/user-attachments/assets/ebcc8fe6-3f5c-4377-a0f6-348ea3299d38" /> the access package also changed and is only showing what is available to the sales group. The previous resources do not show up. 
<img width="1416" height="391" alt="app update" src="https://github.com/user-attachments/assets/0876a7b9-e074-4a1d-babe-77315b52e2be" /> the apps also updated to show what the sales group has access to and the app for It is not present.
## Leaver

Trigger: HR submits the termination, with an effective date and time. For involuntary terminations this is urgent and often time-critical, sometimes within minutes.

What the analyst does:

Disable the account at the effective time. Disable first and delete later, so you keep the audit trail and can recover if something goes wrong.
Revoke sessions and tokens and reset the password, so existing logins stop working.
Remove group memberships, roles, and app access, including privileged roles and any PIM eligibility.
Handle licenses and devices. Reclaim the license, and make sure the device is wiped, retired, or returned 
Deal with ownership. If the person owned groups, apps, service accounts, or approvals, reassign them. Orphaned ownership is a real audit finding.
Preserve data per policy (mailbox, OneDrive) and then schedule deletion.
Document it with timestamps

Common failures: Delayed offboarding, forgotten SaaS apps that aren’t tied to the central directory, and shared or service accounts the person knew the password for.


already did pieces of each:

Joiner: Bulk user creation, the Temporary Access Pass for first sign-in, and group-based licensing.
Mover: Dynamic groups reacting to the department attribute, plus access reviews catching leftover access.
Leaver: Access package expiration and removal when a review denies access.

<img width="268" height="673" alt="accDisable" src="https://github.com/user-attachments/assets/4edecb76-cf79-4b91-a387-65751b8e34ec" /> 
disable account is the first step
<img width="781" height="181" alt="redo mfa auth" src="https://github.com/user-attachments/assets/0090555f-4d03-48bf-b461-cac5b46bf07c" /> 
remove authentication already registered 
<img width="613" height="139" alt="revoke session" src="https://github.com/user-attachments/assets/4c4e1d21-0ab8-4e57-bdb1-7d8b0be1d9a3" /> 
remove session tokens so sign out the user from all accounts 
<img width="565" height="85" alt="lockedaccount" src="https://github.com/user-attachments/assets/92ec9aec-98c3-42ab-a324-2d3673a599fc" /> 
user attempting to log in while account disabled. while this we remove all access previously shown 

## What this demonstrates

This proves out automating the identity lifecycle end-to-end so deprovisioning is guaranteed, not dependent on human follow-through. Everything in this lab: dynamic groups, entitlement management, and access reviews all assume identities enter and exit the system cleanly, and lifecycle workflows are what actually makes that true by tying provisioning and deprovisioning directly to an authoritative source of truth (HR attributes) instead of a manual ticket queue. The core principle is that offboarding is a security control, not just an HR formality — the single biggest identity risk in most real environments isn't a misconfigured policy, it's a departed employee whose access nobody remembered to remove.
