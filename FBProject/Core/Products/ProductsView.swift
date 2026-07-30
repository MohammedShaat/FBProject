//
//  ProductsView.swift
//  FBProject
//
//  Created by Mohammed on 7/26/26.
//

import SwiftUI
import FirebaseAnalytics

struct ProductsView: View {
    @State private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductItemView(product: product)
                    .contextMenu(menuItems: {
                        Button("Add to favorites") {
                            AnalyticsManager.shared.log(name: "favorite_clicked")
                            viewModel.addProductToFavorites(id: String(product.id))
                        }
                    })
                    .onAppear {
                        if product == viewModel.products.last {
                            viewModel.getProducts()
                        }
                    }
            }
            
            if viewModel.loading {
                ProgressView()
                    .id(UUID())
                    .tint(.blue)
                    .frame(maxWidth: .infinity)
            }
        }
        .onAppear(perform: viewModel.getProducts)
        .navigationTitle("Products")
        .analyticsScreen(name: "ProductsView")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                let binding = Binding {
                    viewModel.sortOption
                } set: { newValue in
                    viewModel.getProductsSorted(by: newValue)
                }

                Menu("Sort products by", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort products by", selection: binding) {
                        ForEach(SortOptions.allCases, id: \.self) { option in
                            HStack {
                                Text(option.rawValue.capitalized)
                                
                                if viewModel.sortOption == option && option != .defaultOrder {
                                    Image(systemName: viewModel.descending
                                          ? "arrow.down"
                                          : "arrow.up")
                                }
                            }
                        }
                    }
                    .onChange(of: viewModel.sortOption) {
                        AnalyticsManager.shared.log(name: "sort_option", parameters: [
                            "option": viewModel.sortOption.rawValue
                        ])
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                let binding = Binding {
                    viewModel.filterOption
                } set: { newValue in
                    viewModel.getProductsFitlered(by: newValue)
                }

                Menu("Filter products by", systemImage: "line.3.horizontal.decrease") {
                    Picker("Filter products by", selection: binding) {
                        ForEach(CategoryOptions.allCases, id: \.self) { option in
                            Text(option.rawValue.capitalized)
                        }	
                    }
                    .onChange(of: viewModel.filterOption) {
                        AnalyticsManager.shared.log(name: "filter_option", parameters: [
                            "option": viewModel.filterOption.rawValue
                        ])
                    }
                }
            }
        }
    }
}



#Preview {
    NavigationStack {
        ProductsView()
    }
}
