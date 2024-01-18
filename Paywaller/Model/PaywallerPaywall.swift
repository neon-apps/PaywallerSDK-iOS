//
//  PaywallerPaywall.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation
import NeonSDK

@available(iOS 15.0, *)
class PaywallerPaywall{
    internal init(manager: PaywallerPaywallManager = PaywallerPaywallManager(), provider: PaywallerProviderPaywallConfiguration = PaywallerProviderPaywallConfiguration.none) {
        self.manager = manager
        self.provider = provider
    }
    
    var manager = PaywallerPaywallManager()
    var provider = PaywallerProviderPaywallConfiguration.none
}
