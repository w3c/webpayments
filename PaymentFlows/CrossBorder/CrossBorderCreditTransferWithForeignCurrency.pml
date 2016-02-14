@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

title Cross-border credit transfer flows\nInstructed amount is in a currency different\nfrom the Debtor's account currency.

participant "Debtor\n(Payer)" as DBTR
participant "Debtor Agent\n(Instructing Agent)" as DA
participant "Instructing Reimbursement\nAgent" as IGRA
participant "Instructed Reimbursement\nAgent" as IDRA
participant "CreditorAgent\n(Instructed Agent)" as CA
participant "Creditor\n(Payee)" as CDTR

== Initiation of Payment Obligation ==
|||
Hnote over IGRA
The Debtor and the Creditor have entered into an agreement (or obligation, such as a web purchase, a commercial contract, a securities deal, .....)
which bounds the Debtor to pay the Creditor an agreed amount of money through a cross-border credit transfer, executed through correspondent banks.
In this scenario, the Debtor has an account in a different currency than the currency of the payment, requiring a FOREX, which will be executed 
by the DebtorAgent before initiation of the interbank transfer.
end note
|||
DBTR <---> CDTR: Establish Payment Obligation
|||

== Payment Initiation ==
Hnote over DBTR
The Debtor initiates a payment to its bank - the DebtorAgent
end note
DBTR -> DA: CustomerCreditTransferInitiation
activate DA

DA [#Orange]-> DA  : (Internal Process) Execute FOREX for Debtor
activate DA #Orange
note left #Orange
(Internal Process) 
The DebtorAgent executes the FOREX 
from the Debtor's account currency to the currency 
as agreed and established in the payment obligation.
end note
Deactivate DA #Orange
|||
== Payment Clearing ==
Hnote over IDRA
The DebtorAgent instructs the payment to the beneficiary (the Creditor) through a credit transfer to the CreditorAgent.
Both DebtorAgent and CreditorAgent do not have a direct relationship in the currency of the credit transfer, 
and will therefore use the "COVER" payment method, through their correspondents (or Reimbursement Agents)
end note
DA -> CA: FIToFICustomerCreditTransfer
activate CA
|||
== Payment Settlement ( through COVER Method ) ==
Hnote over DA #DodgerBlue
The DebtorAgent issues an interbank credit transfer (COVER Method)to the 
InstructingReimbursementAgent, through which the DebtorAgent normally settles
the credit transfers in the currency as defined in the payment obligation 
between the debtor and the creditor.
end note

DA [#Blue]-> IGRA: FinancialInstitutionCreditTransfer (COVER)
activate IGRA #Blue
Hnote over IGRA #DodgerBlue
The InstructingReimbursementAgent has a direct account relationship
with the InstructedReimbursementAgent in the settlement currency 
(or through a additional ThirdReimbursementAgent - not illustrated here)
through which the amount of money is transfered from the 
InstructingReimbursementAgent to the InstructedReimbursementAgent.
end note

opt
Hnote over IGRA #DodgerBlue
The InstructingReimbursementAgent confirms to the DebtorAgent 
that the funds have been credited through a status message to
indicate a successfull payment.
end note
IGRA [#Blue]-> DA: FIToFIPaymentStatusReport (Accepted)
end

IGRA [#Blue]-> IDRA: FinancialInstitutionCreditTransfer (COVER)
activate IDRA #Blue
Hnote over IDRA #DodgerBlue
The InstructedReimbursementAgent credits the amount of money
on the account of the CreditorAgent, which completes the transfer
of funds from the DebtorAgent to the CreditorAgent as initially 
instructed in the Payment Clearing phase.
end note


opt
Hnote over IDRA #DodgerBlue
The InstructedReimbursementAgent confirms to the DebtorAgent 
that the funds have been credited through a status message to
indicate a successfull payment.
end note
IDRA [#Blue]-> IGRA: FIToFIPaymentStatusReport (Accepted)
end
IDRA [#Blue]-> CA: BankToCustomerDebitCreditNotification (Booked/Credit)
deactivate IGRA #Blue
deactivate IDRA #Blue

activate CA #Blue
|||
== Payment Confirmation ==
opt
Hnote over IGRA
The CreditorAgent books the funds on the Creditor's account and 
confirms to the DebtorAgent that the funds have been credited
through a status message to indicate a successfull payment.
end note
CA -> DA: FIToFIPaymentStatusReport (Accepted)
end
deactivate CA #Blue

|||
== Payment Notification ==
Hnote over CDTR
The CreditorAgent informs the Creditor that the funds 
have been credited on the Creditor's account.
end note
CA -> CDTR: BankToCustomerDebitCreditNotification (Booked/Credit)
deactivate CA
deactivate DA
|||
@enduml
