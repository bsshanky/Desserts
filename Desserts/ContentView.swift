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

//#Preview {
////    let mockNetwork = Network(forPreview: true)
////    
////    var previews: some View {
////            ContentView().environmentObject(mockNetwork)
////
////        }
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView().environmentObject({ () -> Network in
            let mockNetwork = Network(forPreview: true)
            return mockNetwork
        }() )
    }
}
