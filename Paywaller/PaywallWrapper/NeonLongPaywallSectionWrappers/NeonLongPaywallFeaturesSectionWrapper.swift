//
//  NeonLongPaywallFeaturesSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 4.12.2023.
//

import Foundation

import UIKit

@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createFeaturesSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
           if let itemsDict = dict["items"] as? [[String: Any]],
           let items = createFeaturesItems(fromDicts: itemsDict) {
            
            let font = createFont(fromDict: dict)
            let overrideTextColor = createTextColor(fromDict: dict)
            let offset = dict["offset"] as? CGFloat
            
               return .features(items: items, overrideTextColor: overrideTextColor, font: font, iconTintColor: .red, offset: offset)
        }
        return nil
    }

    static func createFeaturesItems(fromDicts dicts: [[String: Any]]) -> [NeonPaywallFeature]? {
        var items: [NeonPaywallFeature] = []
        
        for itemDict in dicts {
            if let text = itemDict["text"] as? String,
               let iconURL = itemDict["iconURL"] as? String{
                let item = NeonPaywallFeature(title: text, iconURL: iconURL)
                items.append(item)
            }
        }
            return items.isEmpty ? nil : items
       
    }
    static func createFont(fromDict dict: [String: Any]) -> UIFont? {
        if let fontDict = dict["font"] as? [String: Any],
           let fontSize = fontDict["size"] as? CGFloat,
           let fontWeightRaw = fontDict["fontWeight"] as? String,
           let fontWeight = fontWeight(from: fontWeightRaw) {
            return Font.custom(size: fontSize, fontWeight: fontWeight)
        }
        return nil
    }

    static func createTextColor(fromDict dict: [String: Any]) -> UIColor? {
        if let hexColor = dict["textColor"] as? String,
           let textColor = UIColor.fromHex(hexColor) {
            return textColor
        }
        return nil
    }


}
@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createFeaturesJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .features(items, overrideTextColor, font, _, offset) = section else {
            return nil // Return nil if the input section is not of type .features
        }
        
        var featuresDict: [String: Any] = [
            "index": index,
            "type": "features"
        ]
        
        var dataDict: [String: Any] = [:]
        
        if let font = font {
            dataDict["font"] = [
                "size": font.pointSize,
                "fontWeight": fontWeightToString(font)
            ]
        }
        
        dataDict["offset"] = offset ?? 0
        
        if let textColor = overrideTextColor {
            dataDict["textColor"] = textColor.toHex()
        }
        

            var itemsArray: [[String: Any]] = []
            for item in items {
                var itemDict: [String: Any] = [
                    "text": item.title,
                    "iconURL": item.iconURL ?? ""
                ]
                itemsArray.append(itemDict)
            }
            dataDict["items"] = itemsArray
        
        
        featuresDict["data"] = dataDict
        
        return featuresDict
    }
}

/*
 
 
 Example JSON
 
 {
      "data": {
        "font": {
          "fontWeight": "Regular",
          "size": 16
        },
        "items": [
          {
            "iconURL": "https://firebasestorage.googleapis.com/v0/b/ai-yearbook-ecb86.appspot.com/o/btn_inappSelected%403x.png?alt=media&token=936f3476-87be-4dd7-9e21-59556935b9b4",
            "text": "Feature 1"
          },
          {
            "iconURL": "https://firebasestorage.googleapis.com/v0/b/ai-yearbook-ecb86.appspot.com/o/btn_inappSelected%403x.png?alt=media&token=936f3476-87be-4dd7-9e21-59556935b9b4",
            "text": "Feature 2"
          }
        ],
        "offset": 10,
        "textColor": "FF0000"
      },
      "index": 4,
      "type": "features"
    }
 
 Options
 
 "fontWeight" - "light", "regular", "medium", "semibold", "bold", "black"
 
 */
