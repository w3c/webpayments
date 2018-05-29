# Proposal to Manage Card Network Identifiers Separate from Basic Card Spec

Proposed by @ibjacobs. On 5 Jan 2017 the WPWG [resolved](https://www.w3.org/2017/01/05-wpwg-minutes#item03) to adopt this approach, pending discussion of the trademark issue. See the [published list](https://www.w3.org/Payments/card-network-ids).

Todo: Ian to confirm W3C ok with this.

## Intro

[Basic Card Payment](https://w3c.github.io/webpayments-methods-card/)
defines supportedNetworks as a sequence of identifiers for card
networks accepted by the merchant. User agent support for identifiers
will likely change over time, and perhaps more rapidly than the custom
for W3C to update its Recommnedations. This is a proposal
to publish the list separate from the specification.

## Proposal

* The Basic Card Payment specification will link to a list of network identifier published on w3.org, separate from the specification. These identifiers will be short strings.
* Changes to the list must be approved through a decision of the Web Payments Working Group.
* If the Web Payments Working Group closes, W3C management will take over responsibility for the network identifier list (including delegation of change authority to another W3C group). NOTE: W3C management has not yet reviewed or approved this proposal; it will need to do so because of the maintenance expectation.

## Notes on the Proposal

* To avoid confusion, we will not create two lists: one initial list in the specification and one "evolving" list by reference.
* Each entry in the list will include provenance information (date of approval, link to group decision)
* Patent policy implications: because list will be published outside the specification and subject to a different update process than the Recommendation Track, it will presumably not be subject to W3C Patent Policy obligations.

## Initial List of Identifiers

In alphabetic order:

* amex
* diners
* discover
* jcb
* mastercard
* mir
* unionpay
* visa

## Open questions

* Mechanics of publishing. Because changes should only happen as a result of
a WG decision, I think that write access should be limited to Chairs and Team contacts, at least initially.
* Do we need to address trademark in some way?
* Structure of network identifier list. Should include the policy, who owns the policy, the list of identifiers, contact information (the WG).


