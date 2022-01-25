# EMV&reg; Secure Remote Commerce (SRC) User Recognition
<sup>[Home][home] > [Use Cases][use-cases] > SRC User Recognition</sup>

See more [information about EMV&reg;SRC](https://www.emvco.com/emv-technologies/src/), including the "Click-to-Pay" consumer facing UX.

## Overview of Click-to-Pay Flow

* The user pushes the Click-to-Pay button on a merchant site. This is typically provided by another party, the SRC Initiator (SRC-I), in a 3p context.
* The SRC-I determines (via a cookie, typically) whether this is a returning user, and if so finds the user's SRC identity (e.g., email address).
* The SRC-I dispatches the identity to different SRC systems (typically the card networks) and aggregates the responses into a candidate card list (i.e., cards registered in SRC systems under that user identity).
* The SRC-I displays the list of cards to the user for selection.
* (The rest of the flow happens, but it is not essential to understanding the problem statement.)

## Expected Impact

The desired user experience is that the user pushes the Click-to-Pay button and is presented with a list of registered cards.

If third-party cookies are unavailable, an SRC-I will not recognize the user across different merchant sites. This means that the user will need to enter the SRC identity (e.g., via a form field) and possibly other information on each merchant site.

### Possible Alternatives

* Common origin for SRC opening a popup in 1p context
* Payment handler (which could open in a 1p context)
* Common origin for SRC leveraging discoverable credentials.


[home]: ../README.md
[use-cases]: README.md
