@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Browser Form Filler" as UA
participant "Payer (Shopper) PSP Wallet [aka Issuer Wallet]" as CPSP
participant "Issuer Website" as CPSPW

note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment with 3DS (Current)

Payee->Payer: Basket Page with Pay Button
Payer->Payer: Press Pay
Payer->Payer: Select Card Brand
alt
	UA->Payer: Form Fill; PAN, Expiry Date, [CVV], [AVS]
else
	Payer->Payer: User Fills Form
End

Alt
	Payer->Payee: payload
Else
	Payer->Payee: Encrypt(payload)
	Note right: Custom code on merchant webpage can encrypt payload to reduce PCI burden from SAQ D to SAQ A-EP
End

opt
	Payee->Payee: Store Card
	note right: Merchant can store card details apart from CVV (even if encrypted) for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise(payload)

Opt
	MPSP-/Payee: 3DS redirect
	Payee->Payer: 3DS redirect
	Payer->CPSPW: 3DS invoke
	CPSPW-\Payer: 3DS challenge
	Payer-/CPSPW: 3DS response
	CPSPW->Payer: 3DS response
	Payer->Payee: 3DS response
	Payee-\MPSP: Authentication(3DS token)
End

MPSP-/Payee: Authorisation Response


Payee->Payer: Result Page

@enduml
