//
//  PaywallerPaywallConfigurationWrapper.swift
//  Paywall Builder
//
//  Created by Tuna Öztürk on 13.01.2024.
//

import Foundation
import NeonSDK

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createConfigurationJSON(from constants: PaywallerPaywallConstants) -> [String: Any]? {
        var configuration: [String: Any] = [:]

        // Populate the configuration dictionary with values from the constants object
        configuration["privacyURL"] = constants.privacyURL
        configuration["termsURL"] = constants.termsURL
        configuration["isPaymentSheetActive"] = constants.isPaymentSheetActive 
        configuration["closeButtonDelay"] = constants.closeButtonDelay
        configuration["horizontalPadding"] = constants.horizontalPadding
        configuration["ctaButtonHorizontalPadding"] = constants.ctaButtonHorizontalPadding
        configuration["cornerRadius"] = constants.cornerRadius
        configuration["containerBorderWidth"] = constants.containerBorderWidth

        // Convert UIColor properties to hex strings
        configuration["mainColor"] = constants.mainColor.toHex()
        configuration["backgroundColor"] = constants.backgroundColor.toHex()
        configuration["primaryTextColor"] = constants.primaryTextColor.toHex()
        configuration["secondaryTextColor"] = constants.secondaryTextColor.toHex()
        configuration["containerColor"] = constants.containerColor.toHex()
        configuration["selectedContainerColor"] = constants.selectedContainerColor.toHex()
        configuration["containerBorderColor"] = constants.containerBorderColor.toHex()
        configuration["selectedContainerBorderColor"] = constants.selectedContainerBorderColor.toHex()
        configuration["ctaButtonTextColor"] = constants.ctaButtonTextColor.toHex()

        return configuration
    }
}
