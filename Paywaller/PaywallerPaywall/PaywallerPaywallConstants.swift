//
//  manager.constants.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
public class PaywallerPaywallConstants{
    public var termsURL : String?
    public var privacyURL : String?
    public var provider = PaywallerPaywallProviderConfiguration.revenuecat
    public var isPaymentSheetActive = Bool()
    public var horizontalPadding = CGFloat() 
    public var ctaButtonHorizontalPadding = CGFloat()
    public var cornerRadius = CGFloat()
    public var containerBorderWidth = CGFloat()
    // Colors
    
    public var primaryTextColor = UIColor()
    public var secondaryTextColor = UIColor()
    public var selectedContainerColor = UIColor()
    public var containerColor = UIColor()
    public var selectedContainerBorderColor = UIColor()
    public var containerBorderColor = UIColor()
    public var mainColor = UIColor()
    public var backgroundColor = UIColor()
    public var ctaButtonTextColor = UIColor()
    
    // Variables
    
    public var selectedPlan = PaywallerPaywallPlan(){
        didSet{
            NeonNotificationCenter.post(id: "plan_selected", object: selectedPlan)
        }
    }
    public var allPlans = [PaywallerPaywallPlan]()
    
    public init(){
        
    }
    
    public func copy() -> PaywallerPaywallConstants {
            let copiedConstants = PaywallerPaywallConstants()

        
            copiedConstants.termsURL = self.termsURL
            copiedConstants.privacyURL = self.privacyURL
            copiedConstants.provider = self.provider
            copiedConstants.isPaymentSheetActive = self.isPaymentSheetActive
            copiedConstants.horizontalPadding = self.horizontalPadding
            copiedConstants.ctaButtonHorizontalPadding = self.ctaButtonHorizontalPadding
            copiedConstants.cornerRadius = self.cornerRadius
            copiedConstants.containerBorderWidth = self.containerBorderWidth
            copiedConstants.primaryTextColor = self.primaryTextColor
            copiedConstants.secondaryTextColor = self.secondaryTextColor
            copiedConstants.selectedContainerColor = self.selectedContainerColor
            copiedConstants.containerColor = self.containerColor
            copiedConstants.selectedContainerBorderColor = self.selectedContainerBorderColor
            copiedConstants.containerBorderColor = self.containerBorderColor
            copiedConstants.mainColor = self.mainColor
            copiedConstants.backgroundColor = self.backgroundColor
            copiedConstants.ctaButtonTextColor = self.ctaButtonTextColor
            copiedConstants.selectedPlan = self.selectedPlan.copy()
            copiedConstants.allPlans = self.allPlans.map { $0.copy() }

            return copiedConstants
        }
}
