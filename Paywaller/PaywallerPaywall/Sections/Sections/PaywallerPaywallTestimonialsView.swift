//
//  PaywallerPaywallTestimonialView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 15.0, *)
class PaywallerPaywallTestimonialsView : BasePaywallerPaywallSectionView{
    
    
     let testimonialView = NeonTestimonialView()
    
    override func configureSection(type: PaywallerPaywallSectionType) {
        
        configureView()
        switch type {
        case .testimonials(let height, let items, let horizontalPadding):
            
            addSubview(testimonialView)
            testimonialView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(horizontalPadding)
                make.top.equalToSuperview()
                make.height.equalTo(height)
            }
            
 
            items.forEach { item in
                testimonialView.addTestimonial(title: item.title, testimonial: item.testimonial, author: item.author)
            }
            
            break
        default:
            fatalError("Something went wrong with PaywallerPaywall. Please consult to manager.")
        }
        
        setConstraint()
    }
    
    private func configureView() {
        
       
        
        testimonialView.testimonialTextColor = manager.constants.primaryTextColor
        testimonialView.testimonialbackgroundColor = manager.constants.containerColor
        testimonialView.currentTestimonialPageTintColor = manager.constants.mainColor
        testimonialView.testimonialPageTintColor = manager.constants.secondaryTextColor
        testimonialView.testimonialbackgroundCornerRadious = Int(manager.constants.cornerRadius)
        
        testimonialView.pageControlType = .V1
        
     }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(testimonialView.snp.bottom)
        }
    }
    
}
