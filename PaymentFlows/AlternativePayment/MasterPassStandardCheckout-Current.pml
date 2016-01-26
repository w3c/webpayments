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
Payee->MP: Redirect / iFrame to Wallet Selector UI 
MP->Payer: Display Wallet Selector UI
Payer->MP: Select Partner Hosted Wallet
MP->PIP: Redirect to Wallet Checkout page
PIP->Payer: Display Sign in page

note over Payer,PIP: Sign in is Partner specific (for instance, can go through mobile app)

Payer->PIP: Sign in
PIP->MP: Get Accepted Card Brands &\nAddress Verification

PIP->Payer: Display Card & Shipping Address Selection UI
note left: can also be in mobile app

Payer->PIP: Card & Shipping Address Selection
PIP->MP: Authorize Order
MP-->PIP: Compute Merchant Callback URL
PIP->Payee: Redirect to Merchant through Callback URL
Payee->MP: Get Checkout Data
MP-->Payee: Card Number & Shipping Address

group opt
  Payee->Payer: Capture CVV/CVC
  Payer->Payee: CVV/CVC input
end group

Payee->Payer: Display order summary
Payee->PSP: Submit Card Not Present\ntransaction with Card, CVV/CVC &\nAddress (if required)
PSP-->Payee: Payment confirmation
Payee->Payer: Display confirmation page

@enduml