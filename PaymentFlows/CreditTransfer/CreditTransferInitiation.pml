@startuml
participant Bank_A
actor Alice #red
Actor Bob #blue
participant Bank_B
Alice -> Bank_A: 1 CustomerCreditTransferInitiation
Bank_A -> Alice: 2 CustomerPaymentStatusReport
@enduml