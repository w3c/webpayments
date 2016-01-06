@startuml
title SEPA Direct Debit with e-mandate\n Nominal B2C one-off case\nRef: EPC016-06 Core SDD RB v9.1 Approved

actor CU as “Customer\nDebtor\n(Payer)”
participant BOD as “Debtor\n Browser”
participant WOC as “Creditor\nWebsite”
actor ME as “Merchant\nCreditor\n(Payee)”
box "Creditor Bank may\nensure Routing Service" #LightBlue
participant RSP as “Routing Service\nProvider”
participant CB as “Creditor\nBank”
endbox
participant CSM as “Clearing & Settlement\nMechanism”
box "Debtor Bank may\nensure Validation Service" #LightGreen
participant VSP as “Validation Service\nProvider”
participant DB as “Debtor\nBank”
endbox


== Initial Contractual agreements ==
DB-->VSP : Accreditation
VSP-->CU : Terms and Authentication means
CB-->RSP : Accreditation
RSP-->ME : Terms and Authentication means

== e-Mandate processing ==

Autonumber
Hnote over CU : Debtor uses an electronic channel offered by the Creditor\n to enter the e-Mandate required data elements 
BOD->WOC : Initiation\nCustomer ready to pay the Merchant and ok for SDD flow
activate WOC
WOC->RSP : e-Mandate proposal
Deactivate WOC
activate RSP
hnote over VSP : The validation service has\n been selected by the Debtor\n on the Creditor's e-Mandate\n proposal system
RSP->VSP : e-Mandate proposal
Deactivate RSP
activate VSP
VSP->BOD : Request for Authentication
Deactivate VSP
activate BOD
Hnote over DB : The Debtor Bank defines\n and provides the\nauthentication means \n(credentials)\n to be used by\nthe Debtors

hnote over CU : The Debtor must identify\nand authenticate (Authentication credentials) himself\naccording to the instructions received\nfrom the Debtor Bank.
BOD->VSP : Authentication
deactivate BOD
activate VSP
autonumber stop
hnote over VSP : Service checks and logs the event\nif successful, validation of\n the authentication means and the\n account access right (if unsuccessfull, abort)
VSP->BOD : Displays to the Debtor and authorization form that must include all data fields of the e-Mandate and advances the transaction state to “Waiting for authorization”
Deactivate VSP
Activate BOD
Hnote over CU : Debtor checks data and authorizes
BOD->VSP : Authorization
Hnote over VSP : Validation Service verifies the authorization\n and performs an electronic signature\n of the XML e-Mandate data using the\n e-Operating Model X.509 signing certificate issued\n by an approved EPC Certification Authority. 
Deactivate BOD
Activate VSP


Autonumber 
hnote over VSP : e-Mandate: electronic document\n created and signed in a\nsecure electronic manner
VSP->BOD : confirmation message along with the e-Mandate data and a link to the Creditor website.
activate BOD
VSP->RSP : e-Mandate
Deactivate VSP
Activate RSP
RSP->WOC : e-Mandate
Deactivate RSP
Activate WOC
WOC->BOD : Confirmation
Deactivate WOC
deactivate BOD
== Collection ==
Autonumber 20
ME-> CB : Merchant sends "Collection"\nnot earlier than 14 Calendar Days before the Due Date,\nunless otherwise agreed between the Creditor and the Creditor Bank\nCollection includes Mandate-related information
deactivate ME
activate CB
Create CSM
CB-> CSM : Collection
Deactivate CB
activate CSM
CSM-> DB : Collection
deactivate CSM
... 14 days or other agreed delay ...
== Settlement at due date ==
hnote over CSM : Settlement
CSM-> DB : Debit
activate CSM
deactivate DB
hnote over DB : Debtor account credited
CSM-> CB : Credit
deactivate CSM
deactivate CB
hnote over CB : Creditor account credited
@enduml
