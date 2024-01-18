//
//  PaywallerPaywallConfigurationWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 6.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    static func createConstants(from dict: [String: Any]) -> PaywallerPaywallConstants {
        let constants = PaywallerPaywallConstants()

        if let configuration = dict["configuration"] as? [String: Any] {
            
            if let isPaymentSheetActive = configuration["isPaymentSheetActive"] as? Bool {
                constants.isPaymentSheetActive = isPaymentSheetActive
            }
            
            if let horizontalPadding = configuration["horizontalPadding"] as? CGFloat {
                constants.horizontalPadding = horizontalPadding
            }
            
            if let cornerRadius = configuration["cornerRadius"] as? CGFloat {
                constants.cornerRadius = cornerRadius
            }
            
            if let containerBorderWidth = configuration["containerBorderWidth"] as? CGFloat {
                constants.containerBorderWidth = containerBorderWidth
            }
            
            if let mainColorHex = configuration["mainColor"] as? String,
               let mainColor = UIColor.fromHex(mainColorHex) {
                constants.mainColor = mainColor
            }
            
            if let backgroundColorHex = configuration["backgroundColor"] as? String,
               let backgroundColor = UIColor.fromHex(backgroundColorHex) {
                constants.backgroundColor = backgroundColor
            }
            
            if let primaryTextColorHex = configuration["primaryTextColor"] as? String,
               let primaryTextColor = UIColor.fromHex(primaryTextColorHex) {
                constants.primaryTextColor = primaryTextColor
            }
            
            if let secondaryTextColorHex = configuration["secondaryTextColor"] as? String,
               let secondaryTextColor = UIColor.fromHex(secondaryTextColorHex) {
                constants.secondaryTextColor = secondaryTextColor
            }
            
            if let containerColorHex = configuration["containerColor"] as? String,
               let containerColor = UIColor.fromHex(containerColorHex) {
                constants.containerColor = containerColor
            }
            
            if let selectedContainerColorHex = configuration["selectedContainerColor"] as? String,
               let selectedContainerColor = UIColor.fromHex(selectedContainerColorHex) {
                constants.selectedContainerColor = selectedContainerColor
            }
            
            if let containerBorderColorHex = configuration["containerBorderColor"] as? String,
               let containerBorderColor = UIColor.fromHex(containerBorderColorHex) {
                constants.containerBorderColor = containerBorderColor
            }
            
            if let selectedContainerBorderColorHex = configuration["selectedContainerBorderColor"] as? String,
               let selectedContainerBorderColor = UIColor.fromHex(selectedContainerBorderColorHex) {
                constants.selectedContainerBorderColor = selectedContainerBorderColor
            }
            
            if let ctaButtonTextColorHex = configuration["ctaButtonTextColor"] as? String,
               let ctaButtonTextColor = UIColor.fromHex(ctaButtonTextColorHex) {
                constants.ctaButtonTextColor = ctaButtonTextColor
            }
        }
        return constants
    }
}
