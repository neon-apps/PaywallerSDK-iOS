//
//  PaywallerPaywallPlanComparisonSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createPlanComparisonSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let itemsData = dict["items"] as? [[String: Any]] {
            var items: [PaywallerPaywallPlanComparisonItem] = []
            for itemData in itemsData {
                if let feature = itemData["feature"] as? String,
                   let availabilityRaw = itemData["availability"] as? String,
                   let availability = availabilityFromString(availabilityRaw) {
                    
                    let planComparisonItem = PaywallerPaywallPlanComparisonItem(feature: feature, availability: availability)
                    items.append(planComparisonItem)
                }
            }
            
            let horizontalPadding = dict["horizontalPadding"] as? CGFloat ?? 0
            return .planComparison(items: items, horizontalPadding: horizontalPadding)
        }
        return nil
    }
    
    public static func availabilityFromString(_ availabilityString: String) -> PaywallerPaywallPlanComparisonItem.Availability? {
        switch availabilityString {
        case "locked":
            return .locked
        case "available":
            return .available
        case "limited":
            return .limited
        default:
            return nil
        }
    }
}

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createPlanComparisonJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .planComparison(items, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .planComparison
        }
        
        var planComparisonDict: [String: Any] = [
            "index": index,
            "type": "planComparison",
            "data": [
                "items": [],
                "horizontalPadding" : horizontalPadding
            ]
        ]
        
        for item in items {
            let itemDict: [String: Any] = [
                "feature": item.feature,
                "availability": availabilityToString(item.availability)
            ]
            if var dataDict = planComparisonDict["data"] as? [String: Any] {
                dataDict["items"] = (dataDict["items"] as? [[String: Any]] ?? []) + [itemDict]
                dataDict["horizontalPadding" : horizontalPadding]
                planComparisonDict["data"] = dataDict
                
            }
        }
        
        return planComparisonDict
    }
    
    public static func availabilityToString(_ availability: PaywallerPaywallPlanComparisonItem.Availability) -> String {
        switch availability {
        case .locked:
            return "locked"
        case .available:
            return "available"
        case .limited:
            return "limited"
        }
    }
}


/*
 
 
 Example JSON
 
 {
     "type": "planComparison",
     "data": {
         "items": [
             {
                 "feature": "Feature 1",
                 "availability": "locked"
             },
             {
                 "feature": "Feature 2",
                 "availability": "available"
             },
             {
                 "feature": "Feature 3",
                 "availability": "limited"
             }
         ]
     },
     "index": 3
 }
 
 Options
 
 "availability" - "locked", "available", "limited"
 
 
 */
