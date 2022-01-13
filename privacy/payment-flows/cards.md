# Card Payments
<sup>[Home][home] > [Payment Flows][payment-flows] > Card Payments</sup>

Card-based payments involve the user utilizing a payment card from a given card
network (e.g., American Express). The card network acts as an intermediary for
the merchant to interact with, (more or less) abstracting away the underlying
financial institution (e.g., bank) that the card is linked to.

There are many different types of cards, including but not limited to:

- Credit cards, in which a user can accumulate a balance to be later paid off.
- Debit cards, in which funds are immediately taken from an underlying financial
  account.
- Prepaid cards, in which funds are loaded onto the card prior to doing an
  online transaction.

Most cards have a similar flow during a checkout, and have similar properties
(e.g., the Merchant is paid immediately).

## Common User Flows

### Returning User Recognition

Examples:

* User logs into a merchant with whom the user has stored cards ("card on file")
* Cookies used to store profile information (e.g., for EMV&reg; Secure Remote Commerce)

### Instrument selection

Examples:

* Choosing from a card on file
* Entering card details, possibly assisted by autofill.
* Choosing a card from a payment handler.
* Choosing a card from a EMV&reg; Secure Remote Commerce selector.

### Authentication

Examples:

* EMV&reg; 3-D secure frictionless and challenge flows.

### Authorization

Note: W3C discussions have not focused on authorization, as this phase typically happens in the background (and not on the Web).

[home]: ../README.md
[payment-flows]: README.md
