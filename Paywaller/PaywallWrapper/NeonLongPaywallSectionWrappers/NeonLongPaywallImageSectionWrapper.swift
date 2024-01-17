//
//  NeonLongPaywallImageSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 4.12.2023.
//

import Foundation
import UIKit


extension NeonLongPaywallJSONWrapper {
    static func createImageSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
        if let height = dict["height"] as? CGFloat,
           let url = dict["url"] as? String,
           let cornerRadius = dict["cornerRadious"] as? CGFloat,
           let horizontalPadding = dict["horizontalPadding"] as? CGFloat,
           let contentModeRaw = dict["contentMode"] as? String,
           let contentMode = contentModeFromString(contentModeRaw) {
            return .imageWithURL(height: height, url: url, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
        }
        return nil
    }

    static func contentModeFromString(_ contentModeString: String) -> UIView.ContentMode? {
        switch contentModeString {
        case "scaleToFill":
            return .scaleToFill
        case "scaleAspectFit":
            return .scaleAspectFit
        case "scaleAspectFill":
            return .scaleAspectFill
        case "center":
            return .center
        case "top":
            return .top
        case "bottom":
            return .bottom
        case "left":
            return .left
        case "right":
            return .right
        case "topLeft":
            return .topLeft
        case "topRight":
            return .topRight
        case "bottomLeft":
            return .bottomLeft
        case "bottomRight":
            return .bottomRight
        default:
            return nil
        }
    }
}

extension NeonLongPaywallJSONWrapper {
    static func createImageJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .imageWithURL(height, url, cornerRadius, horizontalPadding, contentMode) = section else {
            return nil 
        }
        
        let contentModeString = contentModeStringFromEnum(contentMode)
        
        let imageDict: [String: Any] = [
            "index": index,
            "type": "image",
            "data": [
                "height": height,
                "url": url,
                "cornerRadious": cornerRadius,
                "horizontalPadding": horizontalPadding,
                "contentMode": contentModeString
            ]
        ]
        
        return imageDict
    }

    static func contentModeStringFromEnum(_ contentMode: UIView.ContentMode) -> String {
        switch contentMode {
        case .scaleToFill:
            return "scaleToFill"
        case .scaleAspectFit:
            return "scaleAspectFit"
        case .scaleAspectFill:
            return "scaleAspectFill"
        case .redraw:
            return "redraw"
        case .center:
            return "center"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .left:
            return "left"
        case .right:
            return "right"
        case .topLeft:
            return "topLeft"
        case .topRight:
            return "topRight"
        case .bottomLeft:
            return "bottomLeft"
        case .bottomRight:
            return "bottomRight"
        default:
            return ""
        }
    }
}


/*
 
 
 Example JSON
 
 {
     "data": {
         "height": 200,
         "url": "your_image_url_here",
         "cornerRadius": 20,
         "horizontalPadding": 0,
         "contentMode": "scaleAspectFill"
     },
     "index": 3,
     "type": "image"
 }
 
 Options
 
 "contentMode" - "scaleToFill", "scaleAspectFit", "scaleAspectFill", "redraw", "center", "top", "bottom", "left", "right", "topLeft", "topRight", "bottomLeft", "bottomRight"
 
 */


