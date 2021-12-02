# Bank-based Payments
<sup>[Home][home] > [Payment Flows][payment-flows] > Bank-based Payments</sup>

Bank-based payment flows involve the user initiating payment to a merchant
directly using their bank account without any intermediary party (e.g., a credit
card network or digital wallet provider). They are generally split into the
following types:

- **Bank Debit**, in which the user provides their bank details to the
  Merchant and the merchant *pulls* the funds from the user.
- **Bank Credit**, in which the Merchant provides their bank details to the
  user, and the user *pushes* funds from their account to the Merchant.
- **Bank Redirect**, in which the user visits their online banking portal
  during the transaction, approves the transaction, and then returns to the
  Merchant site.

NOTE: The term 'redirect' here refers to the user flow of being sent to their
      bank for payment, and not to the specific technology of performing a URL
      navigation.

Most uses in e-commerce are **Bank Redirect**, followed by some **Bank Debit**.
Instances of **Bank Credit** flows are rare in e-commerce, outside of singular
large payments (e.g. purchasing a car outright).

## Common user flows

### Bank Debit

### Bank Credit

### Bank Redirect

## Examples of Bank-based Payments

These lists are non-exhaustive and potentially incorrect.

**Bank Debit**

* Bacs
* BECS
* SEPA
* PADS

**Bank Credit**

* Multibanco

**Bank Redirect**

* Bancontact
* EPS
* FPX
* giropay
* iDEAL
* P24
* Sofort

[home]: ../README.md
[payment-flows]: README.md
