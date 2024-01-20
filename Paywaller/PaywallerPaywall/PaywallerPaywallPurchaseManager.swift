//
//  PaywallerPaywallPurchaseManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class PaywallerPaywallPurchaseManager{
    
    static func subscribe(paywallManager : PaywallerPaywallManager, completionSuccess : @escaping () -> ()){
        let plan = paywallManager.constants.selectedPlan
        
        if let adaptyPackage = AdaptyManager.getPackage(id: plan.productIdentifier){
            
            let product = adaptyPackage.skProduct
            
            AdaptyManager.selectPackage(id: product.productIdentifier)
            
            AdaptyManager.purchase(animation: .loadingCircle, animationColor: paywallManager.constants.mainColor) {
                completionSuccess()
                } completionFailure: {
                    
                }
           

        }else if let revenueCatPackage = RevenueCatManager.getPackage(id: plan.productIdentifier), let product = revenueCatPackage.storeProduct.sk1Product{
       
            RevenueCatManager.selectPackage(id: product.productIdentifier)
            
            RevenueCatManager.purchase(animation: .loadingCircle, animationColor: paywallManager.constants.mainColor) {
                completionSuccess()
                } completionFailure: {
                    
                }
            
        }else{
  
        }
    }
    
    static func restore(paywallManager : PaywallerPaywallManager, controller : UIViewController, completionSuccess : @escaping () -> (), completionFailure : @escaping () -> ()){
        
        let provider = paywallManager.constants.provider
        switch provider {
        case .adapty:
            AdaptyManager.restorePurchases(
                vc: controller,
                animation: .loadingCircle, animationColor: paywallManager.constants.mainColor) {
                    completionSuccess()
                } completionFailure: {
                    completionFailure()
                }
        case .revenuecat:
            RevenueCatManager.restorePurchases(
                vc: controller,
                animation: .loadingCircle, animationColor: paywallManager.constants.mainColor) {
                    completionSuccess()
                } completionFailure: {
                    completionFailure()
                }

        case .none:
            break
        }
    }
}
