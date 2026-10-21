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

<img width="322" height="269" alt="onboarding" src="https://github.com/user-attachments/assets/492c039d-4207-48c0-9007-6b59fbbc3556" />
## Joiner

Trigger: HR enters the new hire in the HR system . That either creates an onboarding ticket or feeds the identity platform automatically. Often the account is created before the start date.

What the analyst does:

Confirm the request is legitimate. The ticket should come from HR or the hiring manager, not just anyone claiming someone is starting.
Create the account (or verify the automation created it) with the correct attributes: department, job title, manager, location. These attributes matter because dynamic groups and policies key off them. Your lab showed this: a wrong usageLocation or department breaks licensing and group membership.
Assign baseline access. Most orgs define a role-based access bundle per job role such as email, Teams, and the department’s shared drive.
Handle credentials safely. Give the user a Temporary Access Pass or a first-login process so they can register MFA, instead of emailing a password. I experienced this in my lab.
Document = ticket with what was granted and who approved it.

Common failures: Missing manager attribute, access copied from “another person in the same role” (which copies their creep too), and accounts created late so the person starts with no access.

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

## What this demonstrates

This proves out automating the identity lifecycle end-to-end so deprovisioning is guaranteed, not dependent on human follow-through. Everything in this lab: dynamic groups, entitlement management, and access reviews all assume identities enter and exit the system cleanly, and lifecycle workflows are what actually makes that true by tying provisioning and deprovisioning directly to an authoritative source of truth (HR attributes) instead of a manual ticket queue. The core principle is that offboarding is a security control, not just an HR formality — the single biggest identity risk in most real environments isn't a misconfigured policy, it's a departed employee whose access nobody remembered to remove.
