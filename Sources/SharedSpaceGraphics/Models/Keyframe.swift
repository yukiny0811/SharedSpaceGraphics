//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

@Observable
public class Keyframe: Identifiable, Equatable, Codable {
    
    public var id: String
    public var globalTime: Double
    public var value: Float
    public let minValue: Float
    public let maxValue: Float
    
    public init(id: String, globalTime: Double, value: Float, minValue: Float, maxValue: Float) {
        self.id = id
        self.globalTime = globalTime
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    public static func == (lhs: Keyframe, rhs: Keyframe) -> Bool {
        lhs.id == rhs.id && lhs.globalTime == rhs.globalTime && lhs.value == rhs.value
    }
}
