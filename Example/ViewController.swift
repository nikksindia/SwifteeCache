//
//  ViewController.swift
//  Example
//
//  Created by Nikhil Sharma on 23/05/20.
//  Copyright © 2020 Nikhil Sharma. All rights reserved.
//

import UIKit
import SwifteeCache

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
        SwifteeCache.sharedInstance.setObject(item1,forKey: "product")
    }

    func fetchProductDataFromCache() {
      let result: Product? = SwifteeCache.sharedInstance.getObjectForKey("product")
      debugPrint("Fetched result from cache \(String(describing: result))")
    }
    @IBAction func fetchDataButtonAction(_ sender: Any) {
        fetchProductDataFromCache()
    }
    @IBAction func storeDataButtonAction(_ sender: Any) {
        storeProductDataToCache()
    }

}



