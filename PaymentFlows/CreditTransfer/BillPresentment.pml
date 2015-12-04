@startuml
participant Bank_A #red
actor Alice #red
Actor Bob #blue
participant Bank_B #blue
Bob -[#green]> Alice: <font color=green><b> A creditorPaymentActivationRequest
Alice -[#green]> Bob: <font color=green><b> B
creditorPaymentActivationRequestStatusReport
Alice -> Bank_A: 1 CustomerCreditTransferInitiation
Bank_A -> Alice: 2 CustomerPaymentStatusReport
Bank_A -> Bank_B : 3 FIToFICustormerCreditTransfer
Bank_B -> Bob : 4 BankToCustomerDebitCreditNotification
@enduml