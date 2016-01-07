@startuml
Autonumber

Participant "Payee (Merchant)\nPSP" as MPSP
Participant "Payee (Merchant)\nServer" as Payee
Participant "Payee (Merchant)\nApplication" as UA
Actor "Payer (Shopper)" as Payer
Participant "Apple Pay Agent\n(SDK/Wallet/Payment Sheet)" as CPSP
Participant "Apple Pay\nServers" as APS
Participant "Apple Pay\nSecure Element" as SE

note over Payee, Payer: HTTPS

title Apple Pay - Native (Current)

UA->Payer: Basket Page with Pay Button
Payer->UA: Pay with Apple Pay

UA->CPSP: Display Apple Pay Payment Sheet
CPSP->Payer: Payment Sheet & Request TouchID
Payer->CPSP: Provide TouchID
Payer->CPSP: Provide shipping method and address

CPSP->SE: Generate payment token 
note over SE: Package payment credentials and details,\nencrypt with Apple Pay Servers key
SE->APS: Encrypted Payment Token
APS->CPSP: Re-encrypted Payment Token 
note over APS: Re-encrypted with merchant public key

CPSP->UA: Payment Token & Customer Details
UA->Payee: Payment Token & Customer Details
Payee->MPSP: Payment Token

note over MPSP: Decrypt payment token on behalf of Merchant,\nwith Merchant private key

MPSP->Payee: Payment Result

Payee->UA: Payment Result
UA->Payer: Payment Result
@enduml
