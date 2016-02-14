@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer]" as MPSP
Participant "Payee (Merchant) [Acceptor] Site " as Payee
Actor "Payer (Shopper) [Cardholder] Browser" as Payer
participant "Browser Form Filler" as UA
participant "Card Scheme Directory" as CSD
participant "Issuing Bank [Issuer] Website" as CPSPW
participant "Issuing Bank [Issuer]" as CPSP

note over Payee, Payer: HTTPS

title 
<b>Legacy Merchant Hosted Card Payment with Acquirer Supported 3DS (Current)</b>

<i>3DS is used to add confidence that the payer is who they say they are and importantly in the event of a dispute liability shift to the Issuer.</i>
end title



Payee->Payer: Present Check-out page with Pay Button
Payer->Payer: Select Card Payment Method

alt
	UA->Payer: Form Fill
	Note right: fields are PAN & Expiry Date with optional CVV, & Address, Also Card Valid Date and Issue Number are required for some Schemes
else
	Payer->Payer: User Fills Form
End

Payer->Payee: Payment Initiation
Note right: Custom code on merchant webpage can encrypt payload to reduce PCI burden from SAQ D to SAQ A-EP

opt
	Payee->Payee: Store Card
	note right: Merchant can store card details apart from CVV (even if encrypted) for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise
	
== 3DS part of flow ==

	MPSP –> CSD: BIN to URL lookup (VAReq message)
	CSD -> CSD: Lookup URL from BIN
	CSD –> CPSPW : “PING” 
	note right: verify URL validity
	CPSPW –> CSD: “PING” response
	CSD –> MPSP: URL
	
	MPSP-/Payee: 3DS redirect (PAReq message)
	Payee->Payer: 3DS redirect (PAReq message)
	Payer->CPSPW: 3DS invoke
	CPSPW-\Payer: 3DS challenge
	Payer-/CPSPW: 3DS response (PARes message) 
	CPSPW->Payer: 3DS response (PARes message)
	Payer->Payee: 3DS response (PARes message)
	Payee-\MPSP: 3DS response (PARes message)

	MPSP->MPSP: Verification of PARes signature

== End of 3DS ==
	

MPSP-\CPSP: Authorisation Request
CPSP-/MPSP: Authorisation Response

MPSP-/Payee: Authorisation Response

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
