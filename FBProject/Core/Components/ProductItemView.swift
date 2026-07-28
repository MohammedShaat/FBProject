//
//  ProductItemView.swift
//  FBProject
//
//  Created by Mohammed on 7/27/26.
//


import SwiftUI

struct ProductItemView: View {
    let product: Product
    
    var body: some View {
        HStack {
            if let thumbnail = product.thumbnail {
                AsyncImage(url: URL(string: thumbnail)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 75, height: 75)
                .background(.white)
                .clipShape(.rect(cornerRadius: 10))
                .shadow(radius: 5)
            }
            
            VStack(alignment: .leading) {
                Text(product.title ?? "n/a")
                    .font(.headline)
                Group {
                    Text("Pirce: \((product.price ?? 0).formatted(.currency(code: "USD")))")
                    Text("Rating: \((product.rating ?? 0).formatted(.number))")
                    Text("Category: \(product.category ?? "n/a")")
                    Text("Brand: \(product.brand ?? "n/a")")
                }
                .foregroundStyle(.secondary)
            }
        }
    }
}
