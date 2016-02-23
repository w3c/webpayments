@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Actor "Payer (Shopper) Browser" as Payer
Participant "Payee (Merchant) Site" as Payee
Participant "Taler Exchange" as Exchange

note over Payer, Payee: Tor/HTTPS
note over Payee, Exchange: HTTP/HTTPS

title Taler (Payment)

== Establish Payment Obligation ==

opt
Payer->Payer: Select Taler payment method (skippable with auto-detection)
end

Payer->Payee: Choose goods

Payee->Payer: Send signed digital contract proposal

== Execute Payment ==

opt
Payer->Payer: Affirm contract
end

Payer->Payee: Send payment

Payee->Exchange: Forward payment

Exchange->Payee: Confirm payment

== Fulfilment ==

Payee->Payer: Provide products or services

@enduml
