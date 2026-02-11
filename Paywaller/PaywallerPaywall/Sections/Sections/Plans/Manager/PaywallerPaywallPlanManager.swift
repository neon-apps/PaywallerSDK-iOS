////
////  PaywallerPaywallPlanManager.swift
////  NeonLongOnboardingPlayground
////
////  Created by Tuna Öztürk on 23.11.2023.
////
//


import Foundation
import NeonSDK
import UIKit
import StoreKit

public enum PaywallerPaywallPlanViewType {
    case horizontal
    case vertical
}

protocol PaywallerPaywallPlanViewDelegate {
    func planSelected()
}

@available(iOS 15.0, *)
class PaywallerPaywallPlanManager {
  
    var allPlans = [PaywallerPaywallPlan]()
    var plan: PaywallerPaywallPlan?
         
    func fetchProduct(for plan: PaywallerPaywallPlan) -> Product? {
        if let adaptyPackage = AdaptyManager.getPackage(id: plan.productIdentifier) {
            return adaptyPackage.sk2Product
        } else if let revenueCatPackage = RevenueCatManager.getPackage(id: plan.productIdentifier) {
            return revenueCatPackage.storeProduct.sk2Product
        } else {
            return nil
        }
    }
    
    func configurePriceWithProduct(product: Product, durationLabel: UILabel, unitCostLabel: UILabel, plan: PaywallerPaywallPlan, allPlans: [PaywallerPaywallPlan]) {
        
        self.plan = plan
        self.allPlans = allPlans
        
        switch plan.priceType {
        case .default:
            showDefaultPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        case .perWeek:
            showWeeklyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        case .perMonth:
            showMonthlyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    func configurePlaceholderPrices(durationLabel: UILabel, unitCostLabel: UILabel, plan: PaywallerPaywallPlan, allPlans: [PaywallerPaywallPlan]) {
       
       self.plan = plan
       self.allPlans = allPlans
       
       switch plan.priceType {
       case .default:
           unitCostLabel.text = "{PLAN-PRICE}"
       case .perWeek:
           unitCostLabel.text = "{WEEKLY-PRICE}"
       case .perMonth:
           unitCostLabel.text = "{MONTHLY-PRICE}"
       }
   }
    
    
    func getDefaultPrice(product: Product) -> String {
        // Use StoreKit 2's built-in formatting if available, otherwise fallback to manual
        return product.displayPrice
    }
    
    // MARK: - Price Display Logic
    
    func showDefaultPriceFor(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
        if let subscription = product.subscription{
           let period = subscription.subscriptionPeriod
            
            let numberOfUnits = period.value
            let unit = period.unit
            
            let (unitString, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            durationLabel.text = plan?.title ?? durationLabelText
            
            // Currency
            let currencyCode = product.priceFormatStyle.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
            
            // Price
            let priceVal = NSDecimalNumber(decimal: product.price).doubleValue
            let formattedPrice = formatPrice(price: priceVal)
            
            if let unitString = unitString {
                unitCostLabel.text = "\(currencySymbol)\(formattedPrice) / \(unitString)"
            } else {
                unitCostLabel.text = "\(currencySymbol)\(formattedPrice)"
            }
            
        } else {
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    func showWeeklyPriceFor(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
        if let subscription = product.subscription{
           let period = subscription.subscriptionPeriod
            
            let numberOfUnits = period.value
            let unit = period.unit
            let price = product.price
            
            let weekCount = calculateWeekCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            
            durationLabel.text = plan?.title ?? durationLabelText
            
            let currencyCode = product.priceFormatStyle.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
            
            let priceDouble = NSDecimalNumber(decimal: price).doubleValue
            let pricePerWeek = calculatePricePerUnit(numberOfUnits: weekCount, price: priceDouble)
            
            unitCostLabel.text = "\(currencySymbol)\(pricePerWeek) / week"
            
        } else {
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    func showMonthlyPriceFor(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
        if let subscription = product.subscription{
           let period = subscription.subscriptionPeriod
            
            let numberOfUnits = period.value
            let unit = period.unit
            let price = product.price
            
            let monthCount = calculateMonthCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            
            durationLabel.text = plan?.title ?? durationLabelText
            
            let currencyCode = product.priceFormatStyle.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
            
            let priceDouble = NSDecimalNumber(decimal: price).doubleValue
            let pricePerMonth = calculatePricePerUnit(numberOfUnits: monthCount, price: priceDouble)
            
            unitCostLabel.text = "\(currencySymbol)\(pricePerMonth) / month"
            
        } else {
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    func showLifetimePrice(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
        let price = NSDecimalNumber(decimal: product.price).doubleValue
        
        let currencyCode = product.priceFormatStyle.currencyCode
        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
        
        let formattedPrice = formatPrice(price: price)
        unitCostLabel.text = "\(currencySymbol)\(formattedPrice)"
        durationLabel.text = plan?.title ?? "Lifetime"
    }

    // MARK: - Intro Offer Logic

    func getIntroductoryPeriod(product: Product, completion: (_ duration: Int?, _ price: String?) -> ()) {
        guard let subscription = product.subscription,
              let offer = subscription.introductoryOffer else {
            completion(nil, nil)
            return
        }
        
        let numberOfUnits = offer.period.value
        let unit = offer.period.unit
        
        var introductoryPriceString: String?
        if offer.price > 0 {
            introductoryPriceString = offer.displayPrice
        }
        
        switch unit {
        case .day:
            completion(numberOfUnits, introductoryPriceString)
        case .week:
            completion(numberOfUnits * 7, introductoryPriceString)
        case .month:
            completion(numberOfUnits * 30, introductoryPriceString)
        case .year:
            completion(numberOfUnits * 365, introductoryPriceString)
        @unknown default:
            completion(nil, nil)
        }
    }
    
    // MARK: - Calculations
    
    func calculateWeekCount(unit: Product.SubscriptionPeriod.Unit, numberOfUnits: Int) -> Int {
        switch unit {
        case .day:
            return numberOfUnits / 7
        case .week:
            return numberOfUnits
        case .month:
            return numberOfUnits * 4
        case .year:
            return numberOfUnits * 52
        @unknown default:
            return 0
        }
    }
    
    func calculateMonthCount(unit: Product.SubscriptionPeriod.Unit, numberOfUnits: Int) -> Int {
        switch unit {
        case .day:
            WarningManager.add(warning: .cantShowMonthlyPriceForWeeklySubscription)
            return 0
        case .week:
            return Int(numberOfUnits / 4)
        case .month:
            return numberOfUnits
        case .year:
            return numberOfUnits * 12
        @unknown default:
            return 0
        }
    }
    
    func calculatePricePerDay(product: Product) -> Double? {
        if let subscription = product.subscription{
           let period = subscription.subscriptionPeriod
            
            let price = product.price
            let priceDouble = NSDecimalNumber(decimal: price).doubleValue
            var dayCount = 0
            
            let numberOfUnits = period.value
            let unit = period.unit
            
            switch unit {
            case .day:
                dayCount = numberOfUnits
            case .week:
                dayCount = numberOfUnits * 7
            case .month:
                dayCount = numberOfUnits * 30
            case .year:
                dayCount = numberOfUnits * 365
            @unknown default:
                return nil
            }
            
            if dayCount == 0 { return nil }
            return priceDouble / Double(dayCount)
            
        } else {
            return nil
        }
    }
    
    func getMostExpensivePlanPricePerDay() -> Double {
        var mostExpensivePlanPricePerDay = Double()
        
        for plan in allPlans {
            if let product = fetchProduct(for: plan),
               let pricePerDayForPlan = calculatePricePerDay(product: product) {
                
                if pricePerDayForPlan > mostExpensivePlanPricePerDay {
                    mostExpensivePlanPricePerDay = pricePerDayForPlan
                }
            }
        }
        return mostExpensivePlanPricePerDay
    }
    
    func calculateSaveRatio(currentPlanPricePerDay: Double, mostExpensivePlanPricePerDay: Double) -> String {
        guard mostExpensivePlanPricePerDay != 0 else {
            return ""
        }
        
        let savingsRatio = (1 - currentPlanPricePerDay / mostExpensivePlanPricePerDay) * 100
        let roundedSavings = Int(round(savingsRatio))
        
        if roundedSavings == 0 {
            return ""
        }
        return "Save \(roundedSavings)%"
    }
    
    func calculatePricePerUnit(numberOfUnits: Int, price: Double) -> String {
        guard numberOfUnits != 0 else { return "0.00" }
        return String(format: "%.2f", price / Double(numberOfUnits))
    }
    
    func formatPrice(price: Double) -> String {
        return String(format: "%.2f", price)
    }

    // MARK: - Helpers

    func getUnitString(unit: Product.SubscriptionPeriod.Unit, numberOfUnits: Int) -> (String?, String) {
        switch unit {
        case .day:
            if numberOfUnits == 7 {
                return ("week", "Weekly")
            }
        case .week:
            if numberOfUnits == 1 {
                return ("week", "Weekly")
            }
        case .month:
            if numberOfUnits == 1 {
                return ("month", "Monthly")
            }
            if numberOfUnits == 2 {
                return (nil, "2 Months")
            }
            if numberOfUnits == 3 {
                return (nil, "3 Months")
            }
            if numberOfUnits == 6 {
                return (nil, "6 Months")
            }
            if numberOfUnits == 12 {
                return ("year", "Annual")
            }
        case .year:
            if numberOfUnits == 1 {
                return ("year", "Annual")
            }
        @unknown default:
            return (nil, "")
        }
        
        return (nil, "")
    }

    // MARK: - Labels
    
    func calculateTagLabel(tagLabel: UILabel) {
        guard let plan = plan else { return }
        
        if let currentProduct = fetchProduct(for: plan) {
            getIntroductoryPeriod(product: currentProduct, completion: { duration, price in
                if let duration = duration, duration != 0 {
                    if let price = price {
                        tagLabel.text = plan.tag?.replacingOccurrences(of: "free_trial_duration", with: "\(duration)") ?? "\(price) FOR \(duration)-DAYS"
                    } else {
                        tagLabel.text = plan.tag?.replacingOccurrences(of: "free_trial_duration", with: "\(duration)") ?? "\(duration)-DAY FREE"
                    }
                } else {
                    tagLabel.text = plan.tag ?? " "
                }
            })
        }
    }
    
    func calculateSaveLabel(saveLabel: UILabel) {
        guard let plan = plan else { return }
        
        if let currentProduct = fetchProduct(for: plan),
           let currentPlanPricePerDay = calculatePricePerDay(product: currentProduct) {
            
            let mostExpensivePlanPricePerDay = getMostExpensivePlanPricePerDay()
            
            if currentPlanPricePerDay != mostExpensivePlanPricePerDay {
                saveLabel.text = calculateSaveRatio(currentPlanPricePerDay: currentPlanPricePerDay, mostExpensivePlanPricePerDay: mostExpensivePlanPricePerDay)
            }
        }
    }
    
    func isDefaultPlan() -> Bool {
        guard let plan = plan else { return false }
        let defaultSelectedPlanCount = allPlans.filter({$0.isDefaultSelected}).count
        
        if defaultSelectedPlanCount == 0 {
            WarningManager.add(warning: .selectAtLeastOnePlanSelected)
        } else if defaultSelectedPlanCount > 1 {
            WarningManager.add(warning: .cantMakeMoreThanOnePlanSelected)
        }
        
        if plan.isDefaultSelected {
            return true
        }
        
        return false
    }
}












//import Foundation
//import NeonSDK
//import UIKit
//import StoreKit
//
//
//public enum PaywallerPaywallPlanViewType{
//    case horizontal
//    case vertical
//}
//protocol PaywallerPaywallPlanViewDelegate{
//    func planSelected()
//}
//
//@available(iOS 15.0, *)
//class PaywallerPaywallPlanManager {
//  
//    var allPlans = [PaywallerPaywallPlan]()
//    var plan : PaywallerPaywallPlan?
//        
//    func fetchProduct(for plan : PaywallerPaywallPlan) -> Product?{
//        if let adaptyPackage = AdaptyManager.getPackage(id: plan.productIdentifier){
//            return adaptyPackage.sk2Product
//        }else if let revenueCatPackage = RevenueCatManager.getPackage(id: plan.productIdentifier){
//            return revenueCatPackage.storeProduct.sk2Product
//        }else{
//            return nil
//        }
//    }
//    
//     func configurePriceWithProduct(product : Product, durationLabel : UILabel,  unitCostLabel : UILabel, plan : PaywallerPaywallPlan, allPlans : [PaywallerPaywallPlan]){
//        
//        self.plan = plan
//        self.allPlans = allPlans
//        
//         
//        switch plan.priceType{
//        case .default:
//            showDefaultPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//            break
//        case .perWeek:
//            showWeeklyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//            break
//        case .perMonth:
//            showMonthlyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//            break
//        }
//    }
//    
//    func configurePlaceholderPrices(durationLabel : UILabel,  unitCostLabel : UILabel, plan : PaywallerPaywallPlan, allPlans : [PaywallerPaywallPlan]){
//       
//       self.plan = plan
//        self.allPlans = allPlans
//        
//       switch plan.priceType{
//       case .default:
//           unitCostLabel.text = "{PLAN-PRICE}"
//           break
//       case .perWeek:
//           unitCostLabel.text = "{WEEKLY-PRICE}"
//           break
//       case .perMonth:
//           unitCostLabel.text = "{MONTHLY-PRICE}"
//           break
//       }
//   }
//    
//    
//    
//    func getDefaultPrice(product : SKProduct) -> String{
//        let price = product.price
//        let currencyCode = product.priceLocale.currencyCode
//        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
//        let formattedPrice = formatPrice(price: price)
//        return "\(currencySymbol)\(formattedPrice)"
//    }
//    
//   
//
//    func showDefaultPriceFor(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
//        // 1. Check if the product is a subscription and has a period
//        if let subscription = product.subscription,
//           let period = subscription.subscriptionPeriod {
//            
//            let numberOfUnits = period.value // 'numberOfUnits' is now 'value'
//            let unit = period.unit
//            
//            // 2. Helper Logic (Assuming you updated getUnitString to accept StoreKit 2 units)
//            let (unitString, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
//            durationLabel.text = plan?.title ?? durationLabelText
//            
//            // 3. Currency Handling in StoreKit 2
//            // SK2 doesn't have 'priceLocale'. We get the code from the format style.
//            let currencyCode = product.priceFormatStyle.currencyCode
//            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
//            
//            // 4. Price Formatting
//            // product.price is a Decimal. If your formatPrice expects a Double, convert it:
//            let priceValue = NSDecimalNumber(decimal: product.price)
//            let formattedPrice = formatPrice(price: priceValue)
//            
//            if let unitString = unitString {
//                unitCostLabel.text = "\(currencySymbol)\(formattedPrice) / \(unitString)"
//            } else {
//                unitCostLabel.text = "\(currencySymbol)\(formattedPrice)"
//            }
//            
//        } else {
//            // Fallback for Lifetime or Non-Subscription products
//            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//        }
//    }
//    
////    func showDefaultPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
////        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
////           let unit = product.subscriptionPeriod?.unit{
////            let price = product.price
////            let (unitString, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
////            durationLabel.text = plan?.title ?? durationLabelText
////            let currencyCode = product.priceLocale.currencyCode
////            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
////            let formattedPrice = formatPrice(price: price)
////            if let unitString{
////                unitCostLabel.text = "\(currencySymbol)\(formattedPrice) / \(unitString)"
////            }else{
////                unitCostLabel.text = "\(currencySymbol)\(formattedPrice)"
////            }
////            
////        }else{
////            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
////        }
////    }
////
//    
//    func showWeeklyPriceFor(product: Product, durationLabel: UILabel, unitCostLabel: UILabel) {
//        // 1. Unwrap the subscription period
//        if let subscription = product.subscription{
//           let period = subscription.subscriptionPeriod
//            
//            let numberOfUnits = period.value // 'numberOfUnits' is now 'value'
//            let unit = period.unit
//            let price = product.price // This is a Decimal
//            
//            // 2. Helper Functions
//            // Make sure 'calculateWeekCount' and 'getUnitString' accept 'Product.SubscriptionPeriod.Unit'
//            let weekCount = calculateWeekCount(unit: unit, numberOfUnits: numberOfUnits)
//            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
//            
//            durationLabel.text = plan?.title ?? durationLabelText
//            
//            // 3. Currency Symbol
//            let currencyCode = product.priceFormatStyle.currencyCode
//            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode) ?? "$"
//            
//            // 4. Calculate Price Per Week
//            // Convert 'Decimal' to 'Double' for your helper function
//            let priceDouble = NSDecimalNumber(decimal: price).doubleValue
//            let pricePerWeek = calculatePricePerUnit(numberOfUnits: weekCount, price: priceDouble)
//            
//            unitCostLabel.text = "\(currencySymbol)\(pricePerWeek) / week"
//            
//        } else {
//            // Fallback for non-subscription products
//            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//        }
//    }
//    
////    func showWeeklyPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
////        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
////           let unit = product.subscriptionPeriod?.unit{
////            let price = product.price
////            let weekCount = calculateWeekCount(unit: unit, numberOfUnits: numberOfUnits)
////            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
////            durationLabel.text = plan?.title ?? durationLabelText
////            let currencyCode = product.priceLocale.currencyCode
////            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
////            let pricePerWeek = calculatePricePerUnit(numberOfUnits: weekCount, price: price)
////            unitCostLabel.text = "\(currencySymbol)\(pricePerWeek) / week"
////        }else{
////            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
////        }
////    }
////    
//    func showMonthlyPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
//        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
//           let unit = product.subscriptionPeriod?.unit{
//            let price = product.price
//            let monthCount = calculateMonthCount(unit: unit, numberOfUnits: numberOfUnits)
//            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
//            durationLabel.text = plan?.title ?? durationLabelText
//            let currencyCode = product.priceLocale.currencyCode
//            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
//            let pricePerMonth = calculatePricePerUnit(numberOfUnits: monthCount, price: price)
//            unitCostLabel.text = "\(currencySymbol)\(pricePerMonth) / month"
//        }else{
//            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
//        }
//    }
//    
//    
//    func getUnitString(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> (String?, String?){
//        switch unit {
//        case .day:
//            if numberOfUnits == 7{
//                return ("week", "Weekly")
//            }
//        case .week:
//            if numberOfUnits == 1{
//                return ("week", "Weekly")
//            }
//        case .month:
//            if numberOfUnits == 1{
//                return ("month", "Monthly")
//            }
//            if numberOfUnits == 2{
//                return (nil, "2 Months")
//            }
//            if numberOfUnits == 3{
//                return (nil, "3 Months")
//            }
//            if numberOfUnits == 6{
//                return (nil, "6 Months")
//            }
//            if numberOfUnits == 12{
//                return ("year", "Annual")
//            }
//        case .year:
//            if numberOfUnits == 1{
//                return ("year", "Annual")
//            }
//        default :
//            return (nil, nil)
//        }
//        
//        return (nil, nil)
//    }
//    
//    
//
//    
//    func getIntroductoryPeriod(product: Product, completion: (_ duration: Int?, _ price: String?) -> ()) {
//        
//        // 1. Access the subscription info and the introductory offer
//        // In StoreKit 2, these are optional properties on the Product
//        guard let subscription = product.subscription,
//              let offer = subscription.introductoryOffer else {
//            completion(nil, nil)
//            return
//        }
//        
//        // 2. Extract period information
//        // 'value' is the equivalent of 'numberOfUnits'
//        let numberOfUnits = offer.period.value
//        let unit = offer.period.unit
//        
//        var introductoryPriceString: String?
//        
//        // 3. Handle Price
//        // 'offer.price' is a Decimal. If it is greater than 0, we can use the pre-formatted string.
//        if offer.price > 0 {
//            // 'displayPrice' automatically handles currency symbol and formatting (e.g., "$3.99")
//            introductoryPriceString = offer.displayPrice
//        }
//        
//        // 4. Calculate total days based on the unit
//        switch unit {
//        case .day:
//            completion(numberOfUnits, introductoryPriceString)
//        case .week:
//            completion(numberOfUnits * 7, introductoryPriceString)
//        case .month:
//            completion(numberOfUnits * 30, introductoryPriceString)
//        case .year:
//            completion(numberOfUnits * 365, introductoryPriceString)
//        @unknown default:
//            completion(nil, nil)
//        }
//    }
//    
//    
////    func getIntroductoryPeriod(product : Product, completion : (_ duration: Int?, _ price: String?) -> ()){
////        
////        if let numberOfUnits = product.introductoryPrice?.subscriptionPeriod.numberOfUnits,
////           let unit = product.introductoryPrice?.subscriptionPeriod.unit{
////            
////            var introductoryPrice : String?
////            
////            if let price = product.introductoryPrice?.price{
////                if price != 0.0{
////                    let currencyCode = product.priceLocale.currencyCode
////                    let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
////                    introductoryPrice = "\(currencySymbol)\(formatPrice(price: price))"
////                }
////            }
////  
////            switch unit {
////            case .day:
////                completion(numberOfUnits, introductoryPrice)
////            case .week:
////                completion (numberOfUnits * 7, introductoryPrice)
////            case .month:
////                completion (numberOfUnits * 30, introductoryPrice)
////            case .year:
////                completion (numberOfUnits * 365, introductoryPrice)
////            default :
////                completion (nil,nil)
////            }
////            
////        }else{
////            completion (nil,nil)
////        }
////        
////    }
//    func showLifetimePrice(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
//        
//        let price = product.price
//        let currencyCode = product.priceLocale.currencyCode
//        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
//        let formattedPrice = formatPrice(price: price)
//        unitCostLabel.text = "\(currencySymbol)\(price)"
//        durationLabel.text = plan?.title ?? "Lifetime"
//        
//    }
//    
//    func calculateWeekCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
//        switch unit {
//        case .day:
//            return numberOfUnits / 7
//        case .week:
//            return numberOfUnits
//        case .month:
//            return numberOfUnits * 4
//        case .year:
//            return numberOfUnits * 52
//        default :
//            return 0
//        }
//    }
//    
//    func calculateMonthCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
//        switch unit {
//        case .day:
//            WarningManager.add(warning: .cantShowMonthlyPriceForWeeklySubscription)
//            return 0
//        case .week:
//            return Int(numberOfUnits / 4)
//        case .month:
//            return numberOfUnits
//        case .year:
//            return numberOfUnits * 12
//        default :
//            return 0
//        }
//    }
//    
//    func calculatePricePerDay(product : Product) -> Double?{
//        
//        if let numberOfUnits = product.subscription?.subscriptionPeriod,
//           let unit = product.subscription?.subscriptionPeriod.unit{
//            
//            let price = product.price
//           let dec = NSDecimalNumber(decimal: price).doubleValue
//            var dayCount = Int()
//            
//            switch unit {
//            case .day:
//                dayCount = numberOfUnits.value
//            case .week:
//                dayCount = numberOfUnits.value * 7
//            case .month:
//                dayCount = numberOfUnits.value * 30
//            case .year:
//                dayCount = numberOfUnits.value * 365
//            default :
//                return nil
//            }
//            
//            return Double(truncating: dec as NSNumber) / Double(dayCount)
//            
//            
//        }else{
//            return nil
//        }
//        
//        
//        
//        
//    }
//    
//    func calculatePricePerUnit(numberOfUnits : Int, price : NSDecimalNumber) -> String{
//        return String(format: "%.2f", Double(truncating: price) / Double(numberOfUnits))
//    }
//    
//    func formatPrice(price : NSDecimalNumber) -> String{
//        return String(format: "%.2f", Double(truncating: price))
//    }
//    
//    func getMostExpensivePlanPricePerDay() -> Double{
//        var mostExpensivePlanPricePerDay = Double()
//        
//        for plan in allPlans {
//            if let product = fetchProduct(for: plan), let pricePerDayForPlan =  calculatePricePerDay(product: product) {
//                if pricePerDayForPlan > mostExpensivePlanPricePerDay{
//                    mostExpensivePlanPricePerDay = pricePerDayForPlan
//                }
//            }
//        }
//        
//        return mostExpensivePlanPricePerDay
//    }
//    
//    func calculateSaveRatio(currentPlanPricePerDay: Double, mostExpensivePlanPricePerDay: Double) -> String {
//        
//        guard mostExpensivePlanPricePerDay != 0 else {
//            return ""
//        }
//        
//        let savingsRatio = (1 - currentPlanPricePerDay / mostExpensivePlanPricePerDay) * 100
//        
//        let roundedSavings = Int(round(savingsRatio))
//        
//        if roundedSavings == 0{
//            return ""
//        }
//        return "Save \(roundedSavings)%"
//    }
//    
//    
//    func calculateTagLabel(tagLabel : UILabel){
//        
//        guard let plan else { return }
//        
//        if let currentProduct = fetchProduct(for: plan){
//            
//            getIntroductoryPeriod(product: currentProduct, completion: { duration, price in
//                if let duration, duration != 0{
//                    if let price{
//                        tagLabel.text = plan.tag?.replacingOccurrences(of: "free_trial_duration", with: "\(duration)") ?? "\(price) FOR \(duration)-DAYS"
//                    }else{
//                        tagLabel.text = plan.tag?.replacingOccurrences(of: "free_trial_duration", with: "\(duration)") ?? "\(duration)-DAY FREE"
//                    }
//                }else{
//                    tagLabel.text = plan.tag ?? " "
//
//                }
//            })
//        }
//        
//        
//    }
//    
//    func calculateSaveLabel(saveLabel : UILabel){
//        
//        guard let plan else { return }
//        
//        if let currentProduct = fetchProduct(for: plan),  let currentPlanPricePerDay = calculatePricePerDay(product: currentProduct){
//            let mostExpensivePlanPricePerDay = getMostExpensivePlanPricePerDay()
//            if currentPlanPricePerDay != mostExpensivePlanPricePerDay{
//                saveLabel.text = calculateSaveRatio(currentPlanPricePerDay: currentPlanPricePerDay, mostExpensivePlanPricePerDay: mostExpensivePlanPricePerDay)
//            }
//        }
//        
//    }
//    
//    func isDefaultPlan() -> Bool{
//        
//        guard let plan else { return false }
//        let defaultSelectedPlanCount =  allPlans.filter({$0.isDefaultSelected}).count
//        
//        if defaultSelectedPlanCount == 0{
//            WarningManager.add(warning: .selectAtLeastOnePlanSelected)
//        }else if defaultSelectedPlanCount > 1{
//            WarningManager.add(warning: .cantMakeMoreThanOnePlanSelected)
//        }
//        
//        if plan.isDefaultSelected{
//           return true
//        }
//        
//        return false
//    }
//}
