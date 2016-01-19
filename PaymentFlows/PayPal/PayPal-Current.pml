@startuml
Autonumber

Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Payer (Shopper) PSP (PayPal)" as CPSP

note over MPSP, CPSP: HTTPS

title PayPal Payment (REST API) (Current)

Payee->Payer: Basket Page with Pay Button

Payer->Payer: Press Pay with PayPal

Payer-\Payee: Payment Page Request

Payee<->CPSP: Create Payment

Payee-/Payer: HTTP Redirect

Note right: HTTP Direct now send the shopper to the PayPal site

Payer-\CPSP: Payment Initiation

CPSP-/Payer: Authentication Page

Payer-\CPSP: Authenticate
note right: Typically a username & password

CPSP-/Payer: Payment Page

opt
	Payer<->CPSP: Instrument Choice
	note right: Payer can change from default payment instrument
end

Payer->Payer: Approval

Payer-\CPSP: Payment Approval

CPSP-/Payer: Payment Response Redirect

Payer-\Payee: Payment Response

Payee<->CPSP: Execute Payment

Payee-/Payer: Result Page


... asynchronous notification ...

CPSP->Payer: Payment Notification (email)

Opt
	Payee->Payer: Payment Notification (email)
End

Note right: Provides out of band confirmation to protect against failure/modification at browser


@enduml
