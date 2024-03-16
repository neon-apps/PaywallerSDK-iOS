//
//  PaywallerPaywallFAQSectionWrapper.swift
//  NeonLongOnboardingPlayground
//
//  Created by Mehmet Kaan on 5.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createFAQSection(fromDict dict: [String: Any]) -> PaywallerPaywallSectionType? {
        if let title = dict["title"] as? String,
           let itemsData = dict["items"] as? [[String: Any]] {
            
            let horizontalPadding = dict["horizontalPadding"] as? CGFloat ?? 0
            
            var items: [PaywallerPaywallFAQItem] = []
            for itemData in itemsData {
                if let question = itemData["question"] as? String,
                   let answerTitle = itemData["answerTitle"] as? String,
                   let answerSubtitle = itemData["answerSubtitle"] as? String {
                    
                    let faqItem = PaywallerPaywallFAQItem(question: question, answerTitle: answerTitle, answerSubtitle: answerSubtitle)
                    items.append(faqItem)
                }
            }
            
            return .faq(title: title,  items: items, horizontalPadding : horizontalPadding)
        }
        return nil
    }
}
@available(iOS 15.0, *)
extension PaywallerPaywallJSONWrapper {
    public static func createFAQJSON(from section: PaywallerPaywallSectionType, index: Int) -> [String: Any]? {
        guard case let .faq(title, items, horizontalPadding) = section else {
            return nil // Return nil if the input section is not of type .faq
        }
        
        var faqDict: [String: Any] = [
            "index": index,
            "type": "faq",
            "data": [
                "title": title,
                "horizontalPadding": horizontalPadding,
                "items": []
            ]
        ]
        
        for item in items {
            let itemDict: [String: Any] = [
                "answerSubtitle": item.answerSubtitle,
                "answerTitle": item.answerTitle,
                "question": item.question
            ]
            if var dataDict = faqDict["data"] as? [String: Any] {
                dataDict["items"] = (dataDict["items"] as? [[String: Any]] ?? []) + [itemDict]
                faqDict["data"] = dataDict
            }
        }
        
        return faqDict
    }
}

/*
 
 
 Example JSON
 
 {
   "data": {
     "items": [
       {
         "answerSubtitle": "Learn about our amazing product.",
         "answerTitle": "Product Description",
         "question": "What is this product?"
       },
       {
         "answerSubtitle": "Find out how to buy our product.",
         "answerTitle": "Purchase Information",
         "question": "How can I purchase?"
       },
       {
         "answerSubtitle": "Get information about our free trial offer.",
         "answerTitle": "Free Trial Details",
         "question": "Is there a free trial?"
       }
     ],
     "title": "Frequently Asked Questions"
   },
   "index": 11,
   "type": "faq"
 }
 
 */
