@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer]" as MPSP
Participant "Payee (Merchant) Website [Acceptor]" as Payee
Actor "Payer (Shopper) [Cardholder] Browser" as Payer
participant "Browser Form Filler" as UA
participant "Issuing Bank [Issuer]" as CPSP

note over Payee, Payer: HTTPS

title 
<b>Merchant Hosted Card Payment with Tokenisation (Current)</b>

<i>Tokenisation is used to reduce PCI compliance effort. Currently when tokenisation is used in this mode it only attract a level known as SAQ A-EP</i>
end title

Payee->Payer: Present Check-out page with Pay Button
Payer->Payer: Select Card Payment Method

Payer->Payer: Select Card Brand
alt
	UA->Payer: Form Fill; PAN, Expiry Date, [CVV], [AVS]
else
	Payer->Payer: User Fills Form
End

Payer->MPSP: Tokenisation Request (Card Details)
MPSP->MPSP: Tokenise Card
MPSP->Payer: Card Token

Payer->Payee: Payment Details & Card Token

opt
	Payee->Payee: Store Token
	note right: Merchant can store tokens for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise(Payment Details & Card Token)

MPSP->MPSP: Detokenise Card

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
