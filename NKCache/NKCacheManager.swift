//
//  NKCacheManager.swift
//  NKCache
//
//  Created by Nikhil Sharma on 29/06/18.
//  Copyright © 2018 Nikhil Sharma. All rights reserved.
//

import Foundation

public class NKCacheManager{
    
    private var directoryUrl:URL?
    private var fileManager:FileManager{
        return FileManager.default
    }
    
    /// Serial queue for cache read/write operations
    private var cacheQueue = DispatchQueue(label:"com.nikkscache.dev.cacheQueue")
    
    /// Singleton instance
    public static var sharedInstance = NKCacheManager.init(cacheName: Bundle.main.infoDictionary?["TargetName"] as? String ?? "MyAppCache")
    
    //MARK:- Initializers
    
    /// Private class initializer
    private init() {}

    /// This initializer method will use ~/Library/Caches/com.nikkscache.dev/targetName to save data
    ///
    /// - Parameter cacheName: Name of the cache (by default it is 'TargetName')
    private init(cacheName:String){
        if let cacheDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        {
            let dir = cacheDirectory + "/com.nikkscache.dev/" + cacheName
            directoryUrl = URL.init(fileURLWithPath: dir)
            if !(fileManager.fileExists(atPath: dir)){
                do{
                    try fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
                    excludeFromBackup(fileUrl: &directoryUrl!)
                }catch{ }
            }
        }
    }
    
    //MARK:- Adding / Removing Cached Object
    
    
    /// This method will write Object of specified type to a particular key in cache directory
    ///
    /// - Parameters:
    ///   - object: Object to be cached
    ///   - key: Identifier in cache for object
    public func setObject<T:Codable>(_ object:T,forKey key:String){
        
        cacheQueue.async { [weak self] in
            //dispatch asynchronously on cacheQueue
            guard let path = self?.pathForKey(key)
                else {
                    print("File at path for key : \(key) not found")
                    return}
            do {
                let data = try PropertyListEncoder().encode(object)
                let success = NSKeyedArchiver.archiveRootObject(data, toFile: path)
                var fileUrl = URL.init(fileURLWithPath: path)
                self?.excludeFromBackup(fileUrl: &fileUrl)
                print(success ? "data saved to cache SUCCESSFULLY" : "data caching FAILED")
            }catch {
                print("data caching FAILED")
            }
        }
    }
    
    
    /// This method will remove Object corresponding to specified key
    ///
    /// - Parameter key: Identifier in cache for object
    public func removeObjectForKey(_ key:String){
        cacheQueue.sync { [weak self] in
            //dispatch asynchronously on cacheQueue
            guard let path = self?.pathForKey(key)
                else {
                    print("File at path for key : \(key) not found")
                    return}
            do{
                try fileManager.removeItem(atPath: path)
                print("cached data for key \(key) removed SUCCESSFULLY")
            }catch{
                print("FAILED removing cachced data for key \(key)")
            }
        }
        
    }
    
    
    /// This method will remove all the cached data
    public func removeAllObjects(){
        cacheQueue.async { [weak self] in
            do{
                try self?.fileManager.contentsOfDirectory(at: (self?.directoryUrl)!, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles).forEach{
                    do{
                        try self?.fileManager.removeItem(atPath: ($0.path))
                        print("cached data item removed SUCCESSFULLY")
                    }catch{
                        print("FAILED removing cached data item")
                    }
                }
            }catch{
                print("FAILED removing all cached data")
            }
        }
    }
    
    //MARK: - Fetching cached object
    
    /// This method is used to retrieve value from cache for specified key
    ///
    /// - Parameters:
    ///   - key: Identifier in cache for object
    ///   - completionHandler: For handling completion state of fetch operation
    public func getObjectForKey<T:Codable>(_ key:String, completionHandler: @escaping (T?)->()){
        cacheQueue.async { [weak self] in
            //dispatch asynchronously on cacheQueue
            guard let path = self?.pathForKey(key)
                else {
                    print("File at path for key : \(key) not found")
                    completionHandler(nil)
                    return}
            guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? Data else {
                print("ERROR data retriving from cache")
                completionHandler(nil)
                return }
            do {
                let object = try PropertyListDecoder().decode(T.self, from: data)
                print("data retriving SUCCESSFULLY from cache")
                completionHandler(object)
            } catch {
                print("ERROR data retriving from cache")
                completionHandler(nil)
            }
        }
    }
    
    
    /// This method will return whether the Object for the specified key exists in cache or not
    ///
    /// - Parameter key: Identifier in cache for object
    public func objectExistsForKey(_ key:String)->Bool{
        guard let path = pathForKey(key)
            else {
                print("File at path for key : \(key) not found")
                return false}
        return fileManager.fileExists(atPath: path)
    }
    
    //MARK: - Private Methods
    
    
    /// This method returns Directory url path for specified key
    ///
    /// - Parameter key: Identifier in cache for object
    private func pathForKey(_ key:String)->String?{
        return directoryUrl?.appendingPathComponent(key).path
    }
    
    
    /// This method is used beacuse it is required as per App Store Review Guidelines/ iOS Data Storage Guidelines to exculude files from being backedup on iCloud.
    ///
    /// - Parameter fileUrl: filePath url for file to be excluded from backup
    @discardableResult
    private func excludeFromBackup(fileUrl:inout URL)->Bool{
        if fileManager.fileExists(atPath: fileUrl.path){
            fileUrl.setTemporaryResourceValue(true, forKey: .isExcludedFromBackupKey)
            return true
        }
        return false
    }
    
}
