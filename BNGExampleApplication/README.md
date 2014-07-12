### BNG Example Application

This application gives a quick demo of the [aping-ios-sdk](https://github.com/betfair/aping-ios-sdk). Examples include:

+   Logging into APING
+   Getting a user's funds (how much money does a user have in their wallets)
+   Retrieving a list of `BNGEventType` objects.
+   Retrieving a list of `BNGEvent` objects.
+   Retrieving a list of `BNGMarketCatalogue` objects.
+   Retrieving a list of `BNGMarketBook` objects.
+   Placing a `BNGLimitOrder` on a `BNGMarketBook` (i.e placing a regular exchange bet)
+   Updating an existing `BNGLimitOrder` on a `BNGMarketBook` with a type of `BNGPersistanceTypePersist`
+   Replacing an existing `BNGLimitOrder` on a `BNGMarketBook` (i.e updating a bet to have a different price)
+   Getting the `BNGMarketProfitAndLoss` for a `BNGMarketBook`.
+   Cancelling a `BNGLimitOrder` on a `BNGMarketBook`

When you run the application, you should see a list of opertions executed on a market.

`BNGExampleViewController` houses **ALL** the logic associated with the steps above.

### Requirements

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BNGAPI in your projects.

When you clone this repo, just execute the following on the command line to bring down the latest version of the [aping-ios-sdk](https://github.com/betfair/aping-ios-sdk).

```ruby
pod install
```

### Usage

See `BNGExampleViewController` and change the following lines of code to work with your own account/details

```ruby
// some preliminary APING setup first. You will need to change this to your specific appKey/scheme/product/username/password
NSString *appKey = @"YOUR_APP_KEY_GOES_HERE";
NSString *scheme = @"YOUR_SCHEME_GOES_HERE";
NSString *product = @"YOUR_PRODUCT_GOES_HERE";
NSString *username = @"YOUR_USERNAME_GOES_HERE";
NSString *password = @"YOUR_PASSWORD_GOES_HERE";
```

### Documentation

All documentation for BNG API is available at http://cocoadocs.org/docsets/BNGAPI/.

All APING documentation is available at https://api.developer.betfair.com/services/webapps/docs/dashboard.action

https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG has instructions for how to get up and running with your own application key.
