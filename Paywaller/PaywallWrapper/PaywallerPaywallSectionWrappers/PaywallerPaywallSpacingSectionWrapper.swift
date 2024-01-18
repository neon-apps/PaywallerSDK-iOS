//
//  PaywallerPaywallSpacingSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 4.12.2023.
//

import Foundation
import NeonSDK

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createSpacingSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let height = dict["height"] as? CGFloat {
            return .spacing(height: height)
        }
        return nil
    }
    
    public static func createSpacingJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
           guard case let .spacing(height) = section else {
               return nil // Return nil if the input section is not of type .spacing
           }
           
           let spacingDict: [String: Any] = [
               "index": index,
               "type": "spacing",
               "data": [
                   "height": height
               ]
           ]
           
           return spacingDict
       }
}

/*
 
 Example JSON
 
 {
       "data": {
         "height": 100
       },
       "index": 1,
       "type": "spacing"
     }
 
 */
