@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer & Acceptor]" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper/Customer) [Cardholder] Browser" as Payer
participant "Browser Form Filler" as UA
participant "Payer (Shopper/Customer) PSP [Issuer] Wallet" as CPSP

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
