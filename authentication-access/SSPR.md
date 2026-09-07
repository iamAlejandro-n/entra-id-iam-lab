# self service password reset

## Scenario

Forgotten passwords are one of the highest-volume tickets any IT helpdesk handles — and every one of those tickets costs time, costs money, and (if the verification process is weak) is a social-engineering risk in itself, since a helpdesk tech resetting a password over the phone has to trust the caller is who they claim to be. Every organization with more than a handful of users needs a way for people to prove their own identity through pre-registered methods and reset their own password without ever calling IT. This especially matters for large user bases where password-reset volume alone can overwhelm a helpdesk, and for security teams who want a consistent, auditable verification process instead of an inconsistent human judgment call on the phone. 
## Configuration steps

1. In Entra admin center, go to Identity > Users > All users > Password reset.
2. Set "Self service password reset enabled" to All or a scoped group 
3. Under Authentication methods, choose how many methods are required and which methods count (Authenticator app, email)  enable strong methods
4. Under Registration, set whether users are required to register at next sign-in and configure the number of days before re-confirming their methods.
5. Under Notifications, decide whether admins get notified when other admins reset their own passwords, and whether users are notified of resets on their other registered devices (both should be on for security visibility).
6. confirm choices and test policy.

## Screenshot

**1**)in password reset i enabled the feature starting with a small group the it group **2**) I set the requirement to two methods. **3**)turn on notifications for when users or admins when password was changed 
<img width="1920" height="1080" alt="sspr methods1" src="https://github.com/user-attachments/assets/56937dbc-cbca-439d-8e84-fb4352fc6390" />
<img width="1920" height="1080" alt="sspr methods2" src="https://github.com/user-attachments/assets/db0dade3-4b53-4317-955e-1080a5b593fa" />
**4**)a user was prompted to set up a second authentication method which was email **5**) after adding email it confirms the two methods to reset password. **6**) here was me activating a password reset. **7**) and here are the 2 conditions which was authenticator otp and the email.



## What this demonstrates

This proves out self-service identity verification replacing human trust — the principle that identity proofing should rely on something the user registered and controls rather than a helpdesk agent's judgment call, which is inconsistent and exploitable. It's really an extension of the authentication-strength concept: SSPR is only as secure as the methods required to use it, so requiring two strong factors to reset a password closes a common social-engineering gap where attackers reset a victim's password by impersonating them over the phone. It demonstrates that convenience (self-service) and security (verified identity proofing) aren't in tension when designed correctly.
