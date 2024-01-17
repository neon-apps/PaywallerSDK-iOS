//
//  NeonLongPaywallPlansSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation

import UIKit

@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createPlansSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
        if let typeRaw = dict["type"] as? String,
           let type = planViewTypeFromString(typeRaw),
           let itemsData = dict["items"] as? [[String: Any]] {
            
            var plans: [NeonLongPaywallPlan] = []
            for itemData in itemsData {
                if let productIdentifier = itemData["productIdentifier"] as? String,
                   let tag = itemData["tag"] as? String,
                   let priceTypeRaw = itemData["priceType"] as? String,
                   let priceType = priceTypeFromString(priceTypeRaw),
                   let isDefaultSelected = itemData["isDefaultSelected"] as? Bool {
                    
                    let plan = NeonLongPaywallPlan(productIdentifier: productIdentifier, tag: tag == "" ? nil : tag, priceType: priceType, isDefaultSelected: isDefaultSelected)
                    plans.append(plan)
                }
            }
            
            return .plans(type: type, items: plans)
        }
        return nil
    }
    
    static func planViewTypeFromString(_ typeString: String) -> NeonLongPaywallPlanViewType? {
        switch typeString {
        case "horizontal":
            return .horizontal
        case "vertical":
            return .vertical
        default:
            return nil
        }
    }
    
    static func priceTypeFromString(_ priceTypeString: String) -> NeonLongPaywallPlan.PriceType? {
        switch priceTypeString {
        case "default":
            return .default
        case "perWeek":
            return .perWeek
        case "perMonth":
            return .perMonth
        default:
            return nil
        }
    }
}

@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createPlansJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .plans(type, items) = section else {
            return nil // Return nil if the input section is not of type .plans
        }
        
        var plansDict: [String: Any] = [
            "index": index,
            "type": "plans"
        ]
        
        var dataDict: [String: Any] = [:]
        var itemsArray: [[String: Any]] = []
        
        dataDict["type"] = planViewTypeToString(type)
        
        for item in items {
            var itemDict: [String: Any] = [
                "isDefaultSelected": item.isDefaultSelected,
                "priceType": priceTypeToString(item.priceType),
                "productIdentifier": item.productIdentifier,
                "tag": item.tag ?? ""
            ]
            itemsArray.append(itemDict)
        }
        
        dataDict["items"] = itemsArray
        plansDict["data"] = dataDict
        
        return plansDict
    }
    
    static func planViewTypeToString(_ type: NeonLongPaywallPlanViewType) -> String {
        switch type {
        case .horizontal:
            return "horizontal"
        case .vertical:
            return "vertical"
        }
    }
    
    static func priceTypeToString(_ priceType: NeonLongPaywallPlan.PriceType) -> String {
        switch priceType {
        case .default:
            return "default"
        case .perWeek:
            return "perWeek"
        case .perMonth:
            return "perMonth"
        }
    }
}


/*
 
 
 Example JSON
 
 {
   "data": {
     "items": [
       {
         "isDefaultSelected": true,
         "priceType": "default",
         "productIdentifier": "unlock.faceyoga.annual.3daystrial",
         "tag": ""
       },
       {
         "isDefaultSelected": false,
         "priceType": "default",
         "productIdentifier": "unlock.faceyoga.monthly",
         "tag": ""
       }
     ],
     "type": "vertical"
   },
   "index": 13,
   "type": "plans"
 }
 
 
 */
