# User creation and bulk import

## Scenario
Organizations need new users everyday and sometimes hundreds of users at a time. Adding them manually through the Entra portal can be fine for a handful of users but can be **time consuming** and **error prone** when you need hundreds of users fast. A solution is using bulk import, a **repeatable** way to provision dozens or thousands of accounts with consistent, correct attributes (department, job title, usage location, manager) all at once. **HR and IT** admins need this because inconsistent or missing attributes break everything downstream: dynamic groups won't catch the user, Conditional Access policies scoped by attribute won't apply correctly, license assignment (which depends on usage location) will fail, and access reviews/reporting become unreliable. more auditable.

## Configuration steps

1. In Entra admin center, go to Identity > Users > All users > Bulk operations > Bulk create.
2. Download the provided CSV template.
3. Populate required columns (userPrincipalName, displayName, password, etc.) plus attributes your downstream policies depend on — department, jobTitle, usageLocation, city — since these drive dynamic group membership and licensing.
4. Upload the completed CSV and submit the bulk create job.
5. Monitor the bulk operation results blade for per-row success/failure and fix any rejected rows (usually bad UPN format or duplicate usernames).
6. Spot-check a few created accounts to confirm attributes landed correctly.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![here is a screenshot of the csv](<img width="1920" height="1080" alt="bulkcreate" src="https://github.com/user-attachments/assets/2d5721c6-671b-4582-822c-b5a3ca644b61" />)

## What this demonstrates

This isn't really about the CSV upload mechanic — it's proving that identity attributes are the foundation everything else in IAM keys off of. Dynamic group membership, Conditional Access scoping, license assignment, and RBAC/PIM eligibility all evaluate user attributes rather than manual list membership. Getting attribute data accurate and consistent at the point of creation is what makes every automated policy downstream trustworthy. In other words: this exercise demonstrates attribute-driven identity lifecycle management — the principle that clean data in equals reliable automated access control out.
