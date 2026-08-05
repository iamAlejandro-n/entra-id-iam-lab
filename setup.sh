#!/usr/bin/env bash
# setup.sh — scaffolds the entra-id-iam-lab repo structure
# Usage: bash setup.sh [target-dir]   (defaults to ./entra-id-iam-lab)

set -euo pipefail

TARGET="${1:-entra-id-iam-lab}"

if [ -d "$TARGET" ]; then
  echo "Error: '$TARGET' already exists. Choose a different name or remove it first."
  exit 1
fi

mkdir -p "$TARGET"/docs/01-user-identities
mkdir -p "$TARGET"/docs/02-authentication-access
mkdir -p "$TARGET"/docs/04-identity-governance
mkdir -p "$TARGET"/diagrams
mkdir -p "$TARGET"/screenshots

touch "$TARGET"/diagrams/.gitkeep
touch "$TARGET"/screenshots/.gitkeep

# --- Root README ---
cat > "$TARGET"/README.md << 'EOF'
# Entra ID IAM Lab

A hands-on Microsoft Entra ID lab built to learn and demonstrate identity and access management
concepts, aligned to Microsoft's **SC-300: Identity and Access Administrator** exam objectives.

Rather than just studying for the exam, this repo documents each concept as a real configuration —
built, screenshotted, and explained in terms of the problem it solves, not just the steps to click through.

**Jump to:** [User Identities](docs/01-user-identities) · [Authentication & Access](docs/02-authentication-access) · [Identity Governance](docs/04-identity-governance)

## Scope

This lab focuses on three of the four SC-300 domains:

| # | SC-300 Domain | Weight | Covered here |
|---|----------------|--------|--------------|
| 1 | Implement and manage user identities | 20-25% | ✅ [docs/01-user-identities](docs/01-user-identities) |
| 2 | Implement authentication and access management | 25-30% | ✅ [docs/02-authentication-access](docs/02-authentication-access) |
| 3 | Plan and implement workload identities | 20-25% | ⛔ out of scope |
| 4 | Plan and implement identity governance | 20-25% | ✅ [docs/04-identity-governance](docs/04-identity-governance) |

## Environment

- Microsoft 365 Developer Program tenant (free, sample users/groups)
- Microsoft Entra ID P2 trial (required for PIM, access reviews, entitlement management,
  Identity Protection risk policies)

### Reproducing this lab

1. Sign up for the [Microsoft 365 Developer Program](https://developer.microsoft.com/microsoft-365/dev-program) — free tenant with sample users/groups
2. Activate a free Entra ID P2 trial from the Entra admin center (**Identity Governance** → **Licenses**)
3. Follow the write-ups under `docs/` in order — each one is self-contained

## Repo structure

```
entra-id-iam-lab/
├── README.md
├── docs/
│   ├── 01-user-identities/
│   ├── 02-authentication-access/
│   └── 04-identity-governance/
├── diagrams/        # architecture / policy flow diagrams
└── screenshots/     # tenant ID, UPNs, and object GUIDs redacted
```

## How each topic is documented

Every write-up under `docs/` follows the same format:

1. **Scenario** — the real-world problem this configuration solves
2. **Configuration steps** — what was built in the portal/PowerShell/Graph
3. **Screenshot(s)** — redacted evidence of the working configuration
4. **What this demonstrates** — the underlying IAM concept, not just the click-path

## Status

🚧 In progress — see individual domain folders for current coverage.
EOF

# --- Domain 1 index ---
cat > "$TARGET"/docs/01-user-identities/README.md << 'EOF'
# Domain 1: Implement and Manage User Identities

SC-300 weight: 20-25%

## Topics

- [ ] User creation & bulk import (CSV)
- [ ] Dynamic groups (rule-based membership)
- [ ] Administrative units & delegated helpdesk role
- [ ] Custom vs. built-in roles, least-privilege assignment
- [ ] External identities — B2B guest invite & cross-tenant access settings
- [ ] Hybrid identity concepts (Entra Connect / Cloud Sync)

Each checked topic links to its own write-up (scenario → steps → screenshot → concept) once documented.
EOF

# --- Domain 2 index ---
cat > "$TARGET"/docs/02-authentication-access/README.md << 'EOF'
# Domain 2: Implement Authentication and Access Management

SC-300 weight: 25-30%

## Topics

- [ ] Authentication methods policy (Authenticator push, FIDO2/passkeys)
- [ ] Self-service password reset (SSPR)
- [ ] Conditional Access — block legacy auth
- [ ] Conditional Access — require MFA for admin roles
- [ ] Conditional Access — require compliant device
- [ ] Conditional Access — location-based block
- [ ] Authentication strengths / authentication context
- [ ] Identity Protection — user risk policy
- [ ] Identity Protection — sign-in risk policy
- [ ] Global Secure Access (optional stretch topic)

Each checked topic links to its own write-up (scenario → steps → screenshot → concept) once documented.
EOF

# --- Domain 4 index ---
cat > "$TARGET"/docs/04-identity-governance/README.md << 'EOF'
# Domain 4: Plan and Implement Identity Governance

SC-300 weight: 20-25%

## Topics

- [ ] Privileged Identity Management (PIM) — eligible vs. active role assignment
- [ ] PIM — role activation with approval + justification
- [ ] PIM — access review on a privileged role
- [ ] Entitlement management — access package with multi-stage approval
- [ ] Access reviews — group/app membership
- [ ] Lifecycle workflows — join/leave automation

Each checked topic links to its own write-up (scenario → steps → screenshot → concept) once documented.
EOF

# --- Reusable topic template ---
cat > "$TARGET"/docs/_template.md << 'EOF'
# [Topic Name]

## Scenario

*What real-world problem does this configuration solve? Who needs it and why?*

## Configuration steps

1. ...
2. ...
3. ...

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

*The underlying IAM concept this exercise proves out — not just the click-path.*
EOF

# --- .gitignore ---
cat > "$TARGET"/.gitignore << 'EOF'
# OS junk
.DS_Store
Thumbs.db

# Raw/unredacted exports - review before ever removing this line
*-raw.png
*-unredacted.*
*.csv

# Editor
.vscode/
EOF

echo "Scaffold created at ./$TARGET"
echo
echo "Next steps:"
echo "  cd $TARGET"
echo "  git init && git add . && git commit -m \"Initial scaffold: SC-300 domain structure\""
