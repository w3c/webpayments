@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Actor "Payee" as Payee
Participant "Payee Bitcoin Node" as PayeeNode
Participant "Payer Bitcoin Node" as PayerNode
Actor "Payer" as Payer

title Basic Bitcoin Payment

Payee->Payee: Generate Bitcoin address
Payee->Payer: Bitcoin address and requested amount
Payer->Payer: Sign transaction

Payer->PayerNode: Submit transaction
Payer->Payee: Notify Payee that transaction has been submitted

loop until desired confirmations complete
PayeeNode->Payee: Get confirmed transactions from blockchain
end

Payee->Payer: Notify payer that transaction has been confirmed

@enduml