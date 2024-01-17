//
//  NeonLongPaywallWhatYouWillGetWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation

import UIKit

extension NeonLongPaywallJSONWrapper {
    static func createWhatYouWillGetSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
        if let title = dict["title"] as? String,
           let hasContainer = dict["hasContainer"] as? Bool,
           let itemsData = dict["items"] as? [[String: Any]] {
            
            var items: [NeonLongPaywallWhatYouWillGetItem] = []
            for itemData in itemsData {
                if let emoji = itemData["emoji"] as? String,
                   let itemTitle = itemData["title"] as? String,
                   let subtitle = itemData["subtitle"] as? String {
                    
                    let whatYouWillGetItem = NeonLongPaywallWhatYouWillGetItem(emoji: emoji, title: itemTitle, subtitle: subtitle)
                    items.append(whatYouWillGetItem)
                }
            }
            
            return .whatYouWillGet(title: title, hasContainer: hasContainer, items: items)
        }
        return nil
    }
}

extension NeonLongPaywallJSONWrapper {
    static func createWhatYouWillGetJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .whatYouWillGet(title, hasContainer, items) = section else {
            return nil // Return nil if the input section is not of type .whatYouWillGet
        }
        
        var whatYouWillGetDict: [String: Any] = [
            "index": index,
            "type": "whatYouWillGet",
            "data": [
                "title": title,
                "hasContainer": hasContainer,
                "items": []
            ]
        ]
        
        for item in items {
            let itemDict: [String: Any] = [
                "emoji": item.emoji,
                "title": item.title,
                "subtitle": item.subtitle
            ]
            if var dataDict = whatYouWillGetDict["data"] as? [String: Any] {
                dataDict["items"] = (dataDict["items"] as? [[String: Any]] ?? []) + [itemDict]
                whatYouWillGetDict["data"] = dataDict
            }
        }
        
        return whatYouWillGetDict
    }
}


/*
 
 
 Example JSON
 
 {
     "data": {
         "title": "What You Will Get",
         "hasContainer": true,
         "items": [
             {
                 "emoji": "🚀",
                 "title": "Access to Premium Features",
                 "subtitle": "Unlock advanced features and functionalities."
             },
             {
                 "emoji": "🌟",
                 "title": "Exclusive Content",
                 "subtitle": "Enjoy content available only to premium users."
             },
             {
                 "emoji": "💼",
                 "title": "Ad-Free Experience",
                 "subtitle": "Browse without interruptions from ads."
             }
         ]
     },
     "index": 3,
     "type": "whatYouWillGet"
 }

 
 */
