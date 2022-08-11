# Privacy in Web Payment APIs

Authors: [Rouslan Solomakhin](https://github.com/rsolomakhin),
         [Stephen McGruer](https://github.com/stephenmcgruer)

Last update: Aug 11, 2022

## Summary

This document is an overview of potential privacy issues in Web Payment APIs
(primarily [Payment Request](https://w3c.github.io/payment-request/) and
[Payment Handler](https://w3c.github.io/payment-handler/)) and potential
mitigations. Some of the mitigations overlap or may even supersede other
mitigations; this reflects both the uncertainty of the space and mitigations, as
well as the possibility of doing easier mitigations first followed by more
difficult ones.

| Privacy issue | Mitigation and open questions |
| --------------| ------------------------------|
| `"canmakepayment"`/`IS_READY_TO_PAY` event fields | Remove concerning data fields. |
| Tracking via `PaymentInstruments.set()`/`get()` | Remove `PaymentInstruments` API. |
| Using `canMakePayment()` to build UUID by querying multiple apps | Remove `PaymentInstruments` API, add some sort of trust model or user controls? |
| Timing attacks on `"canmakepayment"` / `IS_READY_TO_PAY` | Change to push model? |
| Payment Handlers not required to show UI | Enforce UI for payment apps. |

## Privacy model assumptions / notes

 - 'Merchant websites' and 'payment apps' may be malicious, and may collude.
 - A user agent acts on behalf of the user.

## Background on Web Payments APIs

### Types of Payment Apps

 - Browser-integrated payment apps - out of scope.
 - Web-based payment handlers, as defined by the
   [Payment Handler specification](https://w3c.github.io/payment-handler/#dfn-payment-handler):
   - These are 1p service-workers which are invoked to handle Payment Request
     APIs (including at construction time and for `show()`).
 - Native payment apps (e.g., Android apps):
   - We generally assume that native applications run in what would be
     considered a 1p context, albeit this is technically platform-specific.

### Installing Payment Apps

 - Built into the browser or pre-installed in some way - out of scope.
 - [Payment Handler spec](https://w3c.github.io/payment-handler): allows a
   first-party website to register a service worker and then utilize
   PaymentInstrument.set() to mark it as a payment app.
 - [Payment Method Manifest spec](https://w3c.github.io/payment-method-manifest/):
   defines a way for Web-based payment handlers to be “just in time” (JIT)
   installed during a purchase (during
   [`PaymentRequest.show()`](https://w3c.github.io/payment-request/#show-method))
   via a manifest file.

## Privacy Concerns

### `"canmakepayment"` and `IS_READY_TO_PAY`

When a Payment Request is constructed, the Payment Handler specification
[requires the user-agent to fire a `"canmakepayment"` event](https://w3c.github.io/payment-handler/#handling-a-canmakepaymentevent)[^event]
to any matching installed Service Workers. The Service Worker is able to handle
the event and return (via
[respondWith](https://w3c.github.io/payment-handler/#respondwith-method)) either
`true` or `false`.

[^event]: Not to be confused with the `canMakePayment()` **method** of the
    Payment Request API. The `"canmakepayment"` event is fired at> construction
    time, not in response to a `canMakePayment()` call, and is used to answer
    `hasEnrolledInstrument()` instead.

To support native Android apps, Chrome also
[fires an `IS_READY_TO_PAY` intent](https://web.dev/android-payment-apps-developers-guide/)
to the matching installed native applications.

The `"canmakepayment"` event (and `IS_READY_TO_PAY` intent)
[currently conveys](https://w3c.github.io/payment-handler/#canmakepaymenteventinit-dictionary)
the following information to the Payment App:

 - `topOrigin` - e.g. https://merchant.example (browser-determined)
 - `paymentRequestOrigin` - e.g. https://psp-iframe.example (browser-determined)
 - `methodData` - a sequence of arbitrary method data (merchant-supplied)

The transfer of this information is invisible to the user and without consent
(reminder that it happens on Payment Request **construction**, long before any
UI might be shown). Because Payment Apps run in a 1p context, it could be used
to track the user.

####Proposed Mitigation

Remove the `topOrigin`, `paymentRequestOrigin`, and `methodData` fields from
`"canmakepayment"` event. The payment app may still respond based on its own
knowledge (e.g., checking 1p data for this user), but that knowledge is
compressed into only one bit for the merchant to consume (`true`/`false`).

### Tracking via `PaymentInstruments.set()`/`get()`

The
[`PaymentInstruments.set()`](https://w3c.github.io/payment-handler/#paymentinstruments-interface)
method allows an attacker website to store arbitrary data, which can later be
retrieved via `PaymentInstruments.get()` potentially in a third-party context.

For example, the user visits https://tracker.example, which generates and stores
a UUID for that user via `PaymentInstruments.set(key, UUID)`. Later, the user
visits https://site.example, which opens an iframe for https://tracker.example.
That iframe calls `PaymentInstruments.get(key)` and can retrieve the UUID, thus
allowing https://tracker.example to know which user it is.

####Proposed Mitigation

Given the lack of uptake in `PaymentInstruments.set()`, versus the more common
JIT-install path, as well as the overly powerful nature of the
API[^instruments], we propose to remove PaymentInstruments entirely. Another
approach might be to restrict where `get()` can be called (e.g., only within the
Service Worker).

[^instruments]: `PaymentInstruments` was designed with the belief that the
    browser would know about individual payment methods (e.g., credit cards)
    rather than payment apps, hence the need to store/retrieve arbitrary
    information.

### `canMakePayment()` building UUID by querying multiple apps

The
[`PaymentRequest.canMakePayment()`](https://www.w3.org/TR/payment-request/#canmakepayment-method)
method allows a website to silently query the 'availability' of payment apps.
From the spec:

> 6. For each `paymentMethod` tuple in `request.[[serializedMethodData]]`:
>    1. Let identifier be the first element in the `paymentMethod` tuple.
>    2. If the user agent has a payment handler that supports handling payment
>       requests for identifier, resolve `hasHandlerPromise` with `true` and
>       terminate this algorithm.

If an attacker is able to install multiple payment apps, they can encode a UUID
as a set of installed payment apps (each for a different payment method, e.g.,
https://evil.example/1, https://evil.example/4, …). A colluding website can then
later construct a Payment Request for, and call `canMakePayment()` on each app
in turn. By checking whether the method returns `true` or `false`, the website
can build up the original UUID and thus allow tracking.

####Proposed Mitigation

The feasibility of this attack very much depends on the cost to install a
payment app, as it requires installing enough bits of entropy to track users.
Removing `PaymentInstruments.set()` would go a long way to mitigating it, as it
allows for silent installation. JIT-installed payment apps are much 'louder', as
it requires a user-activation per show() call, as well as user-visible
interaction (see below), so it may be OK to not act in that case.

Further mitigations here could involve some sort of 'trust' model around payment
apps, but it has not been explored significantly.

####Android Variant

Not technically in scope for Web Payment APIs, but sharing for transparency ---
there is a variant of the above attack where a single Android application lists
itself as able to handle (say) 32 different payment methods
(https://evil.example/1, https://evil.example/2, …). A website can then query
those payment methods in order via `canMakePayment()`, and the Android app can
respond with `true`/`false` to build up the UUID.

To mitigate this, we are likely to restrict the number of payment methods that a
single Android application can claim to handle.

### Timing attacks on `"canmakepayment"` / `IS_READY_TO_PAY`

Even if we tackle the above concerns around `"canmakepayment"` /
`IS_READY_TO_PAY`, there is still a timing attack possible.

In such an attack, the colluding website (https://site.example) first fires a
server-call to the tracker (https://tracker.example), informing the tracker that
it is about to construct a Payment Request. The colluding website then does so,
and a `"canmakepayment"` event is fired to the tracker's (already-installed)
payment app. Whilst this event contains no user data after the above
mitigations, the service worker (or native application) still has 1p context and
so can message its own server with its concept of the user's identity. The
https://tracker.example server then attempts to match up the initial server-call
with the canmakepayment event, and thus track the user.

####Possible Mitigations

One option would be to partition the Service Worker's storage, which would
remove its ability to access the 1p user information when handling the
`"canmakepayment"` event. However once a service worker opens a Payment Handler
window (which is a 1p context) in the `"paymentrequest"` event, it can receive
the payment app’s 1p identity for the user through `postMessage()` and store it
for later usage, thus negating the partitioning. In addition, a user agent has
no way to partition the storage of an OS-native (e.g., Android) app.

As an alternative, we have been considering a push model, in which installed
payment apps can proactively 'push' their response boolean (`true`/`false`) down
to the browser for future `"canmakepayment"` events. Then, when a Payment
Request is constructed, the browser just uses the cached value rather than call
into the Service Worker.

A final option would be to remove `"canmakepayment"`/`IS_READY_TO_PAY`
entirely, although we have not yet determined whether that is feasible. (It
certainly seems like it would break use-cases.)

### Payment Handlers not required to show UI

The Payment Handler specification currently does not require the Payment Handler
to show any visible UI to the user. Since the Payment Handler service worker
runs in a 1p context, this allows for invisible tracking of the user:

1. A colluding website (https://site.example) gets a user click (e.g., on a next
   button on the website UX).
1. It constructs a Payment Request for the tracker (https://tracker.example)
   and calls `show()`.
1. The tracker 'payment app' is JIT-installed (or was installed earlier via
   `PaymentInstrument.set()`), and receives a
   [PaymentRequestEvent](https://w3c.github.io/payment-handler/#the-paymentrequestevent).
    1. This event can contain arbitrary information from the colluding website,
       and the app is running in a 1p context.
1. The tracker 'payment app' **does not** call `openWindow()`. Instead, it reads
   its 1p state and sends the user information to its server (possibly along
   with shared information from the colluding website) and calls `respondWith()`
   to **silently** finish the Payment Request.

This attack is similar to opening and closing a pop-up window (or doing a bounce
redirect).

####Potential Mitigation

Mitigating this attack is likely to be up to the user agent. We intend to force
UI to be shown when `show()` is called. That makes sure that the user is aware
of what is happening, even if the app does not call `openWindow()`. Other
potential mitigations here might be to delay allowing `respondWith(`) to be
called immediately or to require a user interaction with the payment app before
allowing it to close (to avoid a 'flash of content' attack).

