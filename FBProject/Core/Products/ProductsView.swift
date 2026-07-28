//
//  ProductsView.swift
//  FBProject
//
//  Created by Mohammed on 7/26/26.
//

import SwiftUI

struct ProductsView: View {
    @State private var viewModel = ProductsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductItemView(product: product)
                    .contextMenu(menuItems: {
                        Button("Add to favorites") {
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
