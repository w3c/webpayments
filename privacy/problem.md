# The Problem
<sup>[Home][home] > The Problem</sup>

*This document steals significantly from [FedCM's Problem
statement][fedcm-problem] - our thanks to them for their excellent overview!*

Payments, and in particular e-commerce, is a core part of users' experiences on
the web today, and drives a substantial part of the internet economy. Over the
last three decades, countless advancements and innovations have sought to make
web payments faster, more convienent, and more secure.

The payment experiences that exist on the web today were largely built
independently of and on-top-of the Web Platform, rather than as part of the
Web Platform. Innovators worked within the Web's limitations to build new
experiences.

Due to this, web payment flows were designed on top of general purpose Web
Platform capabilities such as top-level navigations/redirects with parameters,
window popups, iframes and cookies.

However, because these general purpose primitives can be used for an open-ended
number of use cases (by design), browsers have to apply policies that apply to
the lowest common denominator of abuse; at best applying cumbersome permissions
(e.g. popup blockers) and at worst entirely blocking features (e.g. blocking
third-party cookies).

Now, more than ever, browsers are looking to improve user privacy and are
applying stricter and stricter policies around these primitives.

> Publicly announced browser positions on third-party cookies:
>
> 1. [Safari][safari-cookies]: third-party cookies are **already** blocked by
     **default**.
> 1. [Firefox][firefox-cookies]: some third-party cookies are **already**
     blocked **by a blocklist**.
> 1. [Chrome][chrome-cookies]: on iOS **already** blocked **by default** and
     intends to offer **alternatives** to make them **obsolete** in the [near
     term][chrome-cookies-future].

While it is easier to see the **current** impact of third-party cookies, it is
equally important to understand the ways in which the low level primitives
that web payments depend on (e.g. redirects) are being abused, and the [privacy
principles](https://github.com/michaelkleber/privacy-model) that browsers are
using to control those primitives, so that we don't corner ourselves into a dead
end. For example, most browsers have made some form of policy statement around
the problem of [bounce tracking][fedcm-bounce-tracking], which uses link
decoration to track users:

> Publicly announced positions by browsers on bounce tracking:
>
> - Safari's existing deployed [strategies][safari-bounce-tracking-strategies]
    and [principles][safari-bounce-tracking-principles].
> - Firefox's protection against [redirect tracking][firefox-redirect-tracking].
> - Chrome's stated [Privacy Model][chrome-privacy-model] for the Web.

If browsers are applying stricter policies around the low level primitives that
web payments depend on, how do we continue to enable payments on the web?

*Continue to: [An enumeration of known Payment-related flows on the web][payment-flows]*

[home]: README.md
[fedcm-problem]: https://github.com/WICG/FedCM/blob/main/explainer/problem.md#navigational-tracking
[safari-cookies]: https://webkit.org/blog/10218/full-third-party-cookie-blocking-and-more/
[firefox-cookies]: https://blog.mozilla.org/blog/2019/09/03/todays-firefox-blocks-third-party-tracking-cookies-and-cryptomining-by-default/
[chrome-cookies]: https://blog.google/products/chrome/privacy-sustainability-and-the-importance-of-and/
[chrome-cookies-future]: https://www.blog.google/products/chrome/building-a-more-private-web/
[fedcm-bounce-tracking]: https://github.com/WICG/FedCM/blob/main/explainer/problem.md#navigational-tracking
[safari-bounce-tracking-strategies]: https://webkit.org/blog/11338/cname-cloaking-and-bounce-tracking-defense/
[safari-bounce-tracking-principles]: https://github.com/privacycg/proposals/issues/6
[firefox-redirect-tracking]: https://blog.mozilla.org/security/2020/08/04/firefox-79-includes-protections-against-redirect-tracking/
[chrome-privacy-model]: https://github.com/michaelkleber/privacy-model
[payment-flows]: payment-flows/README.md
