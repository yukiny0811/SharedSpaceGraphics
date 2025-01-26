//
//  MainRenderer.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import AppKit
import MetalKit
import SwiftUI

@Observable
public class MainRenderer: NSObject, MTKViewDelegate, @unchecked Sendable {
    
    var compositions: [Composition] = []
    @ObservationIgnored var lastFrameCompositionsCount = 0
    var renderingStatus: RenderingStatus = .requestedSetup
    var currentSecondsFromStart: Double = 0
    var videoLength: Double //seconds
    @ObservationIgnored var lastFrameDate: Date? = Date()
    var previewCamera: Camera
    var renderingCamera: Camera
    
    let width: Int
    let height: Int
    public let displayScaleFactor: CGFloat
    
    private let mainTexture: MTLTexture
    private let mainDepthTexture: MTLTexture
    
    public var cameraType: CameraType = .preview
    
    public var eyeXKeyframes: [Keyframe] = []
    public var eyeYKeyframes: [Keyframe] = []
    public var eyeZKeyframes: [Keyframe] = []
    public var lookXKeyFrames: [Keyframe] = []
    public var lookYKeyFrames: [Keyframe] = []
    public var lookZKeyFrames: [Keyframe] = []
    public var upXKeyFrames: [Keyframe] = []
    public var upYKeyFrames: [Keyframe] = []
    public var upZKeyFrames: [Keyframe] = []
    
    init(width: Int, height: Int, displayScaleFactor: CGFloat, videoLength: Double) {
        self.width = width
        self.height = height
        self.displayScaleFactor = displayScaleFactor
        self.videoLength = videoLength
        self.previewCamera = Camera(frameWidth: Float(width), frameHeight: Float(height))
        self.renderingCamera = Camera(frameWidth: Float(width), frameHeight: Float(height))
        self.mainTexture = TextureUtils.create(width: width, height: height, pixelFormat: .bgra8Unorm, label: "mainTexture", isRenderTarget: true)
        self.mainDepthTexture = TextureUtils.create(width: width, height: height, pixelFormat: .depth32Float_stencil8, label: "mainDepthTexture", isRenderTarget: true)
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            print("no drawable")
            lastFrameDate = nil
            return
        }
        if renderingStatus == .requestedSetup {
            renderingStatus = .settingUp
            setup()
            print("requested setup")
            lastFrameDate = nil
            return
        }
        if renderingStatus == .exporting {
            print("exporting")
            lastFrameDate = nil
            return
        }
        guard compositions.count == lastFrameCompositionsCount else {
            renderingStatus = .requestedSetup
            print("count changed")
            lastFrameDate = nil
            return
        }
        guard renderingStatus == .rendering || renderingStatus == .paused else {
            print("not rendering or paused mode")
            lastFrameDate = nil
            return
        }
        if renderingStatus != .paused {
            if let lastFrameDate {
                currentSecondsFromStart += Date().timeIntervalSince(lastFrameDate)
            }
            if currentSecondsFromStart > videoLength {
                currentSecondsFromStart = 0
                return
            }
        }
        self.lastFrameDate = Date()
        view.drawableSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
    
        draw(view: view, drawable: drawable)
    }
    
    func addScene(_ sceneType: any SharedSpaceScene.Type) {
        let instance = sceneType.createInstance()
        let newComposition = Composition(scene: instance, startTime: 0, length: 10)
        newComposition.sceneName = sceneType.sceneName
        newComposition.sceneUniqueId = sceneType.id
        compositions.append(newComposition)
    }
    
    func removeScene(id: String) {
        compositions.removeAll { $0.id == id }
    }
    
    func setup() {
        for composition in compositions {
            composition.scene.initialSetup()
        }
        lastFrameCompositionsCount = compositions.count
        renderingStatus = .paused
    }
    
    func seekTo(secondsFromStart: Double) {
        currentSecondsFromStart = min(videoLength, max(0, secondsFromStart))
    }
    
    func pause() {
        if renderingStatus != .settingUp {
            renderingStatus = .paused
        }
    }
    
    func play() {
        if renderingStatus != .settingUp {
            renderingStatus = .rendering
        }
    }
    
    @MainActor
    public func draw(view: MTKView, drawable: CAMetalDrawable) {
        let commandBuffer = Library.commandQueue.makeCommandBuffer()!
        
        let renderPassDesc = MTLRenderPassDescriptor()
        renderPassDesc.colorAttachments[0].texture = mainTexture
        renderPassDesc.colorAttachments[0].loadAction = .clear
        renderPassDesc.colorAttachments[0].storeAction = .store
        renderPassDesc.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDesc.depthAttachment.texture = mainDepthTexture
        renderPassDesc.depthAttachment.loadAction = .clear
        renderPassDesc.depthAttachment.storeAction = .store
        renderPassDesc.depthAttachment.clearDepth = 1.0
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc)!
        encoder.endEncoding()
        
        for composition in compositions {
            composition.scene.globalTimeNormalized = currentSecondsFromStart / videoLength
            if composition.startTime < currentSecondsFromStart && currentSecondsFromStart < composition.startTime + composition.length && composition.eyesOpen {
                let portion = (currentSecondsFromStart - composition.startTime) / composition.length
                composition.sceneTransformUpdate(globalTimeNormalized: currentSecondsFromStart / videoLength)
                switch cameraType {
                case .preview:
                    composition.scene.render(commandBuffer: commandBuffer, mainTexture: mainTexture, depthTexture: mainDepthTexture, camera: previewCamera, elapsedInComposition: portion, sceneTransform: composition.transform)
                case .rendering:
                    let globalTimeNormalized = currentSecondsFromStart / videoLength
                    let eyeXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeXKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let eyeYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeYKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let eyeZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeZKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let lookXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookXKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let lookYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookYKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let lookZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookZKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1.0)
                    let upXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upXKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    let upYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upYKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1.0)
                    let upZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upZKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
                    
                    renderingCamera.setLookAt(
                        eye: f3(eyeXInterpolated, eyeYInterpolated, eyeZInterpolated),
                        center: f3(lookXInterpolated, lookYInterpolated, lookZInterpolated),
                        up: f3(upXInterpolated, upYInterpolated, upZInterpolated)
                    )
                    composition.scene.render(commandBuffer: commandBuffer, mainTexture: mainTexture, depthTexture: mainDepthTexture, camera: renderingCamera, elapsedInComposition: portion, sceneTransform: composition.transform)
                }
            }
        }
        
        let resizeEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)!
        resizeEncoder.setRenderPipelineState(Library.resizePipelineState)
        resizeEncoder.setFragmentTexture(mainTexture, index: 0)
        resizeEncoder.setCullMode(.none)
        resizeEncoder.setVertexBytes(
            [
                ResizeVertex(position: f3(-1,-1, 0), uv: f2(0, 1)).cObject,
                ResizeVertex(position: f3(-1, 1, 0), uv: f2(0, 0)).cObject,
                ResizeVertex(position: f3(1 ,-1, 0), uv: f2(1, 1)).cObject,
                ResizeVertex(position: f3(1 ,-1, 0), uv: f2(1, 1)).cObject,
                ResizeVertex(position: f3(-1, 1, 0), uv: f2(0, 0)).cObject,
                ResizeVertex(position: f3(1 , 1, 0), uv: f2(1, 0)).cObject,
            ],
            length: 32 * 6,
            index: 0
        )
        resizeEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        resizeEncoder.endEncoding()
        
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    public func drawForExport(globalTimeForExport: Double, exportTexture: MTLTexture, exportDepthTexture: MTLTexture) {
        let commandBuffer = Library.commandQueue.makeCommandBuffer()!
        
        let renderPassDesc = MTLRenderPassDescriptor()
        renderPassDesc.colorAttachments[0].texture = exportTexture
        renderPassDesc.colorAttachments[0].loadAction = .clear
        renderPassDesc.colorAttachments[0].storeAction = .store
        renderPassDesc.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        renderPassDesc.depthAttachment.texture = exportDepthTexture
        renderPassDesc.depthAttachment.loadAction = .clear
        renderPassDesc.depthAttachment.storeAction = .store
        renderPassDesc.depthAttachment.clearDepth = 1.0
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDesc)!
        encoder.endEncoding()
        
        let globalTimeNormalized = globalTimeForExport / videoLength
        let eyeXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeXKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let eyeYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeYKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let eyeZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: eyeZKeyframes, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let lookXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookXKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let lookYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookYKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let lookZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: lookZKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1.0)
        let upXInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upXKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        let upYInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upYKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 1.0)
        let upZInterpolated = InterpolationUtils.calculateInterpolated(keyframes: upZKeyFrames, globalTimeNormalized: globalTimeNormalized, defaultValue: 0.0)
        
        renderingCamera.setLookAt(
            eye: f3(eyeXInterpolated, eyeYInterpolated, eyeZInterpolated),
            center: f3(lookXInterpolated, lookYInterpolated, lookZInterpolated),
            up: f3(upXInterpolated, upYInterpolated, upZInterpolated)
        )
        
        for composition in compositions {
            composition.scene.globalTimeNormalized = globalTimeForExport / videoLength
            if composition.startTime < globalTimeForExport && globalTimeForExport < composition.startTime + composition.length && composition.eyesOpen {
                let portion = (globalTimeForExport - composition.startTime) / composition.length
                composition.sceneTransformUpdate(globalTimeNormalized: globalTimeForExport / videoLength)
                composition.scene.render(commandBuffer: commandBuffer, mainTexture: exportTexture, depthTexture: exportDepthTexture, camera: renderingCamera, elapsedInComposition: portion, sceneTransform: composition.transform)
            }
        }
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
    
    public func onDrag(mousePos: f2, delta: f2) {
        let delta = delta * -1
        if cameraType == .preview {
            let rotateSpeed: Float = 0.01
            let yaw = delta.x * rotateSpeed
            let pitch = delta.y * rotateSpeed
            
            let eye = previewCamera.eye
            let center = previewCamera.center
            let up = previewCamera.up
            
            let forward = center - eye
            let right = simd_normalize(simd_cross(forward, up))
            
            let yawQuat = simd_quatf(angle: yaw, axis: up)
            let pitchQuat = simd_quatf(angle: pitch, axis: right)
            let rotation = yawQuat * pitchQuat
            let newForward = rotation.act(forward)
            let newUp = rotation.act(up)
            let newCenter = eye + newForward
            
            previewCamera.setLookAt(eye: eye, center: newCenter, up: newUp)
        }
    }
    
    public func onScroll(delta: f2) {
        if cameraType == .preview {
            let diff = delta.x * 0.1
            let direction = previewCamera.center - previewCamera.eye
            let moving = direction * diff
            previewCamera.setLookAt(eye: previewCamera.eye + moving, center: previewCamera.center + moving, up: previewCamera.up)
        }
    }
    
    public func rollCamera(clockwiseAngleDelta: Float) {
        if cameraType == .preview {
            // 現在のカメラ パラメータを取得
            let eye = previewCamera.eye
            let center = previewCamera.center
            let up = previewCamera.up
            
            // カメラが見ている前方向（forward）を計算
            let forward = center - eye
            let forwardNormalized = simd_normalize(forward)
            
            // ロール回転用のクォータニオンを作成
            //   “forward” 方向軸で "clockwiseAngleDelta" 回転
            let rollQuat = simd_quatf(angle: clockwiseAngleDelta,
                                      axis: forwardNormalized)
            
            // upベクトルを回転させる
            let newUp = rollQuat.act(up)
            
            // eye と center はそのまま、up だけ更新してLookAtを再セット
            previewCamera.setLookAt(eye: eye, center: center, up: newUp)
        }
    }
    
    public func moveCamera(deltaInScreen: f2) {
        if cameraType == .preview {
            let eye = previewCamera.eye
            let center = previewCamera.center
            let up = previewCamera.up
            
            let moveSpeed: Float = 0.01
            let forward = center - eye
            let right = simd_normalize(simd_cross(forward, up))
            let offset = (right * deltaInScreen.x + up * deltaInScreen.y) * moveSpeed
            let newEye = eye + offset
            let newCenter = center + offset
            
            previewCamera.setLookAt(eye: newEye, center: newCenter, up: up)
        }
    }
}

