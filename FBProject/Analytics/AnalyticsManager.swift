//
//  AnalyticsManager.swift
//  FBProject
//
//  Created by Mohammed on 7/29/26.
//

import FirebaseAnalytics
import Foundation


final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func serUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func log(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    func setUserProperty(value: String?, for name: String) {
        Analytics.setUserProperty(value, forName: name)
    }
}
