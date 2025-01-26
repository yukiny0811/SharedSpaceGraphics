//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI
import simd

@Observable
public class Composition: Identifiable {
    public let id: String
    public let scene: any SharedSpaceScene
    public var startTime: Double
    public var length: Double
    public var transform: f4x4 = .createIdentity()
    public var eyesOpen = true
    public var positionXKeyframes: [Keyframe] = []
    public var positionYKeyframes: [Keyframe] = []
    public var positionZKeyframes: [Keyframe] = []
    public var rotationXKeyframes: [Keyframe] = []
    public var rotationYKeyframes: [Keyframe] = []
    public var rotationZKeyframes: [Keyframe] = []
    public var scaleXKeyFrames: [Keyframe] = []
    public var scaleYKeyFrames: [Keyframe] = []
    public var scaleZKeyFrames: [Keyframe] = []
    public var name: String = "" // user defined
    public var sceneName: String = ""
    public var sceneUniqueId: String = ""
    
    public func sceneTransformUpdate(globalTimeNormalized: Double) {
        let interpolatedXPosition = InterpolationUtils.calculateInterpolated(keyframes: positionXKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedYPosition = InterpolationUtils.calculateInterpolated(keyframes: positionYKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedZPosition = InterpolationUtils.calculateInterpolated(keyframes: positionZKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedXRotation = InterpolationUtils.calculateInterpolated(keyframes: rotationXKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedYRotation = InterpolationUtils.calculateInterpolated(keyframes: rotationYKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedZRotation = InterpolationUtils.calculateInterpolated(keyframes: rotationZKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0)
        let interpolatedXScale = InterpolationUtils.calculateInterpolated(keyframes: scaleXKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1)
        let interpolatedYScale = InterpolationUtils.calculateInterpolated(keyframes: scaleYKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1)
        let interpolatedZScale = InterpolationUtils.calculateInterpolated(keyframes: scaleZKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1)
        self.transform = f4x4.createTranslation(interpolatedXPosition, interpolatedYPosition, interpolatedZPosition)
        * f4x4.createRotation(angle: interpolatedXRotation, axis: f3(1, 0, 0))
        * f4x4.createRotation(angle: interpolatedYRotation, axis: f3(0, 1, 0))
        * f4x4.createRotation(angle: interpolatedZRotation, axis: f3(0, 0, 1))
        * f4x4.createScale(interpolatedXScale, interpolatedYScale, interpolatedZScale)
    }
    
    public init(id: String = UUID().uuidString, scene: any SharedSpaceScene, startTime: Double, length: Double) {
        self.id = id
        self.scene = scene
        self.startTime = startTime
        self.length = length
    }
}
