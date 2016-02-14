@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant)\nPSP" as MPSP
Participant "Payee (Merchant)\nWeb Site" as Payee
Participant "Browser" as UA
Actor "Payer (Shopper)" as Payer
Participant "Bank Mobile Wallet" as Wallet
Participant "Bank Wallet Server" as WS

note over Payee, Payer: HTTPS

title Mobile Bank Wallet - "Pay with..." Button

Payee->UA: Present Check-out page with Pay Button
Payer->UA: Select "Pay with ..." Payment Instrument 

UA->WS: Display Wallet Notification Page
WS->Wallet: Notify Payment Request
Wallet->Payer: Display Payment Info
Payer->Wallet: Confirm Payment, Payer Details and Authenticate
Wallet->WS: Signed payment confirmation 

WS->Payee: Callback with encrypted payment details and credentials, optional signed confirmation
Payee->MPSP: Payment
MPSP->Payee: Payment Result

Payee->UA: Payment Result
@enduml
