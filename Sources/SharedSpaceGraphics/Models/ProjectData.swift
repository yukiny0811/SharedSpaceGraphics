//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import Foundation

public struct ProjectData: Codable {
    
    public var compositions: [CompositionCodable]
    
    public var videoLength: Double
    public var width: Int
    public var height: Int
    public var displayScaleFactor: CGFloat
    
    public var eyeXKeyframes: [Keyframe]
    public var eyeYKeyframes: [Keyframe]
    public var eyeZKeyframes: [Keyframe]
    public var lookXKeyFrames: [Keyframe]
    public var lookYKeyFrames: [Keyframe]
    public var lookZKeyFrames: [Keyframe]
    public var upXKeyFrames: [Keyframe]
    public var upYKeyFrames: [Keyframe]
    public var upZKeyFrames: [Keyframe]
}

public struct CompositionCodable: Codable {
    public var id: String
    public var scene: SceneCodable
    public var startTime: Double
    public var length: Double
    public var transform: f4x4
    public var eyesOpen = true
    public var positionXKeyframes: [Keyframe]
    public var positionYKeyframes: [Keyframe]
    public var positionZKeyframes: [Keyframe]
    public var rotationXKeyframes: [Keyframe]
    public var rotationYKeyframes: [Keyframe]
    public var rotationZKeyframes: [Keyframe]
    public var scaleXKeyFrames: [Keyframe]
    public var scaleYKeyFrames: [Keyframe]
    public var scaleZKeyFrames: [Keyframe]
    public var name: String
    public var sceneName: String
    public var sceneUniqueId: String
}

public struct SceneCodable: Codable {
    public var ___keyframes_dict: [String: [Keyframe]]
    public var ___keyframes_minMaxDefault_dict: [String: MinMaxDef]
}

public struct MinMaxDef: Codable {
    public var min: Float
    public var max: Float
    public var def: Float
}
