@startuml
Autonumber

Participant "Payee (Merchant) PSP (Acquiring Bank) [Beneficiary Agent]" as MPSP
Participant "Payee (Merchant) Site [Beneficiary]" as Payee
Actor "Payer (Shopper) Browser [Initiator]" as Payer
participant "Browser Form Filler" as UA
participant "Card Scheme Directory" as CSD
participant "Issuing Bank [Beneficiary Agent] Website " as CPSPW
participant "Issuing Bank [Beneficiary Agent] " as CPSP

note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment with Acquirer Supported 3DS (Current)

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
End
	

MPSP-\CPSP: Authorisation Request
CPSP-/MPSP: Authorisation Response

MPSP-/Payee: Authorisation Response

Payee->Payer: Result Page

== acquiring process (within some days) ==

Payee -> MPSP : Capture
MPSP->CPSP: Capture

@enduml
