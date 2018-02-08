# Interledger Payment Method

Interledger is an open protocol suite for sending payments across different payment networks. It defines a set of standards for payment initiation, account addressing, reconciliation and proof-of-payment as well as a protocol for synchronizing multiple independent transfers on multiple payment networks to facilitate a single end-to-end payment.

## Vision

The Interledger protocol (ILP) is modelled on the Internet protocols, in that it is a protocol for inter-networking multiple networks. As more participants, in more payment networks, adopt the ILP standards a new open, global, payment network will emerge that is overlaid over all existing and new payment networks. This may include open networks built on modern technology stacks such as Bitcoin, Ethereum and XRP but also closed networks such as legacy ACH and card systems.

Initially the Interledger standards can be adopted within small sub-nets or even for payments between known counter-parties so that in time these networks are able to connect to form the global Interledger.

## Interledger

The Interledger protocol is a standard for payment messages that can be passed over any payment network.

Participants in a payment (called **connectors**) provide connectivity between two networks by accepting an Interledger request packet from a peer on one network, routing the message onwards to a peer on another network and then passing the subsequent response (or error) back to the sending peer.

An Interledger request packet contains 4 headers and a body of payment data that is only intended to be processed by the receiver (it will often be encrypted). The headers include:
 1. An ILP Address that is used to route the packet,
 2. An amount that must be paid from the sender to the next peer who the packet is sent to,
 3. An expiry before which the response must be received for the payment to be completed successfully, and 
 4. A condition that must be fulfilled in the response for the response to be considered valid.

In forwarding an Interledger request the connector agrees to accept payment of the amount specified in the ILP packet, from the peer sending the packet, and commits to paying the amount they place in the outgoing packet to the peer they send it to; if the payment is completed successfully.

The payment is considered *complete* (from the perspective of this connector) if they receive and forward a _valid_ Interledger response packet to the peer that sent the request, *before* the expiry that was specified in the request.

Requests contain a 32-byte **condition** (a SHA-256 hash of an unknown 32-byte pre-image) and _valid_ responses contain the **fulfillment** of that condition (the correct 32-byte pre-image for the hash in the request).

Connectors will copy the **address**, **condition** and **data** from an incoming packet directly into the outgoing packet but will specify a new:

 - **amount** that will be paid to the next peer, in the currency of the account between these peers. If the currency of the incoming request and outgoing response differ then the connector will apply an appropriate exchange rate. The connector will also apply any fees they wish to charge so the outgoing amount may be less than the incoming amount even where the currency is the same.

 - **expiry** that is less than the expiry for the incoming request. The difference between these two values is the time that the connector considers "safe" to process the response and forward it on. In doing this they avoid the risk that they will receive a valid response just before it expires (and therefore owe their upstream peer money) but not have enough time to pass this downstream before the expiry of the incoming request (therefore lose out on the money owed to them for forwarding the request).

The mechanism for clearing and settlement of these payments between peers is not defined by the protocol so it is left to peers to define the terms of their accounts with one another; whether these are pre-funded or not and over which network these payments are cleared and settled.

## Benefits

Beyond the potential of inter-networking multiple payments networks, using the Interledger standard offers significant benefits to any real-time payment interactions.

Specifically the protocol defines a set of simple standards that have the potential to increase the interoperability between participants in the following areas: 

### Account Discovery and Routing

Interledger defines a universal addressing scheme for accounts. Any system of value can use the ILP Addressing scheme to identify its accounts and in doing so, make these discoverable and addressable outside of the system's operational domain.

The system is hierarchical in nature (similar to PANs, IBANs and IP Addresses) to make routing a payment to the destination account simple.

However, unlike many other addressing schemes, ILP Addresses are variable length allowing a great deal of flexibility and unencumbered growth of the address space while still being space efficient in messages.

Most importantly, due to their hierarchical form, data can be appended as a suffix to an address without altering which account the address points to. The result is that a new address can be used for every payment, dramatically improving the scope for innovative reconciliation solutions.

Example:

A receiver whose account has the ILP Address `g.coinbase.145b3dEskk1a7Uw4gWBdpa8NFEwbfz2MgT` could request a sender to send to `g.coinbase.145b3dEskk1a7Uw4gWBdpa8NFEwbfz2MgT.12345`. This payment will be routed to the receiver who will be able to infer contextual information from the address suffix (`12345`).

More details on addressing can be found in [ILP RFC 15 - Interledger Addresses](https://interledger.org/rfcs/0015-ilp-addresses/)

### Invoices, Receipts and Reconciliation

One of the biggest challenges in payments processing is the exchange of commercial information related to a payment and the reconciliation of a payment with other commercial artifacts such as invoices and receipts.

The execution of a payment in ILP is dependent on the exchange of a secret (called a **fulfillment**) between the receiver and the sender. The receiver only makes the fulfillment public when they are certain they will receive the payment, therefore the sender can use the fulfillment as proof (with some limitations) that the receiver was paid.

The recommended mechanism for generating the fulfillment is to perform an HMAC of the payment data, thereby cryptographically binding the fulfillment to the payment itself.

Before initiating the payment, the sender will get a SHA-256 hash digest (a non-reversible function) of the fulfillment (called the **condition**) and attach this to the payment.

These two simple pieces of data can then be used during reconciliation of the payment both between connectors when clearing and settling their accounts and between the payer and payee. The fulfillment and the condition are both unique but also cryptographically bound to the payment details. If any of the payment details are altered the fulfillment and therefore the condition will not be valid.

This leaves applications open to define appropriate formats for digital invoices and receipts  but provides a well defined standard for identifiers that can be derived from the document content itself and leveraged in various ways to facilitate document discovery, sharing and reconciliation. (Example: content-based addressing for commercial documents)

### Payment Orchestration

Interledger defines an orchestration that can be applied over any funding source and any recipient account so makes for a versatile standard for payment messages.

1. Payee provides account details (ILP Address) and payment request (amount, condition and payment data)
2. Payer initiates ILP payment to the address provided, using the condition provided and payment data in an end-to-end encrypted packet
3. Payment is routed over one or more payment networks by connectors
4. Payee decrypts payment data, verifies integrity and responds with the fulfillment and any response data (also encrypted).
5. Payment response is passed back to payer via the same route as the request
6. Payer verifies fulfillment and decrypts response data.

## Payment Pointers

The Interledger payment method leverages **Payment Pointers**, a standard for payee identifiers that can be resolved to an HTTPS endpoint where payers are able to discover information about a payment.

More information about payment pointers can be found in [ILP RFC 26 - Payment Pointers](https://interledger.org/rfcs/0026-payment-pointers/).

## Flow

The flow of the Interledger payment method when used with the Payment Request API will be as follows:

### Payment Request

The payee website will call the Payment Request API providing a payment pointer for the payment. This may be a single-use pointer with some transaction reference in the pointer or a multi-use pointer that the payee reuses in multiple payment requests.

Example:
 - A single-use pointer `$payments.amazon.com/38215454-da56-448e-bb06-85fc15dddf76`
 - A multi-use pointer `$bobshardware.stripe.com` or `$merchants.stripe.com/bobshardware`

```javascript
const supportedPaymentMethods = [
  {
    supportedMethods: 'interledger',
    data: {
      payee: '$bobshardware.stripe.com'
    }
  }
];
```

### Payment Handler

A Payment Handler that is capable of making ILP payments will parse and resolve the payment pointer and then request the payment information from the resolved receiver endpoint.

Example Request:

```http
GET /.well-known/pay HTTP/1.1
Host: bobshardware.stripe.com
Accept: application/spsp+json
```

Example Response:

```http
HTTP/1.1 200 OK
Content-Type: application/spsp+json

{
  "destination_account": "g.stripe.bobshardware.38215454da56448ebb...",
  "shared_secret": "6jR5iNIVRvqeasJeCty6C-YB5X9FhSOUPCL_5nha5Vs",
  "maximum_destination_amount": "100000",
  "minimum_destination_amount": "10",
  "ledger_info": {
    "currency_code": "USD",
    "currency_scale": 2
  },
  "receiver_info": {
    "name": "Bob's Hardware",
    "image_url": "https://bobshardware.stripe.com/logo.jpg"
  }
}
```

The Payment Handler may perform the necessary authentication of the user and use the provided `receiver_info` to assist the user in verifying the payee.

Following this it will perform the ILP payment which will result in either an ILP error or a fulfillment.


### Payment Response


After completing the ILP payment to the provided address the response data to the merchant will include the address that was paid and the fulfillment.

This data can be used by the website to consult a back-end API to further verify that the payment was completed as expected.

## Opportunities

As `interledger` is an open payment method it will require explicit implementation by browsers. This is an opportunity for browsers to assist in securing the payment by implementing the Payment Pointer protocol in the browser and simply returning the result of this to the Payment Handler.

In this way the browser can perform additional security steps such as filtering the receiver endpoint URL against known malicious origins, ensuring that the certificates used by the receiver endpoint meet strict security standards or enforcing further security measures such as requiring that the origin of the receiver endpoint is the same as (or explicitly trusted by) the origin of the Payment Request API caller.