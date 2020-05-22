//
//  ViewController.swift
//  Demo
//
//  Created by Nikhil Sharma on 02/07/18.
//  Copyright © 2018 Nikhil Sharma. All rights reserved.
//

import UIKit
import SwiftiCache

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func storeProductDataToCache() {
        let item1 = Product(name: "LXI 1",
                            proudctId: 3237,
                            productSKU: "MKL435678",
                            price: 320.90)
        SwiftiCacheManager.sharedInstance.setObject(item1,forKey: "product")
    }
    
    func fetchProductDataFromCache() {
        let result = SwiftiCacheManager.sharedInstance.getObjectForKey("product")
        debugPrint("Fetched result from cache \(String(describing: result))")
    }
    @IBAction func fetchDataButtonAction(_ sender: Any) {
        fetchProductDataFromCache()
    }
    @IBAction func storeDataButtonAction(_ sender: Any) {
        storeProductDataToCache()
    }
    
}

