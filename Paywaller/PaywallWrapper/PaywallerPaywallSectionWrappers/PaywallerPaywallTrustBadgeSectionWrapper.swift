//
//  PaywallerPaywallTrustBadgeSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    static func createTrustBadgeSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let typeString = dict["type"] as? String,
           let type = trustBadgeTypeFromString(typeString, fromDict: dict) {
            return .trustBadge(type: type)
        }
        return nil
    }
    
    static func trustBadgeTypeFromString(_ typeString: String, fromDict dict: [String: Any]) -> PaywallerPaywallTrustBadgeType? {
        switch typeString {
        case "laurelWreath":
            if let rating = dict["rating"] as? Double,
               let title = dict["title"] as? String,
               let year = dict["year"] as? Int {
                return .laurelWreath(rating: rating, title: title, year: year)
            }
        case "stars":
            if let title = dict["title"] as? String {
                return .stars(title: title)
            }
        case "thropy":
            if let title = dict["title"] as? String,
               let year = dict["year"] as? Int {
                return .thropy(title: title, year: year)
            }
        default:
            return nil
        }
        return nil
    }
}

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    static func createTrustBadgeJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .trustBadge(type) = section else {
            return nil // Return nil if the input section is not of type .trustBadge
        }
        
        var trustBadgeDict: [String: Any] = [
            "index": index,
            "type": "trustbadge"
        ]
        
        var dataDict: [String: Any] = [:]
        
        switch type {
        case .laurelWreath(let rating, let title, let year):
            dataDict["type"] = "laurelWreath"
            dataDict["rating"] = rating
            dataDict["title"] = title
            dataDict["year"] = year
        case .stars(let title):
            dataDict["type"] = "stars"
            dataDict["title"] = title
        case .thropy(let title, let year):
            dataDict["type"] = "thropy"
            dataDict["title"] = title
            dataDict["year"] = year
        }
        
        trustBadgeDict["data"] = dataDict
        
        return trustBadgeDict
    }
}


/*
 
 
 Example JSON
 
 {
 //For laurelWreath
       "data": {
         "type": "laurelWreath",
         "rating": 4.5,
         "title": "Top Rated",
         "year": 2023
       },
       "index": 15,
       "type": "trustbadge"
     }
 
 // For stars
 {
       "data": {
         "type": "stars",
         "title": "Top Rated"
       },
       "index": 15,
       "type": "trustbadge"
     }
 
 //For trophy
 {
       "data": {
         "type": "thropy",
         "title": "Top Rated",
         "year": 2023
       },
       "index": 15,
       "type": "trustbadge"
     }
 
 */
