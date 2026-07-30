//
//  PerformanceView.swift
//  FBProject
//
//  Created by Mohammed on 7/29/26.
//

import SwiftUI
import FirebasePerformance

struct PerformanceView: View {
    var body: some View {
        Text("Performance!")
            .task {
                await loadProducts()
            }
    }
    
    func loadProducts() async {
        
        let urlStr = "https://dummyjson.com/products"
        
        guard let url = URL(string: urlStr),
            let metric = HTTPMetric(url: url, httpMethod: .get) else { return }
        
        
        do {
            metric.start()

            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let response = response as? HTTPURLResponse {
                metric.responseCode = response.statusCode
            }

            metric.stop()
            
            print(data)
        } catch {
            print("Failed to load products:\n", error)
        }
    }
}

#Preview {
    PerformanceView()
}
