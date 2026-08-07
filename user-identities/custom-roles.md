# custom and build-in roles

## Scenario
Built-in roles (like User Administrator or Helpdesk Administrator) are broad, Microsoft-defined bundles of permissions — they often grant **more than a specific job actually needs**. A helpdesk tech who should only be able to reset passwords might get a built-in role that also lets them create/delete users or manage licenses, which **violates least privilege**. Security teams and compliance-driven organizations (finance, healthcare, government contractors — anywhere audits matter) need the ability to build a role with the exact set of permissions a job requires, no more. This matters any time a built-in role is "close enough but not quite right" — e.g., a role that can only reset passwords for a specific department but nothing else, or a role that can read sign-in logs but not modify anything. Custom roles let admins match access precisely to job function instead of picking the closest oversized built-in option.

## Configuration steps

1. In Entra admin center, go to Identity > Roles & admins > Roles & admins > New custom role.
2. Start new or clone an existing built-in role as a baseline ( you just remove permissions you don't need).
3. Name role and add a description explaining its intended scope.
4. Permissions tab, select only the specific permissions needed (e.g., microsoft.directory/users/password/update for a password-reset-only role). then create role.
5. Go to Identity > Users (or an Administrative Unit) > Roles and administrators, find your custom role, and assign it to a user or group — optionally scoped to an AU.
6. Test with the assigned account: confirm they can perform the permitted action and are blocked from anything outside that permission set.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This demonstrates **least privilege** enforced at the permission level, not just the role level — giving just enough permissions to be granted to do the job function. 
