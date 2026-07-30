//
//  PerformanceManager.swift
//  FBProject
//
//  Created by Mohammed on 7/29/26.
//

import Foundation
import FirebasePerformance

final class PerformanceManager {
    
    private var trace: Trace?
    private let name: String
    
    init(name: String) {
        self.name = name
    }
    
    func start() {
        trace = Performance.startTrace(name: name)
    }
    
    func stop() {
        trace?.stop()
    }
    
    func addLog(value: String, for attribute: String) {
        trace?.setValue(value, forAttribute: attribute)
    }
}
