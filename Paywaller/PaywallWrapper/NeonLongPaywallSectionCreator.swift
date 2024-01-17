//
//  NeonLongPaywallJSONWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 4.12.2023.
//

import Foundation


class NeonLongPaywallJSONWrapper {
    static func createSections(from json: [String: Any]) -> [NeonLongPaywallSectionType] {
        var sections: [NeonLongPaywallSectionType] = []

        if let sectionsArray = json["sections"] as? [[String: Any]] {
            // Sort the sections by index
            let sortedSections = sectionsArray.sorted { (section1, section2) -> Bool in
                if let index1 = section1["index"] as? Int,
                   let index2 = section2["index"] as? Int {
                    return index1 < index2
                }
                return false
            }

            for sectionDict in sortedSections {
                if let type = sectionDict["type"] as? String,
                   let data = sectionDict["data"] as? [String: Any] {
                    switch type {
                    case "spacing":
                        if let spacingSection = createSpacingSection(fromDict: data) {
                            sections.append(spacingSection)
                        }
                    case "label":
                        if let labelSection = createLabelSection(fromDict: data) {
                            sections.append(labelSection)
                        }
                    case "image":
                        if let imageSection = createImageSection(fromDict: data) {
                            sections.append(imageSection)
                        }
                    case "features":
                        if let featuresSection = createFeaturesSection(fromDict: data) {
                            sections.append(featuresSection)
                        }
                    case "testimonialCard":
                        if let testimonialCardSection = createTestimonialCardSection(fromDict: data) {
                            sections.append(testimonialCardSection)
                        }
                    case "slide":
                        if let slideSection = createSlideSection(fromDict: data) {
                            sections.append(slideSection)
                        }
                    case "timeline":
                        if let timelineSection = createTimelineSection(fromDict: data) {
                            sections.append(timelineSection)
                        }
                    case "whatYouWillGet":
                        if let whatyouwillgetSection = createWhatYouWillGetSection(fromDict: data) {
                            sections.append(whatyouwillgetSection)
                        }
                    case "testimonials":
                        if let testimonialsSection = createTestimonialsSection(fromDict: data) {
                            sections.append(testimonialsSection)
                        }
                    case "faq":
                        if let faqSection = createFAQSection(fromDict: data) {
                            sections.append(faqSection)
                        }
                    case "planComparison":
                        if let plancomparisonSection = createPlanComparisonSection(fromDict: data) {
                            sections.append(plancomparisonSection)
                        }
                    case "plans":
                        if let plansSection = createPlansSection(fromDict: data) {
                            sections.append(plansSection)
                        }
                    case "trustbadge":
                        if let trustbadgeSection = createTrustBadgeSection(fromDict: data) {
                            sections.append(trustbadgeSection)
                        }
                    // Handle other section types here
                    default:
                        break
                    }
                }
            }
        }

        return sections
    }


    static func addSections(_ sections: [NeonLongPaywallSectionType], manager : NeonLongPaywallManager) {
        for section in sections {
            manager.addSection(type: section)
        }
    }
}


