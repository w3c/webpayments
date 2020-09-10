# Instrument Selection 

*Note: This is a draft for discussion. Questions? Ian Jacobs or Adrian Hope-Bailie.

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

### Payment App

### Browser

### Merchant

## Payment Credential Data Model

One goal is to define a minimal payment credential data model that can be used across payment methods.

* Display (for selection, authentication)
  * icon (URL to image)
  * displayName (string)

* Identification
  * instrumentID (string, unique and opaque). See [issue 24](https://github.com/rsolomakhin/secure-payment-confirmation/issues/24) regarding privacy of this identifier.
  * routing (string). See [Issue 21](https://github.com/rsolomakhin/secure-payment-confirmation/issues/21) for use cases of merchant-side handling. This field could be optional for use cases where the instrumentID includes routing information (e.g., PAN).

* Authentication credentials
  * credentialID(s). This might be WebAuthn credential IDs. But see below for notes on supporting other authentication protocols.

## Payment Credential Storage Design Considerations

* The party that owns the payment credential must be able to delete it when the user is in a 1p context.

* The party that owns the payment credential must be able to update it when the user is in a 1p context.

## SPC Design Considerations

Some of these considerations have arisen through discussion of payment credential selection.

* The system should support use cases where there is no authentication after selection of an instrument.

* Although initial discussions of Secure Payment Confirmation focus on
Web Authentication, the system should support other authentication mechanisms than Web Authentication. (This might be a requirement on SPC rather than the instrument selection aspect.)

* The system should not impose constraints on who the relying party can be.

* During SPC flows, a nonce is used as part of Web Authentication.
SPC should not constrain how WebAuthn nonce is created ([issue 26](https://github.com/rsolomakhin/secure-payment-confirmation/issues/26)).

