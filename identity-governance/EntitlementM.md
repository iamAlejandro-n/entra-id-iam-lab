# Entitlement Management 

## Scenario

Requesting access the traditional way — emailing IT, filing a ticket, waiting for someone to manually add you to five different groups and grant three app permissions — is slow and inconsistent, and it puts the burden on IT to know exactly what a "new marketing contractor" or "new finance analyst" needs. It also creates access sprawl: once granted, that access often has no expiration and nobody circles back to check if it's still needed. Managers and project leads (not just IT) need a way to package "everything a person in this role needs" — groups, app roles, SharePoint sites — into one requestable bundle that business owners (not IT) can approve, with access that automatically expires or requires periodic reconfirmation. This matters most for orgs with frequent onboarding into standard roles, cross-department collaboration, or contractor/vendor access that should never be permanent by default.
## Configuration steps

1. In Entra admin center, go to Identity Governance > Entitlement management > Catalogs, and create a new catalog to hold related resources. (e.g., "Marketing Team Resources").
2. Add resources to the catalog — groups, Teams, SharePoint sites, or enterprise apps that make up the bundle.
3. Go to Access packages > New access package, name it, and link it to the catalog.
4. Under Resource roles, select which resources from the catalog to include and which role/permission level for each (e.g., "Member" for a group).
5. Under Requests, define who can request it (specific users, a connected organization, or all internal users) and configure a multi-stage approval — e.g., stage 1: manager approval, stage 2: resource owner approval — with justification required.
6. Under Lifecycle, set an access expiration (e.g., 90 days) and whether access requires periodic re-approval to continue.
7. Publish the access package.
8. As a requester, go to the My Access portal, find the package, submit a request with justification.
9. As each approver, approve their stage in sequence and confirm the requester only gains access after all stages complete.
10. Confirm access automatically expires (or triggers a re-request) at the configured date.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out policy-driven, business-owner-delegated access provisioning with built-in lifecycle management — shifting "who gets access" decisions from IT (who often lack context on whether someone should have access) to the people who actually own the resource or manage the requester, while still enforcing structure (approval chains, justification, expiration) around that decision. It demonstrates that access shouldn't just be easy to grant — it should be just as easy to expire, closing the classic gap where access is provisioned once and never revisited. This is entitlement management's core value: making the right access easy to get and the stale access automatically go away.
