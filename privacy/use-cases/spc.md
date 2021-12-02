# Secure Payment Confirmation enrollment status
<sup>[Home][home] > [Use Cases][use-cases] > Secure Payment Confirmation</sup>

[Secure Payment Confirmation][spc-spec] (SPC) is a Web API in-development in the
W3C [Web Payments Working Group][wpwg], which brings [WebAuthn][webauthn-spec]
to payments to enable secure, privacy-respecting authentication. As of November
2021, SPC has shipped on Google Chrome.

## Use of third-party cookies

Whilst SPC does not directly rely on third-party cookies, they can be used as a
mechanism to track enrollment status (to avoid re-enrolling a user). This stems
from an [underlying issue in WebAuthn][webauthn-issue-1639], but is exacerbated
in SPC because [SPC allows enrollment in a cross-origin
iframe][spc-spec-3p-enrollment]. For example, during a 3DS flow the bank iframe
may challenge the user with a 'traditional' challenge flow (e.g., SMS OTP) and
then, upon success, offer to enroll the user in SPC for future authentications.

See [SPC issue #124][spc-issue-124].

Note that this detection problem also extends to knowing whether to use SPC at
**authentication** time for a given user, but the problem is slightly different
as SPC is designed to be called on origins other than the Relying Party's (e.g.,
`merchant1.com`, `merchant2.com`, etc). Those origins may have no prior
interaction with the user and SPC, so even third-party cookies do not suffice.

## Expected impact

If third-party cookies are unavailable, then a Relying Party will be unable to
know whether or not to offer a given user enrollment into SPC. Unconditionally
offering enrollment would be feasible, but may led to user confusion and/or
friction, as they might be re-enrolling an already-enrolled device.

Example flow, in the case where a user *has* already registered this device for
SPC previously but - for example - the merchant does not support SPC.

1. Merchant initiates 3DS for the current transaction.
2. The 3DS ACS indicates that the user must be challenged, and returns a bank
   URL for the Merchant to open.
3. Merchant opens the URL in an iframe (which is cross-origin and thus does not
   have cookie access).
4. Inside the iframe, the bank authenticates the user via, e.g., SMS OTP.
5. The bank now wishes to know if it should offer to register the user in SPC.
   However since it is inside a cross-origin iframe, it cannot detect the
   earlier registration of the user and so does not know!

## Possible alternatives

As-yet, no concrete proposals have been made.

[home]: ../README.md
[use-cases]: README.md
[spc-spec]: https://w3c.github.io/secure-payment-confirmation/
[wpwg]: https://www.w3.org/Payments/WG/
[webauthn-spec]: https://github.com/w3c/webauthn
[webauthn-issue-1639]: https://github.com/w3c/webauthn/issues/1639
[spc-spec-3p-enrollment]: https://w3c.github.io/secure-payment-confirmation/#sctn-use-case-iframe-registration
[spc-issue-124]: https://github.com/w3c/secure-payment-confirmation/issues/124
