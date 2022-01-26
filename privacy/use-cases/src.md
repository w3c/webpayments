# EMV&reg; Secure Remote Commerce (SRC) User Recognition
<sup>[Home][home] > [Use Cases][use-cases] > SRC User Recognition</sup>

See more [information about EMV&reg;SRC](https://www.emvco.com/emv-technologies/src/), including the "Click-to-Pay" consumer facing UX.

## Overview of Click-to-Pay Flow

* During an enrollment phase, the user registers a card with an SRC System; thus the SRC System has a relationship and uses cookies to recognize returning users.
* At transaction time, the user pushes the Click-to-Pay button on a merchant site. This is typically provided by another party, the SRC Initiator (SRC-I), in a 3p context.
* The SRC-I interacts with each SRC system (by dispatching SRC system cookies to their servers) to establish whether this is a returning user, and if so, to retrieve registered cards.
* The SRC-I aggregates the responses into a candidate card list (i.e., cards registered in SRC systems under that user identity).
* The SRC-I displays the list of cards to the user for selection.
* (The rest of the flow happens, but it is not essential to understanding the problem statement.)

## Expected Impact

The desired user experience is that the user pushes the Click-to-Pay button and is presented with a list of registered cards.

This experience today relies on user recognition by SRC systems 
in a third-party context. If third-party cookies are unavailable, an
SRC system will not be able to recognize the user across different
merchant sites. This means that the user will need to enter the SRC
identity (e.g., via a form field) and possibly other information on
each merchant site.

### Possible Alternatives

* Common origin for SRC opening a popup in 1p context
* Payment handler (which could open in a 1p context)
* Common origin for SRC leveraging discoverable credentials.


[home]: ../README.md
[use-cases]: README.md
