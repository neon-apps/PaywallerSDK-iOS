//
//  PaywallerPaywallHorizontalPlansView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
public class PaywallerPaywallPlansView : BasePaywallerPaywallSectionView, PaywallerPaywallPlanViewDelegate{
    
    

    
    
    let stackView = UIStackView()
    var type = PaywallerPaywallPlanViewType.horizontal
    var shouldUsePlaceholders = Bool()
    var horizontalPadding = CGFloat()
    public override func configureSection(type: PaywallerPaywallSectionType) {
        
      
       
    
        switch type {
        case .plans(let type, let plans, let shouldUsePlaceholders, let horizontalPadding):
            self.type = type
            manager.constants.allPlans = plans
            self.horizontalPadding = horizontalPadding
            self.shouldUsePlaceholders = shouldUsePlaceholders
            plans.forEach({addItem(item: $0, allItems: plans)})
            break
        default:
            fatalError("Something went wrong with PaywallerPaywall. Please consult to manager.")
        }

        
        packageFetched()
        configureView()
        setConstraint()
    }
    
    
    func configureView(){
        
      
        switch type {
        case .horizontal:
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                if manager.constants.allPlans.count < 3{
                    make.width.equalTo(manager.constants.allPlans.count * 130)
                    stackView.spacing = 20
                }else{
                    make.left.right.equalToSuperview().inset(horizontalPadding)
                    stackView.spacing = 10
                }
                make.centerX.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(170)
            }
            
        case .vertical:
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(horizontalPadding)
                make.top.equalToSuperview()
            }
            
        }
    
    }
    
    func addItem(item : PaywallerPaywallPlan, allItems : [PaywallerPaywallPlan]){
        
        switch type {
        case .horizontal:
            let planView = PaywallerPaywallHorizontalPlanView(paywallManager: manager)
            planView.allPlans = allItems
            planView.plan = item
            planView.delegate = self
            stackView.addArrangedSubview(planView)
        case .vertical:
            let planView = PaywallerPaywallVerticalPlanView(paywallManager: manager)
            planView.allPlans = allItems
            planView.plan = item
            planView.delegate = self
            stackView.addArrangedSubview(planView)
            planView.snp.makeConstraints { make in
                make.bottom.equalTo(planView.unitCostLabel.snp.bottom).offset(12)
            }
        }
    }
    
    func planSelected() {
        deselectPlans()
    }
    
    func select(plan : PaywallerPaywallPlan){
        
        deselectPlans()
        
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let planView = subview as? PaywallerPaywallHorizontalPlanView{
                    if planView.plan?.productIdentifier == plan.productIdentifier{
                        planView.selectPlan()
                    }
                }
            case .vertical:
                if let planView = subview as? PaywallerPaywallVerticalPlanView{
                    if planView.plan?.productIdentifier == plan.productIdentifier{
                        planView.selectPlan()
                    }
                }
            }
        }
        
    }
    func deselectPlans(){
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let plan = subview as? PaywallerPaywallHorizontalPlanView{
                    plan.deselectPlan()
                }
            case .vertical:
                if let plan = subview as? PaywallerPaywallVerticalPlanView{
                    plan.deselectPlan()
                }
            }
        }
    }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.bottom)
        }
    }
    
    func packageFetched() {
        for subview in stackView.subviews{
            switch type {
            case .horizontal:
                if let plan = subview as? PaywallerPaywallHorizontalPlanView{
                    plan.reloadPackage(shouldUsePlaceholders: shouldUsePlaceholders)
                }
            case .vertical:
                if let plan = subview as? PaywallerPaywallVerticalPlanView{
                    plan.reloadPackage(shouldUsePlaceholders: shouldUsePlaceholders)
                }
            }
        }
    }
    
}
