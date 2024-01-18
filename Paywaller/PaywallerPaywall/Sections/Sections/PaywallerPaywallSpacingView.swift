//
//  PaywallerPaywallSpacingView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class PaywallerPaywallSpacingView : BasePaywallerPaywallSectionView{
    
    

    
    override func configureSection(type: PaywallerPaywallSectionType) {
        switch type {
        case .spacing(let height):
            snp.makeConstraints { make in
                make.height.equalTo(height)
            }
            break
        default:
            fatalError("Something went wrong with PaywallerPaywall. Please consult to manager.")
        }
    }
    
  
    
 
    
}
