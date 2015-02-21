//
//  ViewController.swift
//  Parrot
//
//  Created by Jack Cook on 2/21/15.
//  Copyright (c) 2015 Jack Cook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pocketAuthenticated", name: pocketAuthenticatedNotification, object: nil)
        
        authenticatePocket()
    }
    
    func pocketAuthenticated() {
        let url = NSURL(string: "https://getpocket.com/v3/get")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json; charset=UTF8", forHTTPHeaderField: "Content-Type")
        
        let body = ["consumer_key": pocketConsumerKey, "access_token": pocketAccessToken]
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: nil)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            if let result = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as? NSDictionary {
                if let list = result["list"] as? NSDictionary {
                    for (item_id, dict) in list {
                        if let data = dict as? NSDictionary {
                            if let item_id = data["item_id"] as? String {
                                if let title = data["resolved_title"] as? String {
                                    if let url = data["resolved_url"] as? String {
                                        if let status = dict["status"] as? String {
                                            if let word_count = dict["word_count"] as? String {
                                                let object = PTObject()
                                                object.item_id = item_id.toInt()!
                                                object.title = title
                                                object.url = NSURL(string: url)!
                                                object.status = status.toInt()!
                                                object.word_count = status.toInt()!
                                                objects.append(object)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            println(objects.count)
        }
    }
}
