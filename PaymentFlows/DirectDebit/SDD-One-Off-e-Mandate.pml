@startuml
!includeurl https://raw.githubusercontent.com/w3c/webpayments/gh-pages/PaymentFlows/skin.ipml

title SEPA Direct Debit with e-mandate\n Nominal B2C one-off case\nRef: EPC016-06 Core SDD RB v9.1 Approved

participant CB as "Payee (Merchant) Bank [Creditor Agent]"
participant RSP as “ Payee (Merchant)\nRouting Service\nProvider”

participant CSM as “Clearing & Settlement\nMechanism”
participant WOC as "Payee (Merchant) Website [Creditor]"

Actor BOD as "Payer (Shopper) Browser [Debtor]"
participant VSP as “ Payer (Shopper)\nValidation Service\nProvider”
participant DB as "Payer (Shopper) Bank [Debtor Agent]"

WOC -> BOD: Present Checkout Page with Pay Button
BOD -> WOC: Select Direct Debit Payment Method
Autonumber stop

group ISO20022/SEPA Direct Debit

== e-Mandate processing ==

Autonumber
‘1 initiation
BOD -> WOC: Initiation\nCreditor’s website proposes a form\n to collect the Debtor’s information(esp. BIC\n Possibility to prefill Debtor’s information if already known
Activate BOD
Activate WOC

Hnote over BOD : Initiation \nCustomer fills the form of the\n e-Mandate required data

‘2 mandate request
hnote over WOC : Creditor’s website generates\n e-Mandate request\n (BIC and Creditor’s website URL mandatory)
WOC-[#green]>RSP : e-Mandate request submitted to\n Routing service using URL and\ncredentials (provided by Creditor’s bank or Routing service Provider)\n eom-msg-cred-to-rs-001
activate RSP

‘3 mandate request, BIC and Validation service URL
hnote over RSP : RS requests the Directory Service
RSP-[#green]>RSP: resolve VS BIC
hnote over RSP : Directory Service returns\nthe Validation Service URL for the BIC

‘4 mandate request
hnote over RSP :The Routing Service must present a client certificate\n issued by an EPC approved CA qualifying it\n as legitimate Routing Service\n and the Validation Service must present a server certificate\n issued by an EPC approved CA qualifying it as a legitimate Validation Service 

RSP-[#green]>VSP : e-Mandate request\n(e-mandate enrolment request)\n eom-msg-rs-to-vs-001
activate VSP

‘5 mandate request,validation e-mandate proposal
hnote over VSP : VS validates the e-Mandate proposal
VSP -[#green]> VSP : Validates and stores

‘6 mandate request
VSP -[#green]> RSP : Validation service response\n eom-msg-vs-to-rs-001
Deactivate VSP

‘7 mandate request
RSP-[#green]>WOC : Response including URL specific to\n this transaction used later\n to redirect the Debtor’s browser\n eom-msg-rs-to-cred-001
Deactivate RSP

‘8 mandate request
WOC-[#green]>BOD: Redirect VS URL
Deactivate WOC

‘9 mandate request
BOD-[#green]>VSP: goto VS URL
hnote over BOD : Debtor redirected to an authentication screen\n provided by the Validation Service
activate VSP

’10 Request authentication means
VSP-[#green]>BOD : Authentication form
Deactivate VSP


‘11 Request authentication means
Hnote over DB : The Debtor Bank defines\n and provides the\nauthentication means \n(credentials)\n to be used by\nthe Debtors
hnote over BOD : The Debtor must identify\nand authenticate (Authentication credentials) himself\naccording to the instructions received\nfrom the Debtor Bank.

hnote over BOD : Debtor enters his authentication credentials

BOD-[#green]>VSP: Authentication Data
activate VSP

‘12 Request authentication means
hnote over VSP : Validation Service verifies the credentials
VSP-[#green]>VSP


‘13 Request authentication means
hnote over VSP : If check successful, validation of\n the authentication means and the\n account access right\n collects the debtor’s IBAN (if unsuccessfull, abort)

VSP-[#green]>BOD : Displays to the Debtor an authorization form that must \ninclude all data fields of the e-Mandate and advances \nthe transaction state to “Waiting for authorization”
Deactivate VSP

’14 Authorisation
Hnote over BOD : Debtor checks data and authorizes\n The authorization is defined here as the set of procedures\n agreed between the Debtor and the Debtor Bank \nto assure the clear consent of the Debtor for the\n issuing, amendment and cancellation of an e-Mandate. 

BOD-[#green]>VSP : Authorization data
activate VSP


‘15 Authorisation
Hnote over VSP : Validation Service verifies the authorization\n and performs an electronic signature\n of the XML e-Mandate data using the\n e-Operating Model X.509 signing certificate issued\n by an approved EPC Certification Authority.
VSP-[#green]>VSP : e-sign mandate

’16 Confirmation1
hnote over VSP : e-Mandate: electronic document\n created and signed in a\nsecure electronic manner
VSP-[#green]>BOD : confirmation message along with the e-Mandate\n data and a link to the Creditor website.
deactivate VSP

‘17 Confirmation1
hnote over BOD : Debtor follows the link to the Creditor’s website
BOD-[#green]>WOC: goto Creditor URL
activate WOC


‘18 Confirmation1
hnote over WOC : Generates a request with e-Mandate request identifier\n to retrieve the issued e-Mandate\n eom-msg-cred-to-rs-002

WOC-[#green]>RSP : e-Mandate\n Creditor must present credentials\npreviously arranged with RS\n eom-msg-cred-to-rs-002
Activate RSP

‘19 Confirmation1
RSP-[#green]>VSP : e-Mandate\n eom-msg-rs-to-vs-002
Activate VSP

’20 e-Mandate
VSP-[#green]>RSP : e-Mandate (signed enveloped message)\n eom-msg-vs-to-rs-002
Deactivate VSP

‘21 e-Mandate
RSP-[#green]>RSP: validates signature

‘22 e-Mandate
RSP-[#green]>WOC : e-mandate\n eom-msg-rs-to-cred-002
Deactivate RSP


‘23 e-Mandate
WOC-[#green]> RSP: Acknowledgement of the e-mandate\n eom-msg-cred-to-rs-002
Activate RSP

’24 Confirmation
Hnote over WOC: Presents a confirmation message with e-mandate data
WOC-[#green]>BOD : Confirmation
Deactivate WOC
deactivate BOD

’25 Ack
RSP-[#green]>VSP : Acknowledgement of the e-mandate \ eom-msg-rs-to-vs-002
Deactivate RSP
deactivate VSP

== Collection ==
Autonumber 20
ME-[#green]> CB : Merchant sends "Collection"\nnot earlier than 14 Calendar Days before the Due Date,\nunless otherwise agreed between the Creditor and the Creditor Bank\nCollection includes Mandate-related information
deactivate ME
activate CB
Create CSM
CB-[#green]> CSM : Collection
Deactivate CB
activate CSM
CSM-[#green]> DB : Collection
deactivate CSM

end
... 14 days or other agreed delay ...
== Settlement at due date ==
hnote over CSM : Settlement
CSM-> DB : Debit
activate CSM
deactivate DB
hnote over DB : Debtor account debited
CSM-> CB : Credit
deactivate CSM
deactivate CB
hnote over CB : Creditor account credited
@enduml
