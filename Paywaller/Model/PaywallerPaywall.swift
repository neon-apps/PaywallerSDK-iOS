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
    internal init(manager: PaywallerPaywallManager = PaywallerPaywallManager(), provider: PaywallerAppProviderConfiguration = PaywallerAppProviderConfiguration.none) {
        self.manager = manager
        self.provider = provider
    }
    
    var manager = PaywallerPaywallManager()
    var provider = PaywallerAppProviderConfiguration.none
}
