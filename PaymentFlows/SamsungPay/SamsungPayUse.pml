@startuml
title Using SamsungPay (unofficial)

participant User as U
participant "SamsungPay App" as SPA
participant "SamsungPay Server" as SPS
participant "Store / POS" as S
participant "Card Issuer" as CI

U->S: choose goods
S->U: show bill
U->SPA: launch SamsungPay App
SPA->SPA: select cardtype
SPA->SPA: user authentication \nwith fingerprint
SPA->SPA: generate One Time Token\nwith static Token and time based seed
SPA->S: send OTT via MST or NFC
SPA<->SPS: store payment history
S<->CI: get card approval with OTT
S->U: show payment result
U->S: sign on receipt
S->U: deliver goods
@enduml
