//
//  PaywallerPaywallSectionType.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit
import AVFoundation

public enum PaywallerPaywallSectionType{
    case spacing(height : CGFloat)
    case label(text : String, font : UIFont, overrideTextColor : UIColor? = nil, alignment : NSTextAlignment, horizontalPadding :CGFloat)
    case image(height : CGFloat, image : UIImage, cornerRadious : CGFloat, horizontalPadding :CGFloat, contentMode : UIView.ContentMode)
    case video(height : CGFloat, videoFileName : String, videoFileExtension : String, cornerRadious : CGFloat, horizontalPadding :CGFloat, contentMode : AVLayerVideoGravity)
    case imageWithURL(height : CGFloat, url : String, cornerRadious : CGFloat, horizontalPadding :CGFloat, contentMode : UIView.ContentMode)
    case features(items : [NeonPaywallFeature], overrideTextColor : UIColor? = nil,  font : UIFont? = nil, iconTintColor : UIColor? = nil, offset : CGFloat? = nil, horizontalPadding :CGFloat)
    case testimonialCard(title : String, subtitle : String, author : String? = nil, overrideImage : UIImage? = nil,  overrideImageWithURL : String? = nil, horizontalPadding :CGFloat)
    case plans(type : PaywallerPaywallPlanViewType, items : [PaywallerPaywallPlan], shouldUsePlaceholders : Bool, horizontalPadding : CGFloat)
    case whatYouWillGet(title : String, hasContainer : Bool, items : [PaywallerPaywallWhatYouWillGetItem], horizontalPadding :CGFloat)
    case timeline(hasContainer : Bool, items : [PaywallerPaywallTimelineItem] , horizontalPadding :CGFloat)
    case testimonials(height : CGFloat = 220, items : [NeonTestimonial] , horizontalPadding :CGFloat)
    case faq(title : String, items : [PaywallerPaywallFAQItem], horizontalPadding :CGFloat)
    case planComparison(items : [PaywallerPaywallPlanComparisonItem] , horizontalPadding :CGFloat)
    case trustBadge(type : PaywallerPaywallTrustBadgeType )
    case slide(height : CGFloat = 400, showBeforeAfterBadges : Bool, items : [NeonSlideItem] , horizontalPadding :CGFloat)
    case custom(view : UIView)
    
    public func copy() -> PaywallerPaywallSectionType {
         switch self {
         case .spacing(let height):
             return .spacing(height: height)
         case .label(let text, let font, let overrideTextColor, let alignment, let horizontalPadding):
             return .label(text: text, font: font, overrideTextColor: overrideTextColor, alignment: alignment, horizontalPadding: horizontalPadding)
         case .image(let height, let image, let cornerRadius, let horizontalPadding, let contentMode):
             return .image(height: height, image: image, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
         case .video(let height, let videoFileName, let videoFileExtension, let cornerRadious, let horizontalPadding, let contentMode):
             return .video(height: height, videoFileName: videoFileName, videoFileExtension: videoFileExtension, cornerRadious: cornerRadious, horizontalPadding: horizontalPadding, contentMode: contentMode)
         case .imageWithURL(let height, let url, let cornerRadius, let horizontalPadding, let contentMode):
             return .imageWithURL(height: height, url: url, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
         case .features(let items, let overrideTextColor, let font, let iconTintColor, let offset, let horizontalPadding):
             return .features(items: items, overrideTextColor: overrideTextColor, font: font, iconTintColor: iconTintColor, offset: offset, horizontalPadding: horizontalPadding)
         case .testimonialCard(let title, let subtitle, let author, let overrideImage, let overrideImageWithURL, let horizontalPadding):
             return .testimonialCard(title: title, subtitle: subtitle, author: author, overrideImage: overrideImage, overrideImageWithURL: overrideImageWithURL, horizontalPadding: horizontalPadding)
         case .plans(let type, let items, let shouldUsePlaceholders, let horizontalPadding):
             return .plans(type: type, items: items, shouldUsePlaceholders: shouldUsePlaceholders, horizontalPadding: horizontalPadding)
         case .whatYouWillGet(let title, let hasContainer, let items, let horizontalPadding):
             return .whatYouWillGet(title: title, hasContainer: hasContainer, items: items, horizontalPadding: horizontalPadding)
         case .timeline(let hasContainer, let items, let horizontalPadding):
             return .timeline(hasContainer: hasContainer, items: items, horizontalPadding: horizontalPadding)
         case .testimonials(let height, let items, let horizontalPadding):
             return .testimonials(height: height, items: items, horizontalPadding: horizontalPadding)
         case .faq(let title, let items, let horizontalPadding):
             return .faq(title: title, items: items, horizontalPadding: horizontalPadding)
         case .planComparison(let items, let horizontalPadding):
             return .planComparison(items: items, horizontalPadding: horizontalPadding)
         case .trustBadge(let type):
             return .trustBadge(type: type)
         case .slide(let height, let showBeforeAfterBadges, let items, let horizontalPadding):
             return .slide(height: height, showBeforeAfterBadges: showBeforeAfterBadges, items: items, horizontalPadding: horizontalPadding)
         case .custom(let view):
             // Handle the custom case by creating a copy of the UIView or whatever type it represents.
             if let viewCopyable = view.copy() as? UIView {
                 return .custom(view: viewCopyable)
             } else {
                 // Return the original custom case if it cannot be copied.
                 return .custom(view: view)
             }
         }
     }
}
