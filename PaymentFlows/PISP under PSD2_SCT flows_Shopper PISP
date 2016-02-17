@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

participant "Payee (Merchant) Bank [Creditor Agent]" as MB
Participant "Payee (Merchant) PSP [Intermediary]" as MPSP
'Participant "Payee (Merchant) PISP [Initiation]" as MPISP

Participant "Payee (Merchant) Website [Creditor]" as Payee
Participant "Payer (Shopper) PISP [Debtor]" as RPISP

Actor "Payer (Shopper) Browser [Debtor]" as Payer

participant "Payer (Shopper) Bank [Debtor Agent]" as CB


note over MPSP, Payer: HTTPS

title (SEPA) Credit Transfer With the Shopper choosing his preferred PISP

Payee->Payer: Basket Page with Pay Button
Payer->MPSP: Press Pay

MPSP->Payer: Payment Method Choice Page
Payer->MPSP: Select Credit Transfer\nand chooses his preferred PISP
Hnote over RPISP: the Shopper's PISP takes the Merchant data and generates,\n with consent of the Shopper,\n the Transfer initiation message 
MPSP->RPISP: Redirection to PISP page\n Provide Bank Transfer Details (e.g. IBAN)
Payer-> RPISP: OK
RPISP ->Payer: Result Screen "Pending Transfer"
RPISP ->MPSP: "Pending Transfer"


group ISO20022/SEPA Credit Transfer
	RPISP -[#green]> CB: SEPA msg CustomerCreditTransferInitiation\nreal-time
	CB -[#green]> RPISP: SEPA msg CustomerPaymentStatusReport\nreal-time

Hnote over RPISP: the PISP can use the SEPA Status Report\n to inform both the Shopper and the Merchant's PSP
RPISP -> Payer: Payment approved by Shopper's Bank\nreal-time
RPISP -> MPSP: Payment approved by Shopper's Bank\nreal-time

	CB -[#green]> MB : SEPA msg FIToFICustormerCreditTransfer\nbatch
	MB -[#green]> MPSP : SEPA msg BankToCustomerDebitCreditNotification\nbatch
end 

MPSP-[#black]>Payee: Payment Notification (Cleared)
Payee-[#black]>Payer: Payment Notification (email)

@enduml
