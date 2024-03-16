//
//  PaywallerPaywallTestimonialCardSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 5.12.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createTestimonialCardSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let title = dict["title"] as? String,
           let subtitle = dict["subtitle"] as? String,
           let author = dict["author"] as? String?,
           let imageURL = dict["imageURL"] as? String? { // Change parameter name here
            
            let horizontalPadding = dict["horizontalPadding"] as? CGFloat ?? 0
            
            return .testimonialCard(title: title, subtitle: subtitle, author: author, overrideImageWithURL: imageURL, horizontalPadding: horizontalPadding)
        }
        return nil
    }


}
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createTestimonialCardJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .testimonialCard(title, subtitle, author, image, imageURL, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .testimonialCard
        }
        
        var testimonialCardDict: [String: Any] = [
            "index": index,
            "type": "testimonialCard",
            "data": [
                "title": title,
                "subtitle": subtitle,
                "horizontalPadding" : horizontalPadding
            ]
        ]
        
        if let author = author {
            if var dataDict = testimonialCardDict["data"] as? [String: Any] {
                dataDict["author"] = author
                testimonialCardDict["data"] = dataDict
            }
        }
        
        if let imageURL = imageURL {
            if var dataDict = testimonialCardDict["data"] as? [String: Any] {
                dataDict["imageURL"] = imageURL
                testimonialCardDict["data"] = dataDict
            }
        }
        
        return testimonialCardDict
    }
}

/*
 
 
 Example JSON
 
 {
     "type": "testimonialCard",
     "data": {
         "title": "Customer Testimonial",
         "subtitle": "A satisfied customer shares their experience",
         "author": "John Doe",
         "imageURL": "https://example.com/confetti-image.jpg"
     },
     "index": 3
 }
 */
