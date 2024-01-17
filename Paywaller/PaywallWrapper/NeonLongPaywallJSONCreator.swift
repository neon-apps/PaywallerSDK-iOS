//
//  NeonLongPaywallJSONCreator.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 9.01.2024.
//

import Foundation
import UIKit


extension NeonLongPaywallJSONWrapper {
    static func createJSON(from sections: [NeonLongPaywallSectionType], constants : NeonLongPaywallConstants ) -> [String: Any] {
        var json: [String: Any] = [:]
        var sectionsArray: [[String: Any]] = []

        for (index, section) in sections.enumerated() {
            var sectionDict: [String: Any] = [:]

            switch section {
            case .spacing:
                sectionDict = createSpacingJSON(from: section, index: index) ?? [:]
                break
            case .label:
                sectionDict = createLabelJSON(from: section, index: index) ?? [:]
                break
            case .image:
                break
            case .imageWithURL:
                sectionDict = createImageJSON(from: section, index: index) ?? [:]
                break
            case .features:
                sectionDict = createFeaturesJSON(from: section, index: index) ?? [:]
                break
            case .testimonialCard:
                sectionDict = createTestimonialCardJSON(from: section, index: index) ?? [:]
                break
            case .plans:
                sectionDict = createPlansJSON(from: section, index: index) ?? [:]
                break
            case .whatYouWillGet:
                sectionDict = createWhatYouWillGetJSON(from: section, index: index) ?? [:]
                break
            case .timeline:
                sectionDict = createTimelineJSON(from: section, index: index) ?? [:]
                break
            case .testimonials:
                sectionDict = createTestimonialsJSON(from: section, index: index) ?? [:]
                break
            case .faq:
                sectionDict = createFAQJSON(from: section, index: index) ?? [:]
                break
            case .planComparison:
                sectionDict = createPlanComparisonJSON(from: section, index: index) ?? [:]
                break
            case .trustBadge:
                sectionDict = createTrustBadgeJSON(from: section, index: index) ?? [:]
                break
            case .slide:
                sectionDict = createSlideJSON(from: section, index: index) ?? [:]
                break
            case .custom:
                break
            }

            if !sectionDict.isEmpty {
                sectionsArray.append(sectionDict)
            }
        }

 
        json["sections"] = sectionsArray
        json["configuration"] = createConfigurationJSON(from: constants)
        return json
    }


}
