@startuml
Autonumber

participant "Payee (Merchant) Bank" as MB
Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Payer (Shopper) Bank" as CB


note over MPSP, Payer: HTTPS

title PSP Mediated (SEPA) Credit Transfer (Current)

Payee->Payer: Basket Page with Pay Button
Payer->MPSP: Press Pay

MPSP->Payer: Payment Method Choice Page
Payer->MPSP: Select Credit Transfer
MPSP->Payer: Provide Bank Transfer Details (e.g. IBAN)
Payer->MPSP: OK
MPSP->Payer: Result Screen "Pending Transfer"

MPSP-[#black]>Payee: Payment Notification (Pending)

group ISO20022 SEPA Transfer
	Payer -[#green]> CB: CustomerCreditTransferInitiation
	CB -[#green]> Payer: CustomerPaymentStatusReport
	CB -[#green]> MB : FIToFICustormerCreditTransfer
	MB -[#green]> MPSP : BankToCustomerDebitCreditNotification
end 

MPSP-[#black]>Payee: Payment Notification (Cleared)
Payee-[#black]>Payer: Payment Notification (email)

@enduml
