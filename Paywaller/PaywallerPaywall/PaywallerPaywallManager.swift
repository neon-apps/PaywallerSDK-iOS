//
//  PaywallerPaywallManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit


public protocol PaywallerDelegate {
    func purchased(from controller : UIViewController, identifier : String)
    func restored(from controller : UIViewController)
    func dismissed(from controller : UIViewController)
    
}
@available(iOS 15.0, *)
public class PaywallerPaywallManager{
    
    public var sections = [PaywallerPaywallSection]()
    public var delegate : PaywallerDelegate?
    public var constants = PaywallerPaywallConstants()
    
    public init(){
        
    }
    public func configure(
        provider : PaywallerPaywallProviderConfiguration,
        isPaymentSheetActive : Bool,
        horizontalPadding: CGFloat,
        cornerRadius: CGFloat,
        containerBorderWidth : CGFloat,
        mainColor: UIColor,
        backgroundColor: UIColor,
        primaryTextColor: UIColor,
        secondaryTextColor: UIColor,
        containerColor: UIColor,
        selectedContainerColor: UIColor,
        containerBorderColor: UIColor,
        selectedContainerBorderColor: UIColor,
        ctaButtonTextColor: UIColor,
        termsURL : String? = nil,
        privacyURL : String? = nil
        
    ) {
        constants.provider = provider
        constants.isPaymentSheetActive = isPaymentSheetActive
        constants.horizontalPadding = horizontalPadding
        constants.cornerRadius = cornerRadius
        constants.containerBorderWidth = containerBorderWidth
        constants.primaryTextColor = primaryTextColor
        constants.secondaryTextColor = secondaryTextColor
        constants.containerColor = containerColor
        constants.selectedContainerColor = selectedContainerColor
        constants.containerBorderColor = containerBorderColor
        constants.selectedContainerBorderColor = selectedContainerBorderColor
        constants.mainColor = mainColor
        constants.backgroundColor = backgroundColor
        constants.ctaButtonTextColor = ctaButtonTextColor
        constants.termsURL = termsURL
        constants.privacyURL = privacyURL
    }
    
    public func present(from controller : UIViewController){
        let paywall = PaywallerPaywallController()
        paywall.paywallManager = self
        controller.present(destinationVC: paywall, slideDirection: .up)
        
    }
    
    
    public func addSection(type : PaywallerPaywallSectionType){
        sections.append(PaywallerPaywallSection(type: type, manager: self))
        
    }
    
    public func copy() -> PaywallerPaywallManager {
        let copiedManager = PaywallerPaywallManager()
        copiedManager.delegate = self.delegate
        copiedManager.constants = self.constants.copy()
        for section in self.sections {
            copiedManager.sections.append(section.copy(with: copiedManager))
        }
        
        return copiedManager
    }
    
}
