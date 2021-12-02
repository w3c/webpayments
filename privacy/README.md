# Web Payments - Privacy Explorations

This directory contains the Web Payments Working Group's active explorations
into how to evolve payments on the web as the result of ongoing privacy-oriented
changes in browsers (e.g. [1], [2], and [3]). The goals of these explorations
are to:

1. Identify where payment flows have already been or will be affected by known
   privacy-preservation measures from browser vendors (e.g., 3p cookie
   blocking).

1. Understand payment flows on the web, what user information is involved, and
   how that information is transmitted between parties, in order to gauge the
   potential impact of future privacy changes in browsers on web payments.

1. Explore new, privacy-preserving solutions to allow users to make payments on
   the web.

So far, this work consists of the following efforts:

* [A problem statement][problem-statement]
* [An enumeration of known Payment-related flows on the web][payment-flows]
* [A set of known use-cases that will be affected by privacy changes][use-cases]

## Acknowledgements

- [FedCM], from whom we copied structure and wording around these documents.

[1]: https://webkit.org/blog/10218/full-third-party-cookie-blocking-and-more/
[2]: https://blog.mozilla.org/en/products/firefox/todays-firefox-blocks-third-party-tracking-cookies-and-cryptomining-by-default/
[3]: https://blog.google/products/chrome/privacy-sustainability-and-the-importance-of-and/
[FedCM]: https://github.com/WICG/FedCM
[problem-statement]: problem.md
[payment-flows]: payment-flows/README.md
[use-cases]: use-cases/README.md
