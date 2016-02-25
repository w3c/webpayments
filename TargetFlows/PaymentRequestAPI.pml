@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

participant "Payment Processor" as MPSP
Participant "Payee (Merchant) Website" as Payee
participant "Payer's (Shopper's) Browser" as UA
Actor "Payer" as Payer
participant "Payment Mediator" as UAM
participant "Payment App" as PSPUI
participant "Payment Provider" as CPSP

note over Payee, PSPUI: HTTPS

title Generic Payment Request API Flow V1

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
Payer<-[#green]>UAM: Select Payment Instrument

Payer<-[#green]>UAM: Authorise

UAM<-[#green]>PSPUI: Invoke Payment App (Instrument)

UAM->PSPUI: PaymentRequest without Shipping Options

opt
	PSPUI<->CPSP: Method specific processing (e.g. Authorise Payment / Tokenise Payment Instrument)

	opt
		PSPUI<->UAM: UI Challenge/Response
	end
end

PSPUI->UAM: Payment App Response


UAM->UA: Payment App Response

Note Right: Show() Promise Resolves 

== Payment Processing ==

UA-\Payee: Payment App Response

opt
	Payee-\MPSP: Finalise Payment
	MPSP-\CPSP: Finalise Payment
	CPSP-/MPSP: Payment Response
	MPSP-/Payee: Payment Response
end
	
== Notification ==

UA->UAM: Payment Completetion Status

note over UAM: response.complete(status)

UAM->UA: UI Removed

note over UAM: complete promise resolves

UA->UA: Navigate to Result Page

== Payment Processing Continued ==

opt
	Payee-\MPSP: Finalise Payment
	MPSP-\CPSP: Finalise Payment
	CPSP-/MPSP: Payment Response
	MPSP-/Payee: Payment Response
end
	

== Delivery of Product ==

Payee->Payer: Provide products or services

@enduml