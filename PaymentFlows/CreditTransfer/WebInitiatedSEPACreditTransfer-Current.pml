@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

participant "Payee (Merchant) Bank [Creditor Agent]" as MB
Participant "Payee (Merchant) PSP [Intermediary]" as MPSP
Participant "Payee (Merchant) Website [Creditor]" as Payee
participant "Payer's (Shopper's) Browser" as UA
Actor "Payer [Debtor]" as Payer
participant "Payer (Shopper) Bank [Debtor Agent]" as CB


note over MPSP, Payer: HTTPS

title PSP Mediated (SEPA) Credit Transfer (Current)

== Establish Payment Obligation ==

Payee->UA: Present Check-out page with Pay Button
Payer-[#blue]>UA: Press Pay
UA->MPSP: Request Payment Choice Pay

MPSP->UA: Payment Method Choice Page
Payer-[#blue]>UA:  Select Credit Transfer Payment Method
UA->MPSP: Request Credit Transfer Payment Information
MPSP->UA: Provide Credit Transfer Details (e.g. IBAN)
note right: These details are needed by the Payer to manually invoke the Credit Transfer out-of-band
Payer-[#blue]>UA: Press Agree
UA->MPSP: Payment Obligation Accepted
MPSP->UA: Result Screen "Pending Transfer"

MPSP-[#black]>Payee: Payment Notification (Pending)

Note over Payer: Payer now must invoke Credit Transfer manually via some means, e.g. Phone, WebBanking etc. (automated invocation will become possible as part of PSD 2 implementation)

== ISO20022/SEPA Credit Transfer ==

	Payer -[#green]> CB: CustomerCreditTransferInitiation
	CB -[#green]> Payer: CustomerPaymentStatusReport
	CB -[#green]> MB : FIToFICustormerCreditTransfer
	MB -[#green]> MPSP : BankToCustomerDebitCreditNotification

== Notification ==	

MPSP-[#black]>Payee: Payment Notification (Cleared)
Payee-[#black]>Payer: Payment Notification (email)

== Fulfilment ==

Payee->Payer: Provide products or services

@enduml
