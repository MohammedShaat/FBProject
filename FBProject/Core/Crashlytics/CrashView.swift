//
//  CrashView.swift
//  FBProject
//
//  Created by Mohammed on 7/29/26.
//

import FirebaseCrashlytics
import SwiftUI

final class CrashlyticsManager {
    static let shared = CrashlyticsManager()
    
    private let crashlytics = Crashlytics.crashlytics()
    
    private init() {}
    
    func setUserId(userId: String) {
        crashlytics.setUserID(userId)
    }
    
    func setIsPremiumKey(isPremium: Bool) {
        crashlytics.setCustomValue(isPremium, forKey: DBUser.CodingKeys.isPremium.rawValue)
    }
    
    func addLog(message: String) {
        crashlytics.log(message)
    }
    
    func sendNonFatalEvent(error: Error) {
        crashlytics.record(error: error)
    }
}

struct CrashView: View {
    var body: some View {
        VStack(spacing: 30) {
            Button("Force unwrap") {
                CrashlyticsManager.shared.addLog(message: "Clicked on 1st button")
                guard let x = Int("f") else {
                    CrashlyticsManager.shared.sendNonFatalEvent(error: MachError(.failure))
                    return
                }
            }
            
            Button("Fatal error") {
                CrashlyticsManager.shared.addLog(message: "Clicked on 2nd button")
                fatalError("Couldn't locate file in Bundle")
            }
            
            Button("Index error") {
                CrashlyticsManager.shared.addLog(message: "Clicked on 3rd button")
                let array = [1, 2]
                let item = array[2]
            }
        }
        .task {
            guard let userAuth = AuthenticationManager.shared.getUserData() else {
                return
            }
            CrashlyticsManager.shared.setUserId(userId: userAuth.id)
            
            guard let user = try? await UserManager.shared.getUser(id: userAuth.id) else { return }
            CrashlyticsManager.shared.setIsPremiumKey(isPremium: user.isPremium)
            CrashlyticsManager.shared.addLog(message: "CrashView appeard")
        }
    }
}

#Preview {
    CrashView()
}
