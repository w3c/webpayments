@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer & Acceptor]" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper/Customer) [Cardholder] Browser" as Payer
participant "Browser Form Filler" as UA
participant "Payer (Shopper/Customer) PSP [Issuer] Wallet" as CPSP

note over MPSP, Payer: HTTPS

title
<b>PSP Hosted Card Payment (Current)</b>

<i>Payment Pages are hosted at the PSP to removed PCI burden (SAQ-A) as no card details are available on the merchants site</i>
end title

Payee->Payer: Present Check-out page with Pay Button

Payer->MPSP: Press Pay

MPSP->Payer: Payment Method Choice Page
Payer->Payer: Select Card Payment Method

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

== Request for Settlement process (could be immediate, batch (e.g. daily) or after some days) ==

Alt
	Payee -> MPSP : Capture
	note right: Later Capture may be called, for example after good shipped or tickets pickedup
Else
	MPSP -> MPSP : Auto Capture in batch processing at end-of-day
End	
	
MPSP->CPSP: Capture
@enduml
