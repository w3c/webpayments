@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

title Escrow Payment (customer protection)

participant "User Agent" as UA
participant Merchant as M
participant PSP as P

UA->M: checkout
M->UA: payment form
UA->P : select escrow
P<->UA: process payment
P->UA: payment finished
UA->M: payment finished
opt direct notification
P->M: payment finished
end
M->UA: provide service/goods
M->P: delivery finished
P<->UA: confirm delivered
P->M: release settlement
@enduml
