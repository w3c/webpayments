@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

participant "Payee (Merchant) Bank [Creditor Agent]" as MB
'Participant "Payee (Merchant) PSP [Intermediary]" as MPSP
Participant "Payee (Merchant) PISP [Initiation]" as MPISP

Participant "Payee (Merchant) Website [Creditor]" as Payee
'Participant "Payer (Shopper) PISP [Debtor]" as RPISP

Actor "Payer (Shopper) Browser [Debtor]" as Payer

participant "Payer (Shopper) Bank [Debtor Agent]" as CB


note over MPSP, Payer: HTTPS

title (SEPA) Credit Transfer With the Merchant proposing his PISP

Payee->Payer: Basket Page with Pay Button
Payer->MPISP: Press Pay

MPISP->Payer: Payment Method Choice Page
Payer->MPISP: Select Credit Transfer\nand chooses his preferred PISP
Hnote over MPISP: the Merchant's PISP takes the Merchant data and generates,\n with consent of the Shopper,\n the Transfer initiation message 
Payee-> MPISP: Provide Bank Transfer Details (e.g. IBAN)
Payer-> MPISP: OK
MPISP ->Payer: Result Screen "Pending Transfer"
MPISP -> Payee: "Pending Transfer"


group ISO20022/SEPA Credit Transfer
	MPISP -[#green]> CB: SEPA msg CustomerCreditTransferInitiation\nreal-time
	CB -[#green]> MPISP: SEPA msg CustomerPaymentStatusReport\nreal-time

Hnote over MPISP: the MPISP can use the SEPA Status Report\n to inform both the Shopper and the Merchant's PSP
MPISP -> Payer: Payment approved by Shopper's Bank\nreal-time
MPISP -> Payee: Payment approved by Shopper's Bank\nreal-time

	CB -[#green]> MB : SEPA msg FIToFICustormerCreditTransfer\nbatch
	MB -[#green]> MPISP : SEPA msg BankToCustomerDebitCreditNotification\nbatch
end 

MPSP-[#black]>Payee: Payment Notification (Cleared)
Payee-[#black]>Payer: Payment Notification (email)

@enduml
