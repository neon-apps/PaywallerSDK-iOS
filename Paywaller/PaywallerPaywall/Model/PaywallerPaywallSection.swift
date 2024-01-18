//
//  PaywallerPaywallSection.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK

@available(iOS 15.0, *)
public class PaywallerPaywallSection{
    
    
    public var view : BasePaywallerPaywallSectionView{
        switch type {
        case .spacing:
            return PaywallerPaywallSpacingView(type: type, manager: manager)
        case .label:
            return PaywallerPaywallLabelView(type: type, manager: manager)
        case .image:
            return PaywallerPaywallImageView(type: type, manager: manager)
        case .imageWithURL:
            return PaywallerPaywallImageView(type: type, manager: manager)
        case .features:
            return PaywallerPaywallFeaturesView(type: type, manager: manager)
        case .testimonialCard:
            return PaywallerPaywallTestimonialCardView(type: type, manager: manager)
        case .plans:
            return PaywallerPaywallPlansView(type: type, manager: manager)
        case .whatYouWillGet:
            return PaywallerPaywallWhatYouWillGetView(type: type, manager: manager)
        case .timeline:
            return PaywallerPaywallTimelineView(type: type, manager: manager)
        case .testimonials:
            return PaywallerPaywallTestimonialsView(type: type, manager: manager)
        case .faq:
            return PaywallerPaywallFAQView(type: type, manager: manager)
        case .planComparison:
            return PaywallerPaywallPlanComparisonView(type: type, manager: manager)
        case .trustBadge:
            return PaywallerPaywallTrustBadgeView(type: type, manager: manager)
        case .slide:
            return PaywallerPaywallSlideView(type: type, manager: manager)
        case .custom:
            return BasePaywallerPaywallSectionView(type: type, manager: manager)
        }
        
    }
    
    public var type : PaywallerPaywallSectionType
    public var manager : PaywallerPaywallManager
    public init(type: PaywallerPaywallSectionType, manager : PaywallerPaywallManager) {
        self.type = type
        self.manager = manager
    }
    
    public func copy(with manager : PaywallerPaywallManager) -> PaywallerPaywallSection {
        let copiedSection = PaywallerPaywallSection(type: self.type.copy(), manager: manager)
         return copiedSection
     }
}

