@startuml
Autonumber

Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Payer (Shopper) PSP (PayPal)" as CPSP

note over MPSP, CPSP: HTTPS

title Merchant PSP Intermediated PayPal Payment (REST API) (Current)

Payee->Payer: Basket Page with Pay Button

Payer->Payer: Press Pay with PayPal

Payer-\Payee: Payment Page Request

Payee-\MPSP: Payment Page Request

MPSP<->CPSP: Create Payment

MPSP-/Payee: HTTP Redirect information

Note right: This data is information about the page to redirect to

Payee-/Payer: HTTP Redirect

Note right: The merchant site converts the info to a HTTP 301 to give the Merchant PSP control

Payer-\MPSP: Payment Request

MPSP-/Payer: HTTP Redirect

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

Payer-\MPSP: Payment Response

MPSP<->CPSP: Execute Payment

MPSP-/Payer: Result Page Redirect

Payer<->Payee: Get Result Page


... asynchronous notification ...

CPSP->Payer: Payment Notification (email)

MPSP->Payee: Payment Notification

Opt
	Payee->Payer: Payment Notification (email)
End

Note right: Provides out of band confirmation to protect against failure/modification at browser


@enduml
