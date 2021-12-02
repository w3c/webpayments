# Payment Service Providers in Web Payments
<sup>[Home][home] > [Payment Flows][payment-flows] > Payment Service
Providers</sup>

[Payment Service Providers][psps-wikipedia] (PSPs) are companies that assist
merchants with accepting payments on the web. Whilst they themselves are not a
specific payment flow, how PSPs integrate with merchant websites to provide
their services is of interest when considering user privacy on the web.

## PSP-hosted Checkout flows

Some PSPs offer hosted checkout flows, wherein a merchant will perform a URL
redirect to the PSP's domain for their checkout experience. Once the checkout
is complete, the PSP will redirect back to the merchant. This usually involves
the PSP and merchant establishing a known transaction ID (via server-to-server
communication), which is then passed via URL parameters in the redirects.

Examples:

- [Stripe Checkout][stripe-checkout]

TODO: Do any PSPs do hosted flows via iframe embedding?

TODO: There are also hosted flows which include js/html from the PSP directly
      on the merchant's origin, e.g. Adyen's Drop-In.

## PSP-provided Checkout primitives

Some PSPs offer checkout primitives for Merchants to embed in their checkout
flows, providing services such as, e.g., a credit card entry field that will
validate credit card numbers. These primitives are often embedded in
cross-origin PSP iframes, and communicate with the top-level merchant site via
???.

TODO: Why are cross-origin iframes used for individual components?
TODO: How do the components communicate with the hosting site? (Could be
      `postMessage`, but could also bounce via servers).

Examples:

- [Adyen Components][adyen-components]
- [Stripe Elements][stripe-elements]

## PSP-code in a secure enclave

In order to keep the PSP isolated from the merchant site, some merchants and
PSPs opt to execute PSP code in a secure enclave - usually in the form of a
cross-origin iframe.

TODO: Implications of this?
TODO: Examples of this?

[home]: ../README.md
[payment-flows]: README.md
[psps-wikipedia]: https://en.wikipedia.org/wiki/Payment_service_provider
[stripe-checkout]: https://stripe.com/docs/payments/checkout
[adyen-components]: https://docs.adyen.com/online-payments/prebuilt-ui#components
[stripe-elements]: https://stripe.com/docs/payments/elements
