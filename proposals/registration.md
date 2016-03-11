# Payment App Registration

*Note: This is the first draft of this proposal. Expect fairly substantial changes. Feedback welcome and strongly encouraged on the [issue tracker](https://github.com/WICG/paymentrequest/issues).*

### What is this?

This is a proposal for how Payment App registration could work in conjunction with the [PaymentRequest API](http://wicg.github.io/paymentrequest/specs/paymentrequest.html). The goals of this explainer are as follows:

1. Propose a system for registering payment apps within a User-Agent
2. Propose a messaging format for how data gets passed between Payments Apps and User-Agents
3. Propose a system for communicating with Payment Apps within a pure web environment (i.e. just using a browser)

Note that this document focuses on how Payment App registration could work in a pure web environment. Different platforms may define their own requirements (e.g. Android may require use of intents), but that is beyond the scope of this document.

Throughout this document we occasinally make reference to a fictitious Payment App provider, BobPay (www.bobpay.xyz).

### At a high level

At its core, a registered payment app is nothing more than a stored URL. There is no logic (except in the case of a service worker, see below for more information) and no stored UI. This is not to say that logic and UI are not required, they are just not stored at time of registration. The assumption is that on the other end of that URL is a web page that understands how to communicate with PaymentRequest. The full lifecycle looks something like:

1. A user visits the website of a payment app provider
2. The payment app provider calls registerPaymentApp(), passing in the location of the manifest file containing details of the payment app (residing on same origin)
3. The user is prompted by the User-Agent to register the payment app
4. If the user gives consent, the User-Agent stores that preference (most likely as a URL and a cache of the manifest file)
5. When making a purchase, if the merchant supports the `identifying_url` as a supported payment app, the User-Agent presents the payment app as a viable payment option
6. If the user chooses the payment app at time of checkout, the `embeddable_url` is embedded as an iFrame within the checkout flow where the user can finalize the purchase flow. Messages are passed via postMessage.
7. After a user is finished within the payment app, the payment app uses postMessage to return a paymentResponse to the User-Agent and ultimately to the merchant

### Defining a Payment App

Payment providers wishing to provide a payment app must first declare information about their payment app within a Payment App [Manifest](https://developers.google.com/web/updates/2014/11/Support-for-installable-web-apps-with-webapp-manifest-in-chrome-38-for-Android?hl=en).

A Payment App Manifest is an extension of the existing Web App Manifest specification that adds support for two new fields: `payment_url` and `identifying_url`.

The `payment_url` is a URL of a web page that can be embedded into a checkout flow and knows how to communicate with PaymentRequest via postMessage (e.g. https://www.bobpay.xyz).

The `identifying_url` is the URL that is matched against the merchant's array of [supportedMethods](http://wicg.github.io/paymentrequest/specs/paymentrequest.html#paymentrequest-constructor) in PaymentRequest (e.g. https://www.bobpay.xyz/embedded/paymentrequest).

Both `payment_url` and `identifying_url` must be of the same origin as the website requesting registration.

The assumption is that this manifest file always contains the most up-to-date information about the payment app. User-Agents may cache the manifest file for faster experiences, but the User-Agent is responsible for routinely checking the manifest file for updates.

An example Manifest file is as follows:

```js
{
	"short_name": "Bob\'s Payments",
	"name": "Bob\'s Payments - The Payment of the Future",
	"payment_url": "https://www.bobpay.xyz/embedded/paymentrequest",
	"identifying_url": "bobpay.xyz",
	"related_applications": [
	  {
	    "platform": "play",
	    "url": "https://play.google.com/store/apps/details?id=com.bobspayments.app1",
	    "id": "com.example.app1"
	  }, {
	    "platform": "itunes",
	    "url": "https://itunes.apple.com/app/bobspayments/id123456789",
	  }
  	],
	"icons": [
      {
        "src": "icon/lowres.webp",
        "sizes": "48x48",
        "type": "image/webp"
      },{
        "src": "icon/lowres",
        "sizes": "48x48"
      },{
        "src": "icon/hd_hi.ico",
        "sizes": "72x72 96x96 128x128 256x256"
      },{
        "src": "icon/hd_hi.svg",
        "sizes": "72x72",
        "density": 2
      }
	]
}
```

Using Manifest files give us a number of benefits but two specifically are worth highlighting: 1.) It allows us to leverage an existing specification that already defines a way of providing necessary branding elements (icons, colors) that are useful from a UI perspective. 2.) It allows the User-Agent to fetch information about a payment app independent of an explicit install request from the payment app provider website. This could be useful in a variety of flows (e.g. install prompts within PaymentRequest UI).

### Registering a Payment App

> Note: The naming/namespacing of this API needs a lot more consideration.

Once a manifest file has been created and uploaded, it should be linked at `identifying_url` (e.g. `<link rel="manifest" href="/payment-manifest.json">`).

Payment app providers can then explicitly request installation, e.g.:

```js
// Origin must be same
var promise = registerPaymentApp("https://www.bobpay.xyz");

promise
	.then(function(installResponse) {
		console.log('Payment app installed');
	})
	.catch(function(err) {
		console.error("Uh oh, something bad happened", err.message);
	});

```

Note that the User-Agent may not honor the request to install a payment app. For example, if the user has already rejected registration some number of times, the User-Agent may decide to block the next request. This would immediately resolve in an error.

### Communicating with Payment Apps

> Notes: 
> 
> This needs more consideration and should be viewed primarily as a starting point for discussion.

Payment apps communicate with the service embedding the iFrame (e.g. the User-Agent) via `postMessage`.

Once the payment app has loaded, the payment app starts listening for messages:

```js
//https://www.bobpay.xyz/embedded/paymentrequest

window.addEventListener('message', receiveMessage);

function receiveMessage(e) {
	var paymentRequest = JSON.parse(e.data);
	performBobPayAuth();
};
```

The browser then passes on a formatted version of the PaymentRequest to the payment app. Note that [PaymentDetails](http://wicg.github.io/paymentrequest/specs/paymentrequest.html#paymentdetails-dictionary) remains the same, but shipping information is removed. Just like in [PaymentRequest](http://wicg.github.io/paymentrequest/specs/paymentrequest.html), the total amount that should be charged is the final item in `items`.  In addition, method-specific data that matches the `identifying_url` is passed into the request.

```js
var formattedRequest = {
	'paymentDetails': {
		items: [
			{
				'id': '1',
				'label': 'Subtotal',
				'amount': {
					'currencyCode': 'USD',
					'value': '55.00'
				}
			},
			{
				'id': '2',
				'label': 'Tax',
				'amount': {
					'currencyCode': 'USD',
					'value': '5.00'
				}
			},
			{
				'id': '3',
				'label': 'Total',
				'amount': {
					'currencyCode': 'USD',
					'value': '60.00'
				}
			},
		]
	}
	'bobpay.xyz': {
		'merchantId': 'alicesdonuts.xyz',
		'publicKey': 'bp-123456'
	}
};

// Post the message back to the User-Agent
paymentAppFrame.postMessage(JSON.stringify(formattedRequest), 'https://www.bobpay.xyz');
```

The payment app can then parse the response and update their UI flow to authenticate the user, choose a payment method, etc. When the payment app is ready, the payment app returns a response that will ultimately be passed back to the merchant. This should contain information necessary to process the final transaction or confirm a transaction took place. It is assumed the merchant understands how to parse this response.

```js
var exampleResponse = {
	'id': 'BOBPAY-123456',
	'create_time': '2013-01-31T04:12:02Z',
	'state': 'approved',
	'payment_method': 'bobPayToken',
	'token': 'BPT-09876'
};

window.top.postMessage(JSON.stringify(exampleResponse), '*');
```

Lastly, the original PaymentRequest promise is resolved and the merchant is able to parse the reply from the Payment App:

```js
paymentRequest.show().then(function(paymentResponse) {
	console.log(JSON.parse(paymentResponse));
	/*
	{
		'methodName': 'bobpay.xyz',
		'details': {
			'id': 'BOBPAY-123456',
			'create_time': '2013-01-31T04:12:02Z',
			'state': 'approved',
			'payment_method': 'bobPayToken',
			'token': 'BPT-09876'
		}
	}
	*/
});
```

### Increased Sophistication

One of the down sides of the `embeddable_url` approach is that it assumes the Payment App always wants to show UI. There may be cases when explicit UI is unnecessary (e.g. the user is already authenticated) and the payment response can be immediately returned. There are two possible solutions to this:

1.) We could implement a message passing mechanism wherein the first message the payment app posts back to the parent is whether or not UI is necessary. If not, the payment app could immediately post back the requisite information for payment. This is fine, but it still requires the use of iFrames and postMessage.

2.) The second mechanism is to use a [ServiceWorker](https://github.com/slightlyoff/ServiceWorker/blob/master/explainer.md). Example of this is forthcoming.

### Open issues

* The current proposal does not leave room for generic wallets that store multiple payment credentials that are not necessarily bound to their domain. One example would be services that securely store credit cards for users and allow them to fill them on websites, such as 1Password. One possible solution would be to add a third attribute in the payment manifest called `supported_payment_methods`, which is an array of other supported payment methods. This is tricky, however, because a payment app *supporting* a particular payment method does not mean it has that payment method *available*. For example, 1Password may support storing American Express credit cards, and the merchant may support American Express credit cards, but that doesn't mean the user has an American Express card stored. This presents a tricky UI problem that is difficult to resolve without some communication between the User-Agent and the Payment App at time of payment. Given this, this use case has been left out for a V1 of this spec.
* Should we define a new manifest explicitly called "payment-manifest" that extends the current web app manifest? Or should we just add the additional fields to the web app manifest spec?
* How should errors be handled?
* Do we need to pass in all line items to the payment app? Or should we just pass in total amount plus currency?
* How should the payment app verify origin if they don't know who is requesting payment yet? How should it work if the browser is passing the message on behalf of the merchant?