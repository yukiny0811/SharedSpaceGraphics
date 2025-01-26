//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

public class ConnectionEndpoint: Identifiable, Hashable, Equatable {
    
    public let id: String
    public var value: Float?
    public var targetEndpoint: ConnectionEndpoint? = nil
    public var name: String
    
    public init(id: String, value: Float?, name: String) {
        self.id = id
        self.value = value
        self.name = name
    }
    
    public static func == (lhs: ConnectionEndpoint, rhs: ConnectionEndpoint) -> Bool {
        lhs.id == rhs.id && lhs.value == rhs.value && lhs.targetEndpoint == rhs.targetEndpoint && lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value)
        hasher.combine(targetEndpoint)
        hasher.combine(name)
    }
}
