//
//  SwifteeCache.swift
//  SwifteeCache
//
//  Created by Nikhil Sharma on 29/06/18.
//  Copyright © 2018 Nikhil Sharma. All rights reserved.
//

import Foundation

final public class SwifteeCache {

  //MARK: Properties

  private var directoryUrl: URL?
  private var fileManager: FileManager {
    return FileManager.default
  }

  /// Concurrent queue for cache read/write operations
  private let cacheQueue = DispatchQueue(label:"com.nikkscache.dev.cacheQueue",
                                         attributes: .concurrent)

  /// Singleton instance
  public static var sharedInstance = SwifteeCache(cacheName: Bundle.main.infoDictionary?["TargetName"] as? String ?? "AppCache")

  //MARK:- Initializers

  /// Private class initializer
  private init() {}

  /// This initializer method will use ~/Library/Caches/com.nikkscache.dev/targetName to save data
  ///
  /// - Parameter cacheName: Name of the cache (by default it is 'TargetName')
  private init(cacheName:String) {
    if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory,
                                                                .userDomainMask, true).last {
      let dir = cacheDirectory + "/com.nikkscache.dev/" + cacheName
      directoryUrl = URL.init(fileURLWithPath: dir)
      if !(fileManager.fileExists(atPath: dir)) {
        do{
          try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
          excludeFromBackup(fileUrl: &directoryUrl!)
        } catch{ }
      }
    }
  }

  //MARK:- Adding / Removing Cached Object


  /// This method will write Object of specified type to a particular key in cache directory
  ///
  /// - Parameters:
  ///   - object: Object to be cached
  ///   - key: Identifier in cache for object
  public func setObject<T:Codable>(_ object:T,forKey key:String) {
    cacheQueue.async(flags: .barrier)  {
      //added barrier to ensure Read-Write lock
      guard let path = self.pathForKey(key)
        else {
          debugPrint("File at path for key : \(key) not found")
          return}
      do {
        let data = try PropertyListEncoder().encode(object)
        let success = NSKeyedArchiver.archiveRootObject(data, toFile: path)
        var fileUrl = URL.init(fileURLWithPath: path)
        self.excludeFromBackup(fileUrl: &fileUrl)
        debugPrint(success ? "data saved to cache SUCCESSFULLY" : "data caching FAILED")
      }catch {
        debugPrint("data caching FAILED")
      }
    }
  }


  /// This method will remove Object corresponding to specified key
  ///
  /// - Parameter key: Identifier in cache for object
  public func removeObjectForKey(_ key:String) {
    cacheQueue.async(flags: .barrier) {
      //added barrier to ensure Read-Write lock
      guard let path = self.pathForKey(key)
        else {
          debugPrint("File at path for key : \(key) not found")
          return}
      do{
        try self.fileManager.removeItem(atPath: path)
        debugPrint("cached data for key \(key) removed SUCCESSFULLY")
      }catch{
        debugPrint("FAILED removing cachced data for key \(key)")
      }
    }

  }


  /// This method will remove all the cached data
  public func removeAllObjects() {
    cacheQueue.async(flags: .barrier) {
      //added barrier to ensure Read-Write lock
      do {
        try self.fileManager.contentsOfDirectory(at: (self.directoryUrl)!,
                                                 includingPropertiesForKeys: nil,
                                                 options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles).forEach {
          do {
            try self.fileManager.removeItem(atPath: ($0.path))
            debugPrint("cached data item removed SUCCESSFULLY")
          } catch {
            debugPrint("FAILED removing cached data item")
          }
        }
      } catch {
        debugPrint("FAILED removing all cached data")
      }
    }
  }

  //MARK: - Fetching cached object

  /// This method is used to retrieve value from cache for specified key
  ///
  /// - Parameters:
  ///   - key: Identifier in cache for object
  public func getObjectForKey<T:Codable>(_ key:String) -> T? {
    var result: T?
    cacheQueue.sync {
      guard let path = self.pathForKey(key)
        else {
          debugPrint("File at path for key : \(key) not found")
          return }
      guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data else {
        debugPrint("ERROR data retriving from cache")
        return }
      do {
        let object = try PropertyListDecoder().decode(T.self, from: data)
        result = object
        debugPrint("data retriving SUCCESSFULLY from cache")
      } catch {
        debugPrint("ERROR data retriving from cache")
      }
    }
    return result
  }


  /// This method will return whether the Object for the specified key exists in cache or not
  ///
  /// - Parameter key: Identifier in cache for object
  public func objectExistsForKey(_ key:String)->Bool {
    guard let path = pathForKey(key)
      else {
        debugPrint("File at path for key : \(key) not found")
        return false }
    return fileManager.fileExists(atPath: path)
  }

  //MARK: - Private Methods


  /// This method returns Directory url path for specified key
  ///
  /// - Parameter key: Identifier in cache for object
  private func pathForKey(_ key:String)->String? {
    return directoryUrl?.appendingPathComponent(key).path
  }


  /// This method is used beacuse it is required as per App Store Review Guidelines/ iOS Data Storage Guidelines to exculude files from being backedup on iCloud.
  ///
  /// - Parameter fileUrl: filePath url for file to be excluded from backup
  @discardableResult
  private func excludeFromBackup(fileUrl:inout URL)->Bool {
    if fileManager.fileExists(atPath: fileUrl.path) {
      fileUrl.setTemporaryResourceValue(true, forKey: .isExcludedFromBackupKey)
      return true
    }
    return false
  }

}

