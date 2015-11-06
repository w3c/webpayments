@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Payer (Shopper) PSP" as CPSP

note over MPSP, CPSP: HTTPS

title Merchant PSP Intermediated Generic Push Payment (Current) 

Payee->Payer: Basket Page with Pay Button

Payer->Payer: Press Pay

Payer-\Payee: Payment Page Request

Payee-\MPSP: Payment Page Request

MPSP-/Payee: HTTP Redirect

Payee-/Payer: HTTP Redirect

Payer-\MPSP: Payment Request

opt

	MPSP-/Payer: Payment Choice Page

	Payer->Payer: Select Payment Instrument

	Payer-\MPSP: Payment Instrument Page Request

	note right: This option is used where the merchant want to support many payment methods
end
	
MPSP-/Payer: HTTP Redirect

Payer-\CPSP: Payment Initiation

CPSP-/Payer: Authentication Page

Payer-\CPSP: Authenticate
note right: Typically a username & password

CPSP-/Payer: Payment Page

opt
	Payer<->CPSP: Instrument Choice
	note right: For Wallets with multiple payment instruments
end

Payer->Payer: Agreement

Payer-\CPSP: Payment Confirmation

CPSP-/Payer: Payment Response

Payer-\Payee: Payment Response

Payee-/Payer: Result Page

... asynchronous notification ...

CPSP->MPSP: Payment Response

MPSP->Payee: Payment Notification

Note right: Provides out of band confirmation to protect against failure/modification at browser


@enduml
