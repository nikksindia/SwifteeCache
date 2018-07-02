# NKCache

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/NKCache.svg)](https://cocoapods.org/pods/NKCache)  
![Platform](https://img.shields.io/cocoapods/p/NKCache.svg?style=flat)

Simple on disk cache, backed by an NSCache in memory. It automatically purges itself when memory gets low.

NOTE: Data Model needs to implement 'Codable(Encodable&Decodable)' protocol to be saved on the cache.

## Requirements

- iOS 9.0+
- Xcode 8.1

## Installation

#### CocoaPods
You can use [CocoaPods](https://cocoapods.org/) to install `NKCache` by adding it to your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!
pod 'NKCache'
```

#### Manually
1. Download and drop ```NKCache.swift``` in your project.  
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
func getObjectForKey<T:Codable>(_ key:String, completionHandler: @escaping (T?)->())
func objectExistsForKey(_ key:String)->Bool
```

## Contribute

We would love you for the contribution to **NKCache**, check the ``LICENSE`` file for more info.

## Meta

Nikhil Sharma – [@devilnikks](https://twitter.com/devilnikks) – nikksindia@gmail.com

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/nikksindia](https://github.com/nikksindia/)

[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-green.svg
[license-url]: https://github.com/nikksindia/NKCache/License.md
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
