@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "AliPay" as CPSP

note over Payer, Payee: HTTPS

title AliPay (Current) 

Payee->Payer: Present Check-out page with Pay Button

Payer->Payee: Select "AliPay" Payment Instrument

Payee->CPSP: Send Transaction Details with Digital Signature

CPSP->Payer: User's Authentication and Confirmation Request

Payer->CPSP:  Authentication and Confirmation Response

Note over CPSP: Risk Monitoring
Note over CPSP: Pay from PSP/bank's account

CPSP->Payer: Notification
CPSP->Payee: Notification

== Fulfilment ==

Payee->Payer: Provide products or services

@enduml


