//
//  Reachability.swift
//  SearchBuddy
//
//  Created by Lucas Veras Aguiar Cardoso on 10/29/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import SystemConfiguration

class Reachability: NSObject {
    
    class func testConnection() -> Bool {
        var zeroAddress = sockaddr_in()
        var flags = SCNetworkReachabilityFlags()
        
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        
        return (isReachable && !needsConnection)
    }
}
