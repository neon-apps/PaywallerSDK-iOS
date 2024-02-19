//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 16.02.2024.
//

import Foundation

public class WarningManager{
    
    public enum Warning{
        case addAtLeast2ItemsToUseTimeline
        case cantShowMonthlyPriceForWeeklySubscription
        case cantMakeMoreThanOnePlanSelected
        case selectAtLeastOnePlanSelected
    }
    
    public static var warnings = [Warning]()
    
    static func addWarning(warning : Warning){
        if !warnings.contains(warning){
            warnings.append(warning)
        }
    }
}
