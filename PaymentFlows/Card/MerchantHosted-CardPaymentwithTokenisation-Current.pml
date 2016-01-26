@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP [Beneficiary Agent]" as MPSP
Participant "Payee (Merchant) Website [Beneficiary]" as Payee
Actor "Payer (Shopper) Browser [Initiator]" as Payer
participant "Browser Form Filler" as UA
participant "Issuing Bank [Initiator Agent]" as CPSP

note over Payee, Payer: HTTPS

title 
<b>Merchant Hosted Card Payment with Tokenisation (Current)</b>

<i>Tokenisation is used to reduce PCI compliance effort. Currently when tokenisation is used in this mode it only attract a level known as SAQ A-EP</i>
end title

Payee->Payer: Basket Page with Pay Button
Payer->Payer: Press Pay

Payer->Payer: Select Card Brand
alt
	UA->Payer: Form Fill; PAN, Expiry Date, [CVV], [AVS]
else
	Payer->Payer: User Fills Form
End

Payer->MPSP: Tokenisation Request (Card Details)
MPSP->MPSP: Tokenise Card
MPSP->Payer: Card Token

Payer->Payee: Payment Details & Card Token

opt
	Payee->Payee: Store Token
	note right: Merchant can store tokens for future use (a.k.a. Card on File)
end

Payee-\MPSP: Authorise(Payment Details & Card Token)

MPSP->MPSP: Detokenise Card

MPSP-/Payee: Authorisation Result

Payee->Payer: Result Page

== Acquiring process (within some days) ==

Payee -> MPSP : Capture
MPSP->CPSP: Capture

@enduml
