@startuml
autonumber
Participant "Payee (Merchant) PSP" as MPSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) Browser" as Payer
participant "Browser Payment Agent/Wallet" as UA
participant "Payer (Shopper) PSP Wallet [aka Issuer Wallet]" as CPSP
participant "Issuer Website" as CPSPW


note over Payee, Payer: HTTPS

title Legacy Merchant Hosted Card Payment (Google Proposal)

Payee->Payer: Basket Page with Pay Button
Payer->Payer: Press Pay

Payer->UA: Select Payment Instrument

Opt
	CPSP->UA: Payment Instrument data
	Note left
		If 3rd Party provides extension,
 		e.g. LastPass, MasterPass, Barclaycard
	End note
End

UA->Payer: Payment Instrument data

Alt
	Payer->Payee: Payment Instrument Data
Else
	Payer->Payee: Encrypt(Payment Instrument Data)
	Note right: Custom code on merchant webpage can encrypt payload
End

Payee-\MPSP: Authorise(Payment Instrument data)
MPSP-/Payee: Authorisation Result

Payee->Payer: Result Page

@enduml
