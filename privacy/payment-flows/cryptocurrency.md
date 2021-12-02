# Cryptocurrency
<sup>[Home][home] > [Payment Flows][payment-flows] > Cryptocurrency</sup>

Cryptocurrency attempts to address the problem of global payment
interoperability. Merchants (or their payment processors) that accept
cryptocurrency don't need to be interoperable with the user's bank or foreign
currency, as long as they are using the same cryptocurrency network (e.g.
Bitcoin).

Payments involve the user sending funds from their cryptocurrency wallet to an
address provided by the merchant for checkout. Many merchants that accept
cryptocurrency use a third party payment processor that handles the
cryptocurrency transaction and then sends payment to the merchant.

## User flow

When a user chooses to pay with cryptocurrency, they are presented with a
receiving address, and are free to choose how they want to transmit funds to
this receiving address, e.g. by scanning the receiving address QR code with
their mobile app wallet, or using a browser extension.

Advanced users may use their own cryptocurrency wallet to send funds, meaning
they own the underlying cryptographic keys, and sign and transmit the
transaction themselves. Many users will instead use a 'custodial' wallet, which
is a service where they have set up an account to hold their cryptocurrency, and
direct the service to send payment to the merchant address. In this case, the
custodial service owns the cryptographic keys and signs the transaction on
behalf of the user. In either case, the user does not have to transmit sensitive
information such as their credit card over the web to the merchant to complete
the transaction, as the transaction is settled on the cryptocurrency network.

## User information

While a cryptocurrency transaction may be visible on a public ledger, the
information is not necessarily tied to the user or merchant's identity, and
cannot possibly be used to forge another transaction fraudulently. Transactions
generally contain a sending and receiving address, but these addresses are not
directly tied to the user or merchant. Analysis of a cryptocurrency's public
transaction ledger may trace who the sender and receiver is, though users may
also choose to use more advanced cryptocurrency technologies to enhance their
privacy.

[home]: ../README.md
[payment-flows]: README.md
