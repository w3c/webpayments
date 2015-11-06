@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Browser Form Filler" as UA
participant "Payer (Shopper) PSP Wallet [aka Issuer Wallet]" as CPSP

note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment (Current)

Payee->Payer: Basket Page with Pay Button
Payer->Payer: Press Pay

Payer->Payer: Select Card Brand
opt
	UA->Payer: Form Fill; PAN, Expiry Date, [CVV], [AVS]
End

Alt
	Payer->Payee: payload
Else
	Payer->Payee: Encrypt(payload)
	Note right: Custom code on merchant webpage can encrypt payload
End

Payee-\MPSP: Authenticate(payload)
MPSP-/Payee: Authentication Result

Payee->Payer: Result Page

@enduml
