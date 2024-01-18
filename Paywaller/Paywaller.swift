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
    
    public static func configure(apiKey : String, provider : PaywallerProviderConfiguration){
        configureProvider(provider: provider)
        Font.configureFonts(font: .SFProDisplay)
        Constants.apiKey = apiKey
    }
    
    public static func presentPaywall(with provider : PaywallerProviderPaywallConfiguration, from controller : UIViewController){
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
    
    internal static func configureProvider(provider : PaywallerProviderConfiguration){
        switch provider {
        case .adapty(let apiKey, let placementIDs, let accessLevel):
            AdaptyManager.configure(withAPIKey: apiKey, placementIDs: placementIDs, accessLevel: accessLevel) {
                fetchPaywalls(for: placementIDs)
            }
            break
        case .revenuecat:
            break
        }
    }
    
    internal static func fetchPaywalls(for placementIDs : [String]){
        for placementID in placementIDs {
            fetchPaywall(for: placementID)
        }
    }
    
    internal static func fetchPaywall(for placementID : String){
        let adaptyPaywall = AdaptyManager.getPaywall(placementID: placementID)
        guard let remoteConfig = adaptyPaywall?.remoteConfig as? [String : Any] else {return}
        guard let paywallID = remoteConfig["paywall_id"] as? String else {return}
        
        APIManager.shared.getPaywall(id: paywallID, completion: { result in
            switch result {
            case .success(let dictionary):
                if let json = dictionary["json"] as? [String : Any]{
                    DispatchQueue.main.async {
                        let sectionTypes = NeonLongPaywallJSONWrapper.createSections(from: json)
                        let constants = NeonLongPaywallJSONWrapper.createConstants(from: json)
                        let manager = NeonLongPaywallManager()
                        manager.constants = constants
                        
                        let paywall = NeonLongPaywallController()
                        paywall.paywallManager = manager
                        
                        manager.paywall = paywall
                        
                        for sectionType in sectionTypes {
                            manager.sections.append(NeonLongPaywallSection(type: sectionType, manager: manager))
                        }
                        Constants.paywalls.append(PaywallerPaywall(manager: manager, provider: .adapty(placementID: placementID)))
                    }
         
                }
            case .failure(let failure):
                print(failure)
            }
        })
    }
    
}
