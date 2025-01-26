//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import Foundation

enum EasingFunctions {
    static func easeInOut(v1: Float, v2: Float, t: Float) -> Float {
        let clampedT = max(0, min(t, 1))
        let delta = v2 - v1
        if clampedT < 0.5 {
            return v1 + (delta * 4 * clampedT * clampedT * clampedT)
        } else {
            let f = 2 * clampedT - 2
            return v1 + (delta * (0.5 * f * f * f + 1))
        }
    }
}
