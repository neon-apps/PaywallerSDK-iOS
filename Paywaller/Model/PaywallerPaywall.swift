//
//  PaywallerPaywall.swift
//  Paywaller Example
//
//  Created by Tuna Öztürk on 16.01.2024.
//

import Foundation

@available(iOS 15.0, *)
class PaywallerPaywall{
    internal init(manager: NeonLongPaywallManager = NeonLongPaywallManager(), provider: PaywallerProviderPaywallConfiguration = PaywallerProviderPaywallConfiguration.none) {
        self.manager = manager
        self.provider = provider
    }
    
    var manager = NeonLongPaywallManager()
    var provider = PaywallerProviderPaywallConfiguration.none
}