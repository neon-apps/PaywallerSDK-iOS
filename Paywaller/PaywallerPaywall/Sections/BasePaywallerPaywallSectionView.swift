//
//  BasePaywallerPaywallSection.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
open class BasePaywallerPaywallSectionView: UIView {
    
    var manager = PaywallerPaywallManager()
    
    public init(type: PaywallerPaywallSectionType, manager : PaywallerPaywallManager) {
        super.init(frame: .zero)
        self.manager = manager
        configureSection(type : type)
    }
    public override func didMoveToSuperview() {
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    open func configureSection(type : PaywallerPaywallSectionType) {
        
    }
    
    func showContainer(){
        layer.cornerRadius = 10
        backgroundColor = manager.constants.containerColor
    }
}
