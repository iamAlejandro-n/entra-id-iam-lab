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

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out automating the identity lifecycle end-to-end so deprovisioning is guaranteed, not dependent on human follow-through. Everything in this lab: dynamic groups, entitlement management, and access reviews all assume identities enter and exit the system cleanly, and lifecycle workflows are what actually makes that true by tying provisioning and deprovisioning directly to an authoritative source of truth (HR attributes) instead of a manual ticket queue. The core principle is that offboarding is a security control, not just an HR formality — the single biggest identity risk in most real environments isn't a misconfigured policy, it's a departed employee whose access nobody remembered to remove.
