@startuml
participant Bank_A #red
actor Alice #red
Actor Bob #blue
participant Bank_B #blue
Bob -[#green]> Bank_B: <font color=green><b> A creditorPaymentActivationRequest
Bank_B -[#green]> Bank_A: <font color=green><b> A creditorPaymentActivationRequest
Bank_A -[#green]> Alice: <font color=green><b> A creditorPaymentActivationRequest
Alice -> Bank_A: 1 CustomerCreditTransferInitiation
Bank_A -> Alice: 2 CustomerPaymentStatusReport
Bank_A -[#green]> Bank_B: <font color=green><b> B
creditorPaymentActivationRequestStatusReport
Bank_B -[#green]> Bob: <font color=green><b> B
creditorPaymentActivationRequestStatusReport
Bank_A -> Bank_B : 3 FIToFICustormerCreditTransfer
Bank_B -> Bob : 4 BankToCustomerDebitCreditNotification
@enduml