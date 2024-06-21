//
//  NetworkService.swift
//  Desserts
//
//  Created by Shashank  on 6/20/24.
//

import Foundation
import Network

class Network: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = false

    init() {
        checkConnection()
    }
    
    // For Previews only
    init(forPreview: Bool = true) {
        self.connected = true
    }

    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.connected = true
                } else {
                    self.connected = false
                }
            }
        }
        monitor.start(queue: queue)
    }
}
