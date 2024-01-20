//
//  PaywallerProvider.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation

@available(iOS 15.0, *)
public enum PaywallerAppProviderConfiguration{
    case adapty(apiKey : String, placementIDs : [String], accessLevel : String)
    case revenuecat
    case none
}

public enum PaywallerPaywallProviderConfiguration{
    case adapty(placementID : String)
    case revenuecat
    case none
}
