# Instrument Selection 

This is a draft for discussion. Questions? Ian Jacobs or Adrian Hope-Bailie.

## Introduction

One design goal of Payment Request API is to streamline checkout by making it easy for users to reuse stored payment credentials.

The Web Payments Working Group is discussing a proposal for [Secure
Payment
Confirmation (SPC)](https://github.com/rsolomakhin/secure-payment-confirmation). That
initial proposal focuses on streamlining authentication by leveraging
Web Authentication within the context of Payment Request API. It
explicitly excludes access to stored payment credentials.

The current document intends to support discussion of how to re-introduce payment credential selection as part of Secure Payment Confirmation.


## Storage Scenarios

Different parties, in different flows, may wish to store payment credentials.
During Payment Request API, the browser would display payment credentials (matching the payment methods accepted by the merchant) from all of these sources.

### Payment App

In these use cases, the payment app registers a payment credential
with the browser. Benefits of this approach:

* Payment apps can add, update, or delete payment credentials when the user is interacting with the app.
* Payment apps can communicate with servers (e.g., to fetch a nonce for authentication).

One design goal is to enable payment apps to not display user experience for payment credential selection and authentication. Thus, payment apps should be able to provide the browser with information so that the browser can display payment credentials and authenticate the user, and return to the payment app the corresponding information. The payment app should not have to open its own window. It might wish to do so, e.g., for failure scenarios.

### Browser

In these use cases, a relying party registers a payment credential with the browser (e.g., through some new part of the Payment Handler API). Benefits of this approach:

* The relying party does not need to distribute a payment app.

In this approach, the party that calls Payment Request API is notified
when the user selects a payment credential. That party responsible for
providing any information necessary for authentication.

### Merchant

Merchants may be the source of payment credentials (e.g., guest
checkout with form input, or card-on-file use cases). Benefits of this
approach:

* Allows a harmonized user experience by supporting integration of card-on-file use cases with other stored payment credentials known to the browser.
* Leverages existing trust relationships on the merchant side (e.g., between
merchant and payment service provider).
* Does not require payment app distribution.

In this approach, the party that calls Payment Request API is notified
when the user selects a payment credential. That party responsible for
providing any information necessary for authentication.

## General Flow

At a high level, the SPC flow that includes payment credential selection is this:

### Enrollment

* Parties enroll payment credentials with the browser.
* Note: Merchants should be able to enroll payment credentials at transaction time for card-on-file use cases. This could be done through PR API or some new API that is also used by payment apps to register payment credentials.

### Transaction

* The user pushes a button, triggering Payment Request API.
* The browser displays registered payment credentials to the user according to the payment methods accepted by the merchant.
* The user selects a payment credential.
* This triggers a credential selection event in the relevant context. If the payment credential was registered by a payment app, the payment app receives the event. if the payment credential is not "owned" by a payment app, then the party that called payment request API receives the event. All of this happens during <code>show()</code>.
* Information about the selected payment credential enables (but does not require) the responsible party (payment app or PR API caller) to request SPC authentication by the browser. The responsible party may provide a nonce or request that the browser generate one. Note: Different payment flows may trust different nonce origins.
* The browser authenticates the user.
* The browser returns the authentication assertion to the responsible party.
* Payment Request API completes.

## Payment Credential Data Model

One goal is to define a minimal payment credential data model that can be used across payment methods.

* Display (for selection, authentication)
  * icon (URL to image)
  * displayName (string)

* Identification
  * paymentMethodIdentifier (string). It is possible that a payment credential might be usable with more than one payment method; see the [proposal from Adrian Hope-Bailie for no payment handler flows](https://github.com/rsolomakhin/secure-payment-confirmation/issues/17).
  * instrumentID (string, unique and opaque). See [issue 24](https://github.com/rsolomakhin/secure-payment-confirmation/issues/24) regarding privacy of this identifier.
  * routing (string). See [Issue 21](https://github.com/rsolomakhin/secure-payment-confirmation/issues/21) for use cases of merchant-side handling. This field could be optional for use cases where the instrumentID includes routing information (e.g., PAN).

* Authentication credentials
  * credentialID(s). This might be WebAuthn credential IDs. But see below for notes on supporting other authentication protocols.

## Design Considerations

### Payment Credential Storage 

* Any origin can register a payment credential. Ideally, the same API could be used by payment apps and merchants (and thus, the capability might not belong in the Payment Handler API).

* The origin that registered the credential can delete or update it when the user is in a 1p context.



## SPC 

Some of these considerations have arisen through discussion of payment credential selection. These may be more about SPC authentication than instrument selection.

* The system should support use cases where there is no authentication after selection of an instrument.

* Although initial discussions of Secure Payment Confirmation focus on
Web Authentication, the system should support other authentication mechanisms than Web Authentication. (This might be a requirement on SPC rather than the instrument selection aspect.)

* The system should not impose constraints on who the relying party can be.

* During SPC flows, a nonce is used as part of Web Authentication.
SPC should not constrain how WebAuthn nonce is created ([issue 26](https://github.com/rsolomakhin/secure-payment-confirmation/issues/26)).

