@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Participant "Payee (Merchant) Application" as UA
Actor "Payer (Shopper)" as Payer
participant "Apple Pay Agent (Wallet)" as CPSP

note over Payee, Payer: HTTPS

title Apple Pay - Native (Current)

UA->Payer: Basket Page with Pay Button
Payer->UA: Pay with ApplePay

UA->CPSP: Display Apple Pay Payment Sheet
CPSP->Payer: Payment Sheet & Request TouchID
Payer->CPSP: Provide TouchID
CPSP->UA: Payment Token & Cryptogram

UA->Payee: Payment Token & Cryptogram
Payee->MPSP: Payment Token & Cryptogram

MPSP->Payee: Payment Result

Payee->UA: Payment Result
@enduml
