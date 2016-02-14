@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer]" as MPSP
Participant "Payee (Merchant) [Acceptor] Website" as Payee
Actor "Payer (Shopper) [Cardholder] Browser" as Payer
participant "Browser Form Filler" as UA
participant "Issuing Bank [Issuer]" as CPSP

note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment (Current)

Payee->Payer: Present Check-out page with Pay Button
Payer->Payer: Select Card Payment Method

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

== Request for Settlement process (could be immediate, batch (e.g. daily) or after some days) ==

Alt
	Payee -> MPSP : Capture
	note right: Later Capture may be called, for example after good shipped or tickets pickedup
Else
	MPSP -> MPSP : Auto Capture in batch processing at end-of-day
End	
	
MPSP->CPSP: Capture

@enduml
