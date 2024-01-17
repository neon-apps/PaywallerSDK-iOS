//
//  PaywallerProvider.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation


public enum PaywallerProviderConfiguration{
    case adapty(apiKey : String, placementIDs : [String], accessLevel : String)
    case revenuecat
}

public enum PaywallerProviderPaywallConfiguration{
    case adapty(placementID : String)
    case revenuecat
    case none
}
