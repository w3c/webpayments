@startuml

skinparam backgroundColor #EEEBDC

skinparam noteBackgroundColor #A9DCDF
skinparam noteBorderColor Blue

skinparam sequence {
ArrowColor DeepSkyBlue
ActorBorderColor DeepSkyBlue
LifeLineBorderColor blue
LifeLineBackgroundColor #A9DCDF
ParticipantBorderColor DeepSkyBlue
ParticipantBackgroundColor DodgerBlue
ParticipantFontName Impact
ParticipantFontSize 17
ParticipantFontColor #A9DCDF
ActorBackgroundColor aqua
ActorFontColor DeepSkyBlue
ActorFontSize 17
ActorFontName Aapex
DividerFontColor DodgerBlue
DividerFontSize 15
DividerFontStyle bold
}
hide footbox
title Footer removed

title Real Time Payments Service flows\nBased on a distributed architecture service\nSingle currency settlement

participant Debtor
participant DebtorAgent
participant RealTimeSettlementService
participant CreditorAgent
participant Creditor

== Initiation of Payment Obligation ==
Hnote over RealTimeSettlementService
The Debtor and the Creditor have entered into an agreement (or obligation, 
such as a web purchase, a commercial contract, a securities deal, .....)
which bounds the Debtor to pay the Creditor an agreed amount of money
through a credit transfer, executed through a distributed real time payment service.
end note
Debtor <---> Creditor: Establish Payment Obligation

== Payment Initiation ==
Hnote over Debtor
The Debtor initiates a payment to its bank - the DebtorAgent
end note
Debtor -> DebtorAgent: CustomerCreditTransferInitiation
activate DebtorAgent
|||
== Payment Clearing ==
Hnote over RealTimeSettlementService
The DebtorAgent instructs the payment
to the beneficiary (the Creditor)
through a credit transfer to the CreditorAgent.
The CreditorAgent will receive the amount of money
through the real time payment service.
end note
DebtorAgent -> CreditorAgent: FIToFICustomerCreditTransfer
activate CreditorAgent
|||
== Payment Settlement ==
Hnote over RealTimeSettlementService
Both DebtorAgent and CreditorAgent are participants
in the realtime payments settlement service and
have both an account in the system.
The DebtorAgent issues an interbank credit transfer
to the realtime settlement service instructing to move 
the amount of money (the funds) from its own account
to the account of the CreditAgent.
end note

DebtorAgent [#Blue]-> RealTimeSettlementService: FinancialInstitutionCreditTransfer
activate RealTimeSettlementService #Blue
Hnote over RealTimeSettlementService
Once the movement of the amount of money is confirmed,
the realtime payments settlement service sends a status message 
to indicate the transfer was accepted to both DebtorAgent and CreditorAgent.
end note
RealTimeSettlementService [#Blue]-> DebtorAgent: FIToFIPaymentStatusReport (Accepted)
RealTimeSettlementService [#Blue]-> CreditorAgent: FIToFIPaymentStatusReport (Accepted)
deactivate RealTimeSettlementService #Blue
activate CreditorAgent #Blue
|||
== Payment Confirmation ==
Hnote over RealTimeSettlementService
The CreditorAgent books the funds on the Creditor's account and 
confirms to the DebtorAgent that the funds have been credited
through a status message to indicate a successfull payment.
end note
CreditorAgent -> DebtorAgent: FIToFIPaymentStatusReport (Accepted)
deactivate CreditorAgent #Blue
deactivate DebtorAgent
|||
== Payment Notification ==
Hnote over Creditor
The CreditorAgent informs the Creditor that the funds 
have been credited on the Creditor's account.
end note
CreditorAgent -> Creditor: BankToCustomerDebitCreditNotification (Booked/Credit)
deactivate CreditorAgent
|||
@enduml