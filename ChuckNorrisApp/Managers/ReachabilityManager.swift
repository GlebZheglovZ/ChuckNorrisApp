//
//  InternetTest.swift
//  Maryno.NET (New Version)
//
//  Created by Глеб Николаев on 01/06/2019.
//  Copyright © 2019 Глеб Николаев. All rights reserved.
//

import Foundation
import SystemConfiguration

// Framework for checking Internet Status Reachability

final class Reachability {
    
        private init() { }
    
        static let shared = Reachability()
    
        static func isConnectedToNetwork() -> Bool {
        
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
    
    static func checkInternetActivity() -> Bool {
        if Reachability.isConnectedToNetwork() {
            print("Wi-Fi/Cellular: ON")
            return true
        }
        else {
            print("Wi-Fi/Cellular: OFF")
            return false
        }
    }
    
}
