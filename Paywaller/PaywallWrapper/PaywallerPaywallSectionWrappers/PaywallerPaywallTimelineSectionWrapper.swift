//
//  PaywallerPaywallTimelineSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 5.12.2023.
//

import Foundation
import UIKit
import NeonSDK
import SDWebImage

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createTimelineSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let hasContainer = dict["hasContainer"] as? Bool,
           let itemsData = dict["items"] as? [[String: Any]] {
            
            let horizontalPadding = dict["horizontalPadding"] as? CGFloat ?? 0
            
            var items: [PaywallerPaywallTimelineItem] = []
            for itemData in itemsData {
                if let title = itemData["title"] as? String,
                   let subtitle = itemData["subtitle"] as? String,
                   let description = itemData["description"] as? String,
                   let iconURL = itemData["iconURL"] as? String{
                    
                    if let url = URL(string: iconURL){
                        SDWebImagePrefetcher.shared.prefetchURLs([url])
                    }
                    
                    items.append(PaywallerPaywallTimelineItem(iconURL: iconURL, title: title, subtitle: subtitle, description: description))
                }
            }
            
            return .timeline(hasContainer: hasContainer, items: items, horizontalPadding : horizontalPadding)
        }
        return nil
    }
}
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createTimelineJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .timeline(hasContainer, items, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .timeline
        }
        
        var timelineDict: [String: Any] = [
            "index": index,
            "type": "timeline"
        ]
        
        var dataDict: [String: Any] = [
            "hasContainer": hasContainer,
            "horizontalPadding" : horizontalPadding
        ]
        
        var itemsArray: [[String: Any]] = []
        for item in items {
            var itemDict: [String: Any] = [
                "iconURL": item.iconURL ?? "",
                "title": item.title,
                "subtitle": item.subtitle,
                "description": item.description
            ]
            itemsArray.append(itemDict)
        }
        
        dataDict["items"] = itemsArray
        
        timelineDict["data"] = dataDict
        
        return timelineDict
    }
}


/*
 
 Example JSON
 
 {
     "type": "timeline",
     "index": 1,
     "data": {
         "hasContainer": true,
         "items": [
             {
                 "iconURL": "https://picsum.photos/50",
                 "title": "Step 1",
                 "subtitle": "Start",
                 "description": "Begin the journey."
             },
             {
                 "iconURL": "https://picsum.photos/50",
                 "title": "Step 2",
                 "subtitle": "Progress",
                 "description": "Keep moving forward."
             },
             {
                 "iconURL": "https://picsum.photos/50",
                 "title": "Step 3",
                 "subtitle": "Finish",
                 "description": "Reach the destination."
             }
         ]
     }
 }

 
 
 
 */
