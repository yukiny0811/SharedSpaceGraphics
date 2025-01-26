//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/25.
//


public actor InterpolationUtils {
    public static func calculateInterpolated(keyframes: [Keyframe], globalTimeNormalized: Double, defaultValue: Float) -> Float {
        let sortedKeyframes = keyframes.sorted { kf1, kf2 in
            kf1.globalTime < kf2.globalTime
        }
        var closestKeyBefore: Keyframe?
        var closestKeyAfter: Keyframe?
        for (i, kf) in sortedKeyframes.enumerated() {
            if globalTimeNormalized < kf.globalTime && i == 0 {
                closestKeyAfter = kf
                break
            }
            if kf.globalTime < globalTimeNormalized && i == sortedKeyframes.count - 1 {
                closestKeyBefore = kf
                break
            }
            if kf.globalTime < globalTimeNormalized && globalTimeNormalized < sortedKeyframes[i+1].globalTime {
                closestKeyBefore = kf
                closestKeyAfter = sortedKeyframes[i+1]
                break
            }
        }
        if let closestKeyBefore {
            if let closestKeyAfter {
                let interpolationTime = (globalTimeNormalized - closestKeyBefore.globalTime) / (closestKeyAfter.globalTime - closestKeyBefore.globalTime)
                let interpolated = interpolate(v1: closestKeyBefore.value, v2: closestKeyAfter.value, t: Float(interpolationTime))
                return interpolated
            } else {
                return closestKeyBefore.value
            }
        } else if let closestKeyAfter {
            return closestKeyAfter.value
        } else {
            return defaultValue
        }
    }
    
    public static func interpolate(v1: Float, v2: Float, t: Float) -> Float {
//        return v1 + (v2 - v1) * t
        return EasingFunctions.easeInOut(v1: v1, v2: v2, t: t)
    }
}
