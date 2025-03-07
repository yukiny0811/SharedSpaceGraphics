//
//  SharedSpaceScene.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import MetalKit

public protocol SharedSpaceScene: AnyObject {
    
    /// scene id (has to be unique globally)
    static var id: String { get }
    
    /// author for display
    static var author: String { get }
    
    /// scene name for display
    static var sceneName: String { get }
    
    /// used for instance generation from UI
    static func createInstance() -> Self
    
    /// global time normalized (0...1)
    var globalTimeNormalized: Double { get set }
    
    /// called when renderer's composition count changed
    /// write processes that does not want to be called every frame (will be called multiple times during setup task)
    func initialSetup()
    
    /// render process for every function
    /// don't change drawable size
    /// don't commit or finalize commandBuffer
    func render(commandBuffer: MTLCommandBuffer, mainTexture: MTLTexture, depthTexture: MTLTexture, camera: Camera, elapsedInComposition: Double, sceneTransform: f4x4)
    
    // generated by SharedScene Macro
    var ___keyframes_updated_date: Date { get set }
    var ___keyframes_dict: [String: [Keyframe]] { get set }
    var ___keyframes_minMaxDefault_dict: [String: (min: Float, max: Float, def: Float)] { get set }
    func __getOutputList() -> [ConnectionEndpoint]
    func __getInputList() -> [ConnectionEndpoint]
}
