//
//  Utils.swift
//  Rent-A-Bike
//
//  Created by Partho Biswas on 5/27/16.
//  Copyright © 2016 Partho Biswas. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration



let k_ScreenHeight = ((Float(UIDevice.current.systemVersion)! < Float(8.0)) ? (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width) : UIScreen.main.bounds.size.height)
let k_ScreenWidth = ((Float(UIDevice.current.systemVersion)! < Float(8.0)) ? (UIInterfaceOrientationIsPortrait(UIApplication.shared.statusBarOrientation) ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height) : UIScreen.main.bounds.size.width)

let SCREEN_MAX_LENGTH = (max(k_ScreenWidth, k_ScreenHeight))
let SCREEN_MIN_LENGTH = (min(k_ScreenWidth, k_ScreenHeight))

let IS_IPAD = (UI_USER_INTERFACE_IDIOM() == .pad)
let IS_IPHONE = (UI_USER_INTERFACE_IDIOM() == .phone)
let IS_IPOD = (UIDevice.current.model == "iPod touch")
let IS_RETINA = (UIScreen.main.scale >= 2.0)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5_OR_LESS = (IS_IPHONE && (IS_IPHONE_4_OR_LESS || IS_IPHONE_5))
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6S = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
let IS_IPHONE_6SP = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

let kTableViewBGImageName: String = (IS_IPAD ? "no_data_iPad" : (IS_IPHONE_6P ? "no_data_iPhone6P" : (IS_IPHONE_6 ? "no_data_iPhone6" : (IS_IPHONE_5 ? "no_data_iPhone5" : "no_data_iPhone4"))))

struct Helper {
    
    static let screenSize: CGRect = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
    
    

    
    public static func setUserDefault(_ ObjectToSave : String , KeyToSave : String) {
        let defaults = UserDefaults.standard
        
        defaults.set(ObjectToSave, forKey: KeyToSave)
        
        UserDefaults.standard.synchronize()
    }
    
    public static func getUserDefault(_ KeyToReturnValye : String) -> String? {
        let defaults = UserDefaults.standard
        
        if let name:String = defaults.value(forKey: KeyToReturnValye) as? String {
            
            return name
        }
        return nil
    }
    
    public static func convertJsonStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    
    public static func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    public static func getRandomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

