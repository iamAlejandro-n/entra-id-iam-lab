# Global secure access

## Scenario

Traditional network security assumed a perimeter — VPN into the corporate network, then trust everything inside it. That model breaks down with hybrid/remote work, cloud apps, and BYOD: users need secure access to internal resources, SaaS apps, and the internet from anywhere, but routing everyone through a legacy VPN concentrator is slow, doesn't scale, and (once someone's on the VPN) often grants broad network-level trust rather than identity-aware, per-resource access. IT and security teams at any org moving away from traditional VPNs — or supporting a distributed/remote workforce — need network access decisions to be made the same way app access decisions are: based on identity, device compliance, and Conditional Access policy, not just "are you on the network or not." Global Secure Access extends Entra's identity-based Conditional Access model down into network traffic itself, so access to private apps, Microsoft 365, and the internet all get evaluated per-request rather than granted wholesale once you're "in."
## Configuration steps

1. In Entra admin center, go to Global Secure Access > Get started, and enable the traffic forwarding profiles you want (Microsoft traffic, Private access, Internet access).
2. Under Private access, define an app segment (an internal app/IP range/port) via a connector group.
3. Install/configure the Private Network Connector on a server that can reach the internal resource 
4. Under Devices, note the requirement that the Global Secure Access client be installed on endpoints to enroll their traffic into the service.
5. Go to Protection > Conditional Access, and create a policy targeting the new "Global Secure Access" traffic profiles/cloud apps (e.g., require compliant device to reach the Private access profile) — this is the key step proving CA now governs network traffic, not just app sign-in.
6. Review the Global Secure Access traffic logs/dashboard to show per-request visibility into what's being evaluated and allowed/blocked.

## Screenshot

*(redact tenant ID, UPNs, and object GUIDs before committing)*

![description](../../screenshots/FILENAME.png)

## What this demonstrates

This proves out extending zero trust from the application layer to the network layer — the principle that "identity is the new perimeter" shouldn't stop at app sign-in; it should govern network-level access too, evaluated continuously and per-resource instead of granted wholesale via a VPN tunnel. It shows you understand that Conditional Access, device compliance, and risk signals are meant to be a unified policy engine covering everything a user touches — apps, data, and network — rather than separate, disconnected controls that can contradict each other or leave gaps. 
