//
//  NetworkMonitor.swift
//  MobileUpGallery
//
//  Created by Emir Nasyrov on 19.08.2024.
//

import Foundation
import Network

final class NetworkMonitor {
    // MARK: - Variables
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    public var isConnected: Bool = false
    public var connectionType: ConnectionType?
    
    enum ConnectionType {
        case wifi
        case cellular
        case unknown
    }
    // MARK: - Lifecycle
    private init() {
        monitor = NWPathMonitor()
    }
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    public func stopMonitoring() {
        monitor.cancel()
    }
    private func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        } else  {
            connectionType = .unknown
        }
    }
    
    
}
