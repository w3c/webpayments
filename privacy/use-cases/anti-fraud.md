# Anti-Fraud use of Third-Party Cookies
<sup>[Home][home] > [Use Cases][use-cases] > Anti-Fraud</sup>

Anti-fraud is an important use-case in many payment applications; both defending
against fradulent users as well as fradulent merchants. How parties detect fraud
is a complex question that differs from party to party, which makes reasoning
about it difficult. However, one common mechanism is to - after a previous
successful payment on the current device - store a cookie noting that there was
a successful payment on this device for a given payment instrument. Since
fraud-detection is often performed in a cross-origin iframe (e.g., a 3DS
challenge iframe hosting the 3DS ACS), these cookies become third-party cookies.

Due to the complexities around anti-fraud and privacy on the web, a specific
[Anti-Fraud Community Group][anti-fraud-cg] has been created. Interested members
from the payment industry are encouraged to join the Community Group.

[home]: ../README.md
[use-cases]: README.md
[anti-fraud-cg]: https://www.w3.org/community/antifraud/
