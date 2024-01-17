//
//  LabelSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 4.12.2023.
//

import Foundation

import UIKit

@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {

    
    static func createLabelSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
           if let text = dict["text"] as? String,
              let fontDict = dict["font"] as? [String: Any],
              let fontSize = fontDict["size"] as? CGFloat,
              let fontWeightRaw = fontDict["fontWeight"] as? String,
              let fontWeight = fontWeight(from: fontWeightRaw),
              let alignmentRaw = dict["alignment"] as? String,
              let alignment = textAlignmentFromString(alignmentRaw),
              let horizontalPadding = dict["horizontalPadding"] as? CGFloat,
              let hexColor = dict["textColor"] as? String,
              let textColor = UIColor.fromHex(hexColor){
               let font = Font.custom(size: fontSize, fontWeight: fontWeight)
               return .label(text: text, font: font, overrideTextColor: textColor, alignment: alignment, horizontalPadding: horizontalPadding)
           }
           return nil
       }
       
       static func textAlignmentFromString(_ alignmentString: String) -> NSTextAlignment? {
           switch alignmentString {
           case "left":
               return .left
           case "center":
               return .center
           case "right":
               return .right
           default:
               return nil
           }
       }
    
    static func fontWeight(from string: String) -> FontManager.FontWeight? {
            switch string.lowercased() {
            case "light":
                return .Light
            case "regular":
                return .Regular
            case "medium":
                return .Medium
            case "semibold":
                return .SemiBold
            case "bold":
                return .Bold
            case "black":
                return .Black
            default:
                return nil
            }
        }
    
    
    
    
    
   }
    
extension NeonLongPaywallJSONWrapper {
    static func createLabelJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .label(text, font, overrideTextColor, alignment, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .label
        }
        
        var labelDict: [String: Any] = [
            "index": index,
            "type": "label"
        ]
        
        var dataDict: [String: Any] = [
            "alignment": textAlignmentToString(alignment),
            "font": [
                "size": font.pointSize,
                "fontWeight": fontWeightToString(font)
            ],
            "horizontalPadding": horizontalPadding,
            "text": text,
            "textColor": overrideTextColor?.toHex() ?? ""
        ]
        
        
        labelDict["data"] = dataDict
        
        return labelDict
    }
    
    static func textAlignmentToString(_ alignment: NSTextAlignment) -> String {
        switch alignment {
        case .left:
            return "left"
        case .center:
            return "center"
        case .right:
            return "right"
        default:
            return ""
        }
    }
    
    static func fontWeightToString(_ font: UIFont) -> String {
        let fontName = font.fontName.lowercased()
        if fontName.contains("light") {
            return "light"
        } else if fontName.contains("medium") {
            return "medium"
        } else if fontName.contains("semibold") {
            return "semibold"
        } else if fontName.contains("bold") {
            return "bold"
        } else if fontName.contains("black") {
            return "black"
        } else {
            return "regular" // Default to regular if no matching weight is found
        }
    }
    
}


/*
 
 
 Example JSON
 
 {
       "data": {
         "alignment": "center",
         "font": {
           "fontWeight": "bold",
           "size": 30
         },
         "horizontalPadding": 0,
         "text": "Unlock All Premium Features",
         "textColor": "FFFFFF"
       },
       "index": 2,
       "type": "label"
     }
 
 Options
 
 "alignment" - "center", "left", "right"
 "fontWeight" - "light", "regular", "medium", "semibold", "bold", "black"
 
 */

