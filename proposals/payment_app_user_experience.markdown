#Payment app user experience discussion
***
#1. Use Case Discussion:

##Discussion:
In some use cases, the merchant website may need to have the ability to influence the preference of the payment app selection. For example, the merchant website may have commercial cooperation with one payment service provider, for example, discount etc. During this commercial cooperation period, the merchant may want to recommend the user to use that payment app in high priority. There are other more complex use cases: 

Use Case 1:

* The merchant website supports aPay and bPay.
* The user browser has only registered bPay.
* There is a commercial promotion campaign cooperation between merchant website and aPay.
* The merchant want to the user browser to display both aPay and bPay during the promotion cooperation period. It is preferred to display aPay in a higher priority.
* When the promotion cooperation period is over, the merchant website recommend aPay and bPay to the user browser. (TBD: discussion: the following behavior of the browser need to be specified by the Payment App spec)




#2. Proposal 
##2.1: JS API for payment app registration status query
In the above example, the merchant website need an API to query the registration status of the user's browser. Then the merchant website can implement the preferred payment recommendation logic based on the registration status of the user browser.


##2.2: JS API to influence payment app selection
In the above example, the merchant website also need an API to influence the payment app selection.  
