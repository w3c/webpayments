# Digital Wallets
<sup>[Home][home] > [Payment Flows][payment-flows] > Digital Wallets</sup>

Digital Wallets (or e-Wallets) are payment services that allow users to pay
online using previously saved payment instruments or a stored balance. Usually
the Merchant will place a 'payment button' on the checkout page for a given
Digital Wallet; the user clicking on the button will initiate the Digital Wallet
experience.

NOTE: This document does not cover cryptocurrency wallets; see
      [here][cryptocurrency] for that.

## Common user flows

TODO: Should we add 'authenticate the user' as part of this? How common is
      that in digital wallets, vs trusting the identification?

### User interface for interacting with the wallet

The usual flow for a Digital Wallet, once invoked, is to present an interface
that:

1. Identifies the user (frictionlessly if possible),
1. Presents the user with details of the current transaction, and
1. Allows the user to select a payment instrument to use from their saved
   payment instruments or stored balance.

To achieve these goals, Digital Wallets usually rely on one of the following
approaches:

- **Redirect**
  - Provides a 1p context for reading, e.g., saved user identity.
  - Information about the transaction in progress is often passed via URL
    parameters, e.g. by passing a known transaction ID.

- **Pop-ups**
  - Provides a 1p context for reading, e.g., saved user identity.
  - Information about the transaction in progress is often passed via URL
    parameters, e.g., by passing a known transaction ID. It could also be
    passed in via `postMessage`.

- **Payment Request/Payment Handler**
  - Provides a 1p context for reading, e.g., saved user identity.
  - Information about the transaction in progress is passed via the JavaScript
    API entrypoint.

- **Native Integration**
  - Natively built into the browser or underlying platform, such that the user
    can be identified via non-web means.
  - Information about the transaction in progress is usually passed via a
    JavaScript API entrypoint (which may or may not be the Payment Request API).

### Dynamic update of transaction details based on user choice

Digital Wallets often allow the merchant to dynamically update the transaction
amount or details based on choices that the user makes inside the wallet
context. For example, the user may select a shipping address for which the
merchant would like to offer free shipping to, or the user may select a payment
method for which the merchant can offer a discount.

Some examples of such dynamic communication are:

- PayPal's [Shipping Change][paypal-shipping-change] callback.
- Apple Pay's [onpaymentmethodselected][applepay-change-event] event and other
  similar APIs.
- Google Pay's [onPaymentDataChanged][googlepay-change-event] event and other
  similar APIs.

To achieve this feature, Digital Wallets may rely on the following approaches:

- **Redirects** may use server-to-server communication, passing a
  previously-established transaction ID alongside the event details from the
  Digital Wallet or requested changes from the merchant.

- **Pop-ups** may use `postMessage` to communicate with the page that opened
  them.

TODO: Confirm that the above is how redirects/pop-ups tend to work.

- **Payment Request/Payment Handler** or **Native Integrations** provide
  JavaScript events and APIs to communicate between the top-level context (the
  merchant) and the embedded context (the Digital Wallet).

### Return payment details to merchant

The final step in a successful Digital Wallet flow is usually to return some
form of payment details to the merchant. The payment details minimally consist
of some form of payment token that the merchant can pass to their payment
gateway. The details may additionally include, e.g., the shipping address that
the merchant should ship the purchased goods to.

To achieve this feature, Digital Wallets may rely on the following approaches:

- **Redirect**-based wallets will usually perform another redirect back to the
  merchant page, passing a previously-established transaction ID in the URL
  parameters.

- **Pop-ups** may use `postMessage` to to communicate with the page that opened
  them, and can then close themselves (`window.close()`).

- **Payment Request/Payment Handler** or **Native Integrations** provide
  communication channels in their JavaScript APIs to communicate the result from
  the embedded context (the Digital Wallet) to the top-level context (the
  Merchant).

### Conditionally-shown payment buttons

Before the user even initiates a payment, some Digital Wallets offer the ability
for a Merchant to determine if the given user will be able to use the given
wallet provider to make a payment. This allows a Merchant to only show a given
payment button if the user can usefully interact with it.

Some examples are:

- PayPal's [`isEligible()`][paypal-iseligible].
- ApplePay's [`canMakePayments()`][applepay-canmakepayments] and
  [`canMakePaymentsWithActiveCard()`][applepay-canmakepaymentswithactivecard]
- Google Pay's [`isReadyToPay()`][googlepay-isreadytopay], including the
  [existingPaymentMethodRequired][googlepay-existingpaymentmethodrequired] flag.

These APIs usually require the Digital Wallet to **silently** determine
the following information:

1. The payment methods accepted by the Merchant.
1. The user's identity (from the wallet's viewpoint), and what payment methods
   the user has available to them.

TODO: It's unclear if PayPal's `isEligible()` performs any user-identity checks,
      or if it is checking some other form of 'eligibility'.

These APIs usually involve either the Merchant page communicating with the
Digital Wallet provider's servers directly, or the Merchant invoking a **Native
Integration** via some JavaScript API that will then do a similar communication.
  - In the former case, the Merchant passes the accepted payment methods via URL
    parameters, and the Digital Wallet determines the user identity via
    third-party cookies attached to the request.
  - In the latter case, the Merchant passes the accepted payment methods via the
    JavaScript-exposed API, and the Digital Wallet uses a non-web based method
    of determining the user identity.

In both cases, elements of the user's identity are returned to the Merchant, in
that they can determine whether a user can pay. The merchant could also mutate
the input (e.g. specifying different payment methods), and see if the reply is
different.

### Securely customize payment button based on user info

Some Digital Wallet providers customize their payment button based on the
current user, e.g. by showing details of a card that the user has previously
enrolled into the Digital Wallet provider.

Some examples are:

- [Google Pay button customization][googlepay-customize-button]

This feature usually require the Digital Wallet to **silently** determine
the following information:

1. The payment methods accepted by the Merchant, to filter what payment methods
   might be shown on the button.
1. The user's identity (from the wallet's viewpoint), and what payment methods
   the user has available to them.

Implementation of this feature usually involves a cross-origin iframe, which
allows the Digital Wallet provider to render the card details onto the page
without exposing the information to the Merchant. The Merchant usually provides
their accepted payment methods via URL parameters, and the users identity inside
the cross-origin iframe is determined via third-party cookies.

## Examples of Digital Wallets

This list is non-exhaustive and potentially incorrect.

* Alipay
* Amazon Pay
* Apple Pay
  * Technologies: **Native Integration**
* Click to Pay (aka SRC)
* Facebook Pay
* Google Pay
  * Technologies: **Pop-ups**, **Payment Request/Payment Handler** (Chrome),
                  **Native Integration** (Chrome Android)
* GrabPay
* Microsoft Pay
* PayPal
  * Technologies: **Pop-ups**
* Shop Pay
  * Technologies: **Redirect**
* WeChat Pay

[home]: ../README.md
[payment-flows]: README.md
[cryptocurrency]: cryptocurrency.md
[paypal-shipping-change]: https://developer.paypal.com/docs/checkout/integration-features/shipping-callback/
[applepay-change-event]: https://developer.apple.com/documentation/apple_pay_on_the_web/applepaysession/1778013-onpaymentmethodselected
[googlepay-change-event]: https://developers.google.com/pay/api/web/reference/client#onPaymentDataChanged
[paypal-iseligible]: https://developer.paypal.com/docs/business/javascript-sdk/javascript-sdk-reference/#paypalbuttonsiseligible
[applepay-canmakepayments]: https://developer.apple.com/documentation/apple_pay_on_the_web/applepaysession/1778027-canmakepayments
[applepay-canmakepaymentswithactivecard]: https://developer.apple.com/documentation/apple_pay_on_the_web/applepaysession/1778000-canmakepaymentswithactivecard
[googlepay-isreadytopay]: https://developers.google.com/pay/api/web/reference/client#isReadyToPay
[googlepay-existingpaymentmethodrequired]: https://developers.google.com/pay/api/web/reference/request-objects#existingPaymentMethodRequired
[googlepay-customize-button]: https://developers.googleblog.com/2021/05/updated-google-pay-button-increases-click-through-rates.html
