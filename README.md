# SwifteeCache

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/SwifteeCache.svg)](https://cocoapods.org/pods/SwifteeCache)  
![Platform](https://img.shields.io/cocoapods/p/NKCache.svg?style=flat)
[![Build Status](https://travis-ci.com/nikksindia/SwifteeCache.svg?branch=master)](https://travis-ci.com/github/nikksindia/SwifteeCache)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Simple on disk cache, backed by an NSCache in memory. It automatically purges itself when memory gets low.


Features
===============

- Support all data types confirming to `Codable` protocol
- Thread safe and optmised for fater caching
- Objects can be purged in case of low memory in the system

## Requirements

- iOS 10.0+
- Xcode 9+

## Installation

#### CocoaPods
You can use [CocoaPods](https://cocoapods.org/) to install `SwifteeCache` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'SwifteeCache'
```

#### Carthage
Create a `Cartfile` that lists the framework and run `carthage update`. Follow the [instructions](https://github.com/Carthage/Carthage#if-youre-building-for-ios) to add `$(SRCROOT)/Carthage/Build/iOS/SwifteeCache.framework` to an iOS project.

```
github "nikksindia/SwifteeCache"
```

#### Manually
1. Download and drop ```SwifteeCache.swift``` in your project.  
2. Congratulations!  

## Usage

For adding/removing objects in cache:

```swift
func setObject<T:Codable>(_ object:T,forKey key:String)
func removeObjectForKey(_ key:String)
func removeAllObjects()
```

For fetching objects in cache:

```swift
func getObjectForKey<T:Codable>(_ key:String)->T?
func objectExistsForKey(_ key:String)->Bool
```

## Contribute

We would love you for the contribution to **SwifteeCache**, check the ``LICENSE`` file for more info.

## Meta

Nikhil Sharma – [@devilnikks](https://twitter.com/devilnikks) – nikksindia@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/nikksindia](https://github.com/nikksindia/)

[swift-image]:https://img.shields.io/badge/swift-5.1-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-green.svg
[license-url]: https://github.com/nikksindia/NKCache/License.md
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
