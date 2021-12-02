# Payment Buttons
<sup>[Home][home] > [Use Cases][use-cases] > Payment Buttons</sup>

See also [this document](../payment-flows/digital-wallets.md) for an overview
of Payment Buttons in Digital Wallets.

## Conditionally-showing payment buttons

APIs to conditionally-show Digital Wallet payment buttons often rely upon
silently identifying the user. This is needed to determine whether the user has
a payment method available for use, that the merchant also accepts.

Such APIs usually involve a cross-origin fetch from the Merchant domain to the
Digital Wallet provider (e.g. a `POST` request to
`https://wallet.com/api/can-make-payment`). The Digital Wallet provider uses the
third-party cookies sent along with the request to identify the user and answer
the question in the reply.

### Expected Impact

If third-party cookies are unavailable, a naive Digital Wallet provider may
reply 'no' to all 'can make payment' style requests. This could result in that
provider's payment buttons being hidden even if the user could use them.

Alternatively, a Digital Wallet provider may detect the lack of cookies in
the request, and simply reply 'yes' instead. This would result in payment
buttons being shown regardless of whether or not they are currently usable
and may lead to a worsening of the [NASCAR problem][nascar].

### Possible Alternatives

- [Payment Handler][payment-handler-spec] currently provides an alterative
  in its [CanMakePaymentEvent][payment-handler-spec-canmakepayment]. However
  this event may be as prone to abuse as third-party cookies are, and thus may
  not be a long-term viable alternative.

## Customization of buttons

Some Digital Wallet providers dynamically customize the rendering of their
payment buttons for a better user experience, e.g. by showing the last four
digits of a registered card on the button. In order to protect this sensitive
information from the merchant, the details are often rendered in a cross-origin
iframe laid on top of the button. The iframe uses third-party cookies in order
to identify the user and fetch their card details.

### Expected Impact

If third-party cookies are unavailable, it will not be possible for the Digital
Wallet provider to silently detect who the user is, and thus button
customization of this form will not be possible.

### Possible Alternatives

There are no current concrete proposals. One emerging web-technology of interest
here may be [fenced frames](https://github.com/shivanigithub/fenced-frame).

[home]: ../README.md
[use-cases]: README.md
[nascar]: https://indieweb.org/NASCAR_problem
[payment-handler-spec]: https://w3c.github.io/payment-handler/
[payment-handler-spec-canmakepayment]: https://w3c.github.io/payment-handler/#the-canmakepaymentevent
