### Build Status

[![Build Status](https://travis-ci.org/betfair/aping-ios-sdk.svg?branch=master)
[![Coverage Status](https://img.shields.io/coveralls/betfair/aping-ios-sdk.svg)

### APING iOS Client

This package includes a library for interacting with Betfair's [APING](https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/API-NG+Overview).

### Requirements

Your project will need a deployment target of iOS5 or above.

### Installation

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like BNGAPI in your projects.

#### Podfile

```ruby
platform :ios, '6.0'
pod "BNGAPI", "1.1"
```

Alternatively, you can just git submodule BNGAPI into your project. All steps in [Jeff Verokey's iOS Framework guide](https://github.com/jverkoey/iOS-Framework) are followed for BNGAPI.

### Usage

The sample application in this repository include a simple example of how to log into Betfair's services and retrieve a session token. Session tokens uniquely identify an authorised session & is a prerequisite for a lot of betting operations.

The sample application code **must be modified** to include your own APING application key before it can be run.
An application key can be requested from https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Getting+Started+with+API-NG

See `BNGExampleViewController` for more details on how to login to Betfair's services.

### Documentation

All APING documentation is available at https://api.developer.betfair.com/services/webapps/docs/dashboard.action
