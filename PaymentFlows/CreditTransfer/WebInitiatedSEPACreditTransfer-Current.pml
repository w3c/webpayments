@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

participant "Payee (Merchant) Bank [Creditor Agent]" as MB
Participant "Payee (Merchant) PSP [Intermediary]" as MPSP
Participant "Payee (Merchant) Website [Creditor]" as Payee
Actor "Payer (Shopper) Browser [Debtor]" as Payer
participant "Payer (Shopper) Bank [Debtor Agent]" as CB


note over MPSP, Payer: HTTPS

title PSP Mediated (SEPA) Credit Transfer (Current)

Payee->Payer: Present Check-out page with Pay Button
Payer->MPSP: Press Pay

MPSP->Payer: Payment Method Choice Page
Payer->MPSP: Select Credit Transfer Payment Method
MPSP->Payer: Provide Bank Transfer Details (e.g. IBAN)
Payer->MPSP: OK
MPSP->Payer: Result Screen "Pending Transfer"

MPSP-[#black]>Payee: Payment Notification (Pending)

== ISO20022/SEPA Credit Transfer ==
	Payer -[#green]> CB: CustomerCreditTransferInitiation
	CB -[#green]> Payer: CustomerPaymentStatusReport
	CB -[#green]> MB : FIToFICustormerCreditTransfer
	MB -[#green]> MPSP : BankToCustomerDebitCreditNotification

== ==	

MPSP-[#black]>Payee: Payment Notification (Cleared)
Payee-[#black]>Payer: Payment Notification (email)

@enduml
