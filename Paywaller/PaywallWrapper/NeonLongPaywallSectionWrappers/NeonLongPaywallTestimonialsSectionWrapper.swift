//
//  NeonLongPaywallTedtimonialSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createTestimonialsSection(fromDict dict: [String: Any]) -> NeonLongPaywallSectionType? {
        if let height = dict["height"] as? CGFloat,
           let itemsData = dict["items"] as? [[String: Any]] {
            
            var testimonialItems: [NeonTestimonial] = []
            for itemData in itemsData {
                if let title = itemData["title"] as? String,
                   let testimonial = itemData["testimonial"] as? String,
                   let author = itemData["author"] as? String {
                    
                    let testimonialItem = NeonTestimonial(title: title, testimonial: testimonial, author: author)
                    testimonialItems.append(testimonialItem)
                }
            }
            
            return .testimonials(height: height, items: testimonialItems)
        }
        return nil
    }
}
@available(iOS 15.0, *)
extension NeonLongPaywallJSONWrapper {
    static func createTestimonialsJSON(from section: NeonLongPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .testimonials(height, items) = section else {
            return nil // Return nil if the input section is not of type .testimonials
        }
        
        var testimonialsDict: [String: Any] = [
            "index": index,
            "type": "testimonials"
        ]
        
        var dataDict: [String: Any] = [
            "height": height
        ]
        
        var itemsArray: [[String: Any]] = []
        for item in items {
            var itemDict: [String: Any] = [
                "title": item.title,
                "testimonial": item.testimonial,
                "author": item.author
            ]
            itemsArray.append(itemDict)
        }
        
        dataDict["items"] = itemsArray
        
        testimonialsDict["data"] = dataDict
        
        return testimonialsDict
    }
}


/*
 
 
 Example JSON
 
 {
     "type": "testimonials",
     "data": {
         "height": 220,
         "items": [
             {
                 "title": "Great Product",
                 "testimonial": "I love this product! It has changed my life.",
                 "author": "John Doe"
             },
             {
                 "title": "Highly Recommended",
                 "testimonial": "I highly recommend this to everyone.",
                 "author": "Jane Smith"
             }
         ]
     },
     "index": 4
 }
 
 */
