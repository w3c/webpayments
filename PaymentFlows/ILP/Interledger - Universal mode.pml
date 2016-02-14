@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee Website" as Website
Participant "Payee PSP" as PayeePSP
Participant "Cn" as ConnectorN <<Connector>>
Participant "Ln-1" as LedgerN1 <<Ledger>>
Participant "Cn-1" as ConnectorN1 <<Connector>>
Participant "Ln-2" as LedgerN2 <<Ledger>>
Participant "C3" as Connector3 <<Connector>>
Participant "L2" as Ledger2 <<Ledger>>
Participant "C2" as Connector2 <<Connector>>
Participant "L1" as Ledger1 <<Ledger>>
Participant "C1" as Connector1 <<Connector>>
Participant "Payer PSP" as PayerPSP
Actor "Payer (Browser)" as Payer

title Interledger Protocol

Payer->Website: Request checkout via ILP
Website->Payer: Destination account, required amount, currency
Payer->PayerPSP: Get quote
note over PayerPSP: Perform pathfinding
PayerPSP->Payer: Proposed path and cost
Payer->PayerPSP: Confirm payment
== Proposal ==
PayerPSP->Connector1: Propose
activate Connector1
PayerPSP->Connector2: Propose
activate Connector2
PayerPSP->Connector3: Propose
activate Connector3
PayerPSP->ConnectorN1: Propose
activate ConnectorN1
PayerPSP->ConnectorN: Propose
activate ConnectorN
Connector1->PayerPSP: Accepted
deactivate Connector1
Connector2->PayerPSP: Accepted
deactivate Connector2
Connector3->PayerPSP: Accepted
deactivate Connector3
ConnectorN1->PayerPSP: Accepted
deactivate ConnectorN1
ConnectorN->PayerPSP: Accepted
deactivate ConnectorN
== Preparation ==
activate PayerPSP
PayerPSP->Connector1: Prepared
activate Connector1
Connector1->Ledger1: Prepared
activate Ledger1
Ledger1->Connector2: Prepared
activate Connector2
Connector2->Ledger2: Prepared
activate Ledger2
Ledger2->Connector3: Prepared
activate Connector3
Connector3->LedgerN2: Prepared
activate LedgerN2
LedgerN2->ConnectorN1: Prepared
activate ConnectorN1
ConnectorN1->LedgerN1: Prepared
activate LedgerN1
LedgerN1->ConnectorN: Prepared
activate ConnectorN
ConnectorN->PayeePSP: Prepared
activate PayeePSP
PayeePSP->Website: Payment Prepared
Website->PayeePSP: Execute Payment
== Execution ==
PayeePSP->Website: Payment Executed
PayeePSP->ConnectorN: Execute
deactivate PayeePSP
ConnectorN->LedgerN1: Execute
deactivate ConnectorN
LedgerN1->ConnectorN1: Execute
deactivate LedgerN1
ConnectorN1->LedgerN2: Execute
deactivate ConnectorN1
LedgerN2->Connector3: Execute
deactivate LedgerN2
Connector3->Ledger2: Execute
deactivate Connector3
Ledger2->Connector2: Execute
deactivate Ledger2
Connector2->Ledger1: Execute
deactivate Connector2
Ledger1->Connector1: Execute
deactivate Ledger1
Connector1->PayerPSP: Execute
deactivate Connector1
PayerPSP->Payer: Payment confirmation
deactivate PayerPSP

@enduml