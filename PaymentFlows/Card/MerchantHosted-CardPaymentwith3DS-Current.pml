@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer]" as MPSP
Participant "Payee (Merchant) [Acceptor] Site " as Payee
participant "Payer's (Shopper's) Browser" as UA
Actor "Payer [Cardholder]" as Payer
participant "Card Scheme Directory" as CSD
participant "Issuing Bank [Issuer] Website" as CPSPW
participant "Issuing Bank [Issuer]" as CPSP

note over Payee, Payer: HTTPS

title 
<b>Legacy Merchant Hosted Card Payment with Acquirer Supported 3DS (Current)</b>

<i>3DS is used to add confidence that the payer is who they say they are and importantly in the event of a dispute liability shift to the Issuer.</i>
end title

== Negotiation of Payment Terms & Selection of Payment Instrument ==

Payee->UA: Present Check-out page 
Payer<-[#green]>UA: Select Checkout with Card
Payer<-[#green]>UA: Select Card Brand
Payer<-[#green]>UA: Payer Fills Form (PAN, Expiry, [CVV], [Billing Address])
Note right: May be auto-filled from browser 


== Payment Processing ==

UA->Payee: Payment Initiation
Note right: Custom code on merchant webpage can encrypt payload to reduce PCI burden from SAQ D to SAQ A-EP

opt
	Payee->Payee: Store Card
	note right: Merchant can store card details apart from CVV (even if encrypted) for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise


== 3D Secure ==

Note over UA: At this point, the Merchant or Merchant's PSP can decide if it wishes to invoke 3DS. This is often based upon dynamic factors, e.g. if the card has been used before or if shipping address different from billing address
	
	MPSP –> CSD: BIN to URL lookup (VAReq message)
	CSD -> CSD: Lookup URL from BIN
	CSD –> CPSPW : “PING” 
	note right: verify URL validity
	CPSPW –> CSD: “PING” response
	CSD –> MPSP: URL
	
	MPSP-/Payee: 3DS redirect (PAReq message)
	Payee->UA: 3DS redirect (PAReq message)
	UA->CPSPW: 3DS invoke
	CPSPW-\UA: 3DS challenge
	Payer<-[#green]>UA: Enter 3D Secure credentials
	UA-/CPSPW: 3DS response (PARes message) 
	CPSPW->UA: 3DS response (PARes message)
	UA->Payee: 3DS response (PARes message)
	UA-\MPSP: 3DS response (PARes message)

	MPSP->MPSP: Verification of PARes signature

== End of 3D Secure ==
	

MPSP-\CPSP: Authorisation Request
CPSP-/MPSP: Authorisation Response

MPSP-/Payee: Authorisation Result

== Notification ==

Payee->UA: Result Page

== Payment Processing Continued: Request for Settlement process (could be immediate, batch (e.g. daily) or after some days) ==

Alt
	Payee -> MPSP : Capture
	note right: Later Capture may be called, for example after good shipped or tickets pickedup
Else
	MPSP -> MPSP : Auto Capture in batch processing at end-of-day
End	
	
MPSP->CPSP: Capture

== Delivery of Product ==

Payee->Payer: Provide products or services

@enduml
