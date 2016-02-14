@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

Participant "Payee (Merchant) PSP" as PSP
Participant "Payee (Merchant) Site" as Payee
Actor "Payer (Shopper) User Agent" as Payer
Participant "MasterPass Server" as MP
Participant "Payer (Shopper) MasterPass\nPartner Hosted Wallet" as PIP

note over Payee, Payer: HTTPS

title MasterPass-type Payment Flow [Simplified]

Payee->Payer: Basket Page with "Pay with MasterPass" Button
Payer->Payee: Press "Pay with MasterPass"

== MasterPass specific flow starts ==

Payee->MP: Hand control to MasterPass 
Note right: Redirect or iFrame 
MP->Payer: Display Wallet Selector UI
Payer->MP: Select Partner Hosted Wallet
MP->PIP: Redirect to Wallet Checkout page
PIP->Payer: Display Sign in page

note over Payer,PIP: Sign in is Partner specific (for instance, can go through mobile app)

Payer->PIP: Supply credentials
PIP->MP: Get Accepted Card Brands &\nAddress Verification
MP->PIP: Return Cards


Alt
	PIP->Payer: Display Card 
Else
	PIP->Payer: Display Card with Shipping Address Selection UI
	Payer->PIP: Card & Shipping Address Selection
End

note over Payer: can also be in mobile app

PIP->MP: Finalise Shopping
MP-->PIP: Compute Merchant Callback URL
PIP->Payee: Redirect to Merchant through Callback URL
Payee->MP: Get Checkout Data
MP-->Payee: Card Number & Shipping Address

== MasterPass specific flow ends ==

group opt
  Payee->Payer: Capture CVV/CVC
  Payer->Payee: CVV/CVC input
end group

Payee->Payer: Display order summary
Payee->PSP: Submit Card Not Present\transaction with Card, CVV/CVC &\nAddress (if required)
PSP-->Payee: Payment confirmation
Payee->Payer: Display confirmation page

@enduml