@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Actor "Customer Browser" as Customer
Participant "Bank Site" as Bank
Participant "Taler Exchange" as Exchange

note over Customer, Bank: HTTPS
note over Customer, Exchange: HTTPS
note over Bank, Exchange: SEPA

title Taler (Withdraw coins)

Customer->Bank: user authentication
Bank->Customer: send account portal

Customer->Customer: initiate withdrawal (specify amount and exchange)

Customer->Exchange: request key material and wire transfer data
Exchange->Customer: send key material and wire transfer data

Customer->Bank: execute withdrawal

opt
Bank->Customer: request transaction authorization
Customer->Bank: transaction authorization
end

Bank->Customer: withdrawal confirmation
Bank->Exchange: execute wire transfer


@enduml
