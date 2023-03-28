//
//  PacketTunnelProvider.swift
//  SupperVPNTunnel
//
//  Created by 袁平华 on 2023/3/28.
//

import Foundation
import TunnelKitOpenVPNAppExtension

class PacketTunnelProvider: OpenVPNTunnelProvider {
    override func startTunnel(options: [String : NSObject]? = nil) async throws {
        dataCountInterval = 3
        try await super.startTunnel(options: options)
    }
}

