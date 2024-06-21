//
//  ContentView.swift
//  Desserts
//
//  Created by Shashank  on 6/17/24.
//

import SwiftUI

struct ContentView: View {

    @StateObject var network = Network()
    @State var visibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedDessert: Dessert?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $visibility,
            sidebar: {
                DessertListView(selectedDessert: $selectedDessert)
                    .environmentObject(network)
            }, detail: {
                DessertDetailView(selectedDessert: $selectedDessert)
                    .environmentObject(network)
            }
        )
    }
}

#Preview {
    ContentView()
}
