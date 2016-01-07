@startuml
Autonumber

Database "Invoice Database" as DB
Participant "Payee Website" as Website
Database "Bitcoin Network" as Bitcoin
Participant "Payer Wallet" as Wallet
Actor "Payer (Browser)" as Payer

title Bitcoin Payment Protocol (BIP70)

Payer->Website: Request checkout with Bitcoin
Website->Website: Generate Bitcoin address
Website->DB: Store invoice details
Website->Payer: Basket Page with bitcoin: pay link
Payer->Payer: Click bitcoin: link
Payer->Wallet: Wallet handles bitcoin: URL and extracts invoice URL
Wallet->Website: Request invoice
Website->DB: Get invoice details
Website->Website: Create PaymentDetails (Amount, Memo, Ref#, Pay URL)
Website->Website: Create PaymentRequest (Signed PaymentDetails)
Website->Wallet: PaymentRequest containing PaymentDetails
Wallet->Payer: Confirm payment details?
Payer->Wallet: Accept payment
Wallet->Wallet: Generate and sign payment
Wallet->Website: Signed payment
Website->Bitcoin: Submit payment
Website->Wallet: Payment ACK
Wallet->Payer: Confirm payment is complete
loop until payment is confirmed
    Bitcoin->Website: Latest confirmed transactions
end


@enduml