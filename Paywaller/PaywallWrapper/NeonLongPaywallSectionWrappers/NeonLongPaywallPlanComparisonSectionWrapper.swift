//
//  NeonLongPaywallPlanComparisonSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation

import UIKit

extension NeonLongPaywallJSONWrapper {
    static func createPlanComparisonSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
        if let itemsData = dict["items"] as? [[String: Any]] {
            var items: [NeonLongPaywallPlanComparisonItem] = []
            for itemData in itemsData {
                if let feature = itemData["feature"] as? String,
                   let availabilityRaw = itemData["availability"] as? String,
                   let availability = availabilityFromString(availabilityRaw) {
                    
                    let planComparisonItem = NeonLongPaywallPlanComparisonItem(feature: feature, availability: availability)
                    items.append(planComparisonItem)
                }
            }
            return .planComparison(items: items)
        }
        return nil
    }
    
    static func availabilityFromString(_ availabilityString: String) -> NeonLongPaywallPlanComparisonItem.Availability? {
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


extension NeonLongPaywallJSONWrapper {
    static func createPlanComparisonJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .planComparison(items) = section else {
            return nil // Return nil if the input section is not of type .planComparison
        }
        
        var planComparisonDict: [String: Any] = [
            "index": index,
            "type": "planComparison",
            "data": [
                "items": []
            ]
        ]
        
        for item in items {
            let itemDict: [String: Any] = [
                "feature": item.feature,
                "availability": availabilityToString(item.availability)
            ]
            if var dataDict = planComparisonDict["data"] as? [String: Any] {
                dataDict["items"] = (dataDict["items"] as? [[String: Any]] ?? []) + [itemDict]
                planComparisonDict["data"] = dataDict
            }
        }
        
        return planComparisonDict
    }
    
    static func availabilityToString(_ availability: NeonLongPaywallPlanComparisonItem.Availability) -> String {
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
