@startuml
participant Bank_A #red
actor Alice #red
Actor Bob #blue
participant Bank_B #blue
Bob –-[#red]> Alice: <font color=red><b> 0 amount & IBAN but no organised way
Alice -> Bank_A: 1 CustomerCreditTransferInitiation
Bank_A -> Alice: 2 CustomerPaymentStatusReport
Alice –-[#red]>x Bob : <font color=red><b> no immediate notification
Bank_A -> Bank_B : 3 FIToFICustormerCreditTransfer
Bank_B -> Bob : 4 BankToCustomerDebitCreditNotification
@enduml