//
//  Paywaller.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
public class Paywaller{
    
    public static func configure(apiKey : String, provider : PaywallerAppProviderConfiguration){
        configureProvider(provider: provider)
        Font.configureFonts(font: .SFProDisplay)
        Constants.apiKey = apiKey
    }
    
    public static func presentPaywall(with provider : PaywallerAppProviderConfiguration, from controller : UIViewController){
        switch provider {
        case .adapty(let selectedPlacementID):
            for paywall in Constants.paywalls{
                switch paywall.provider {
                case .adapty(let paywallPlacementID):
                    if selectedPlacementID == paywallPlacementID{
                        paywall.manager.delegate = controller as? any PaywallerDelegate
                        paywall.manager.present(from: controller)
                    }
                    break
                case .revenuecat:
                    break
                case .none:
                    break
                }
            }
        case .revenuecat:
            break
        case .none:
            break
        }
    }
    
    internal static func configureProvider(provider : PaywallerAppProviderConfiguration){
        switch provider {
        case .adapty(let apiKey, let placementIDs, let accessLevel):
            AdaptyManager.configure(withAPIKey: apiKey, placementIDs: placementIDs, accessLevel: accessLevel) {
                fetchPaywalls(for: placementIDs, provider: provider)
            }
            break
        case .revenuecat:
            break
        case .none:
            break
        }
    }
    
    internal static func fetchPaywalls(for placementIDs : [String],  provider: PaywallerAppProviderConfiguration){
        for placementID in placementIDs {
            fetchPaywall(for: placementID, provider: provider)
        }
    }
    
    internal static func fetchPaywall(for placementID : String, provider : PaywallerAppProviderConfiguration){
        let adaptyPaywall = AdaptyManager.getPaywall(placementID: placementID)
        guard let remoteConfig = adaptyPaywall?.remoteConfig as? [String : Any] else {return}
        guard let paywallID = remoteConfig["paywall_id"] as? String else {return}
        
        APIManager.shared.getPaywall(id: paywallID, completion: { result in
            switch result {
            case .success(let dictionary):
                if let json = dictionary["json"] as? [String : Any]{
                    DispatchQueue.main.async {
                        let sectionTypes = PaywallerPaywallJSONWrapper.createSections(from: json)
                        let constants = PaywallerPaywallJSONWrapper.createConstants(from: json)
                        constants.provider = .adapty(placementID: placementID)
                        
                        let manager = PaywallerPaywallManager()
                        manager.constants = constants
                        
                        let paywall = PaywallerPaywallController()
                        paywall.paywallManager = manager
                        
                        manager.paywall = paywall
                        
                        for sectionType in sectionTypes {
                            manager.sections.append(PaywallerPaywallSection(type: sectionType, manager: manager))
                        }
                        Constants.paywalls.append(PaywallerPaywall(manager: manager, provider: provider))
                    }
         
                }
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
}
