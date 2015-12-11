@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Browser Form Filler" as UA
participant "Payer (Shopper) PSP Wallet [aka Issuer Wallet]" as CPSP

note over MPSP, Payer: HTTPS

title PSP Hosted Card Payment (Current)

Payee->Payer: Basket Page with Pay Button
Payer->MPSP: Press Pay

MPSP->Payer: Payment Method Choice Page
Payer->Payer: Select Card Brand

alt
	UA->Payer: Form Fill; PAN, Expiry Date, [CVV], [AVS]
else
	Payer->Payer: User Fills Form
End

Payer->MPSP: payload
MPSP->Payer: Result Page Redirect
Payer->Payee: Result Page Redirect
Payee->Payer: Results Page
MPSP-[#black]>Payee: Payment Notification

@enduml
