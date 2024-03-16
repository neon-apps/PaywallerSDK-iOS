//
//  PaywallerPaywallSlideSectionWrapper.swift
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
    public static func createSlideSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let height = dict["height"] as? CGFloat,
           let showBeforeAfterBadges = dict["showBeforeAfterBadges"] as? Bool,
           let itemsData = dict["items"] as? [[String: Any]] {
            
            let horizontalPadding = dict["horizontalPadding"] as? CGFloat ?? 0
            
            var items: [NeonSlideItem] = []
            for itemData in itemsData {
                if let firstImageURL = itemData["firstImageURL"] as? String,
                   let secondImageURL = itemData["secondImageURL"] as? String,
                   let title = itemData["title"] as? String,
                   let subtitle = itemData["subtitle"] as? String {
                    
                    if let firstImage = URL(string: firstImageURL), let secondImage = URL(string: secondImageURL){
                        SDWebImagePrefetcher.shared.prefetchURLs([firstImage, secondImage])
                    }
                    
                    let slideItem = NeonSlideItem(firstImageURL: firstImageURL, secondImageURL: secondImageURL, title: title, subtitle: subtitle)
                    items.append(slideItem)
                }
            }
            
            return .slide(height: height, showBeforeAfterBadges: showBeforeAfterBadges, items: items, horizontalPadding: horizontalPadding)
        }
        return nil
    }
}
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createSlideJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .slide(height, showBeforeAfterBadges, items, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .slide
        }
        
        var slideDict: [String: Any] = [
            "index": index,
            "type": "slide"
        ]
        
        var dataDict: [String: Any] = [
            "height": height,
            "showBeforeAfterBadges": showBeforeAfterBadges,
            "horizontalPadding" : horizontalPadding
        ]
        
        var itemsArray: [[String: Any]] = []
        
        for item in items {
            var itemDict: [String: Any] = [
                "firstImageURL": item.firstImageURL,
                "secondImageURL": item.secondImageURL,
                "title": item.title,
                "subtitle": item.subtitle
            ]
            itemsArray.append(itemDict)
        }
        
        dataDict["items"] = itemsArray
        slideDict["data"] = dataDict
        
        return slideDict
    }
}



// Example JSON

/*
 
 {
     "type": "slide",
     "data": {
         "height": 400,
         "showBeforeAfterBadges": true,
         "items": [
             {
                 "firstImageURL": "https://picsum.photos/200/400",
                 "secondImageURL": "https://picsum.photos/200/400",
                 "title": "Empower Your Life",
                 "subtitle": "transform your future and achieve success with our powerful features and tools"
             },
             {
                 "firstImageURL": "https://picsum.photos/200/400",
                 "secondImageURL": "https://picsum.photos/200/400",
                 "title": "Achieve Your Dreams",
                 "subtitle": "unleash your potential and unlock new opportunities for personal growth and development"
             }
         ]
     },
     "index": 4
 }

 
 */
