@startuml
Autonumber

Participant "Payee (Merchant) PSP [Beneficiary Agent]" as MPSP
Participant "Payee (Merchant) Website [Beneficiary]" as Payee
Actor "Payer (Shopper) Browser [Initiator]" as Payer
participant "Browser Form Filler" as UA
participant "Issuing Bank" as CPSP

note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment (Current)

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
	note right: Merchant can store card details (apart from CVV) (even if encrypted) for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise (payload)

MPSP-\CPSP: Authorisation Request
CPSP-/MPSP: Authorisation Response

MPSP-/Payee: Authorisation Result

Payee->Payer: Result Page

== acquiring process (within some days) ==

Payee -> MPSP : Capture
MPSP->CPSP: Capture

@enduml
