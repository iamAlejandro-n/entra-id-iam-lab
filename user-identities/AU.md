# [Administrative Units]

## Scenario
Administrative units is a very important tool in any tenant to create a **container** of users, groups, computers.
Global admin roles grant control over the entire tenant — every user, every group, every device, everywhere. That's a problem the moment an org has more than one region, department, or business unit, because giving a helpdesk team in one office global User Administrator rights means they can also reset the CEO's password or manage users in a department they have nothing to do with. This is a real need for any organization with delegated IT — school districts, universities, multi-national companies, or holding companies with separate subsidiaries. Admins need Administrative Units so they can **scope**a role assignment down to a specific slice of the directory instead of handing out tenant-wide power just to let someone reset passwords for their own team.
## Configuration steps

1. In Entra admin center, go to Identity > Roles & admins > Administrative units > New administrative unit.
2. Name it and give it a description.
3. Add members — either statically assign or configure it as a dynamic administrative unit with a membership rule (same rule-builder as dynamic groups) so it self-populates by attribute.
4. Go to the administrative unit's "Roles and administrators" blade.
5. Assign a role (e.g., Helpdesk Administrator or User Administrator) scoped to a specific user or group — this scopes that role assignment to only members of this AU, not the whole tenant.
6. Test with the delegated admin account: confirm they can manage users inside the AU (e.g., reset password) and confirm they get an "access denied" for a user outside the AU.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves **least privilege** through scoped delegation — the principle that administrative power should be bounded to the smallest scope necessary for the job, not granted at the broadest scope for convenience. It's the organizational/structural counterpart to RBAC: RBAC controls what actions a role can take, while Administrative Units control where (over which set of objects) that role applies. 
