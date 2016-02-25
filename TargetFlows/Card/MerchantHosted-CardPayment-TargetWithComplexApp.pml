@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Acquirer]" as MPSP
Participant "Payee (Merchant) [Acceptor] Website" as Payee
participant "Payer's (Shopper's) Browser" as UA
Actor "Payer [Cardholder]" as Payer

participant "Payment Mediator" as UAM
participant "Payment App" as PSPUI

participant "Issuing Bank [Issuer]" as CPSP

note over Payee, PSPUI: HTTPS

title Legacy Merchant Hosted Card Payment (Target)

== Negotiation of Payment Terms  & Selection of Payment Instrument ==

Payee->UA: Present Check-out page 
Payer<-[#green]>UA: Select Checkout
Payer<-[#green]>Payee: Establish Payment Obligation (including delivery obligations)
Payee->UA: Payment and delivery details

UA->UAM: PaymentRequest (Items, Amounts, Shipping Options )
note right: PaymentRequest.Show()
opt
	Payer<-[#green]>UAM: Select Shipping Options	
	UAM->UA: Shipping Info
	note right: shippingoptionchange or shippingaddresschange events

	UA->UAM: Revised PaymentRequest
end
Payer<-[#green]>UAM: Select <b><color:red>Card</color></b> Payment Instrument

Payer<-[#green]>UAM: Authorise

UAM<-[#green]>PSPUI: Invoke <b><color:red>Card</color></b> Payment App (Instrument)

UAM->PSPUI: PaymentRequest without Shipping Options


	PSPUI<->CPSP: <b><color:red>Authorisation</color></b> 
	
	PSPUI<->UAM: <b><color:red>Payment Token</color></b>

UAM->UA: <b><color:red>Payment Token</color></b>

Note Right: Show() Promise Resolves 


== Payment Processing ==

	UA->Payee: <b><color:red>Payment Token</color></b>

opt
	Payee->Payee: <b><color:red>Store Token</color></b>
	note right: Merchant can store card details if it is a reusable token <b>however PaymentRequest message will need to support this<b>
end

	Payee-> UA: <b><color:red>Token Stored Successfully</color></b>

== Notification ==

UA->UAM: Payment Completetion Status

note over UAM: response.complete(status)

UAM->UA: UI Removed

note over UAM: complete promise resolves

UA->UA: Navigate to Result Page

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
