//
//  ContentView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import SwiftUI
import SwiftUITooltip

public struct MainEditorView: View {
    
    @State var tooltipManager = TooltipManager()
    public let projectDirectory: URL
    
    @StateObject var exportManager = ExportManager()
    
    @State var renderer: MainRenderer
    @State var timelineWidth: CGFloat = 2000
    
    let sceneLibrary: [SharedSpaceScene.Type]
    let frameWidth: Int
    let frameHeight: Int
    let displayScaleFactor: CGFloat
    
    let leftPanelMinWidth: CGFloat = 500
    let bottomPanelMinHeight: CGFloat = 400
    
    public init(width: Int, height: Int, displayScaleFactor: CGFloat, videoLength: Double, projectDirectoryURL: URL, scenes: [SharedSpaceScene.Type]) {
        
        self.sceneLibrary = scenes
        self.frameWidth = width
        self.frameHeight = height
        self.displayScaleFactor = displayScaleFactor
        self.projectDirectory = projectDirectoryURL
        self._renderer = .init(
            initialValue: MainRenderer(
                width: width,
                height: height,
                displayScaleFactor: displayScaleFactor,
                videoLength: videoLength
            )
        )
        
        if let saveData = try? Data(contentsOf: projectDirectoryURL.appending(path: "projectData.json")), let decoded = try? JSONDecoder().decode(ProjectData.self, from: saveData) {
            print(decoded.eyeXKeyframes)
            self.renderer.eyeXKeyframes = decoded.eyeXKeyframes
            self.renderer.eyeYKeyframes = decoded.eyeYKeyframes
            self.renderer.eyeZKeyframes = decoded.eyeZKeyframes
            self.renderer.lookXKeyFrames = decoded.lookXKeyFrames
            self.renderer.lookYKeyFrames = decoded.lookYKeyFrames
            self.renderer.lookZKeyFrames = decoded.lookZKeyFrames
            self.renderer.upXKeyFrames = decoded.upXKeyFrames
            self.renderer.upYKeyFrames = decoded.upYKeyFrames
            self.renderer.upZKeyFrames = decoded.upZKeyFrames
            for c in decoded.compositions {
                var newScene: SharedSpaceScene!
                for library in sceneLibrary {
                    if library.id == c.sceneUniqueId {
                        
                        var mappedMMD: [String: (Float, Float, Float)] = [:]
                        for key in c.scene.___keyframes_minMaxDefault_dict.keys {
                            let v = c.scene.___keyframes_minMaxDefault_dict[key]!
                            mappedMMD[key] = (v.min, v.max, v.def)
                        }
                        
                        newScene = library.createInstance()
                        newScene.initialSetup()
                        newScene.___keyframes_dict = c.scene.___keyframes_dict
                        newScene.___keyframes_minMaxDefault_dict = mappedMMD
                    }
                }
                let newComposition = Composition(
                    id: c.id,
                    scene: newScene,
                    startTime: c.startTime,
                    length: c.length
                )
                newComposition.transform = c.transform
                newComposition.eyesOpen = c.eyesOpen
                newComposition.positionXKeyframes = c.positionXKeyframes
                newComposition.positionYKeyframes = c.positionYKeyframes
                newComposition.positionZKeyframes = c.positionZKeyframes
                newComposition.rotationXKeyframes = c.rotationXKeyframes
                newComposition.rotationYKeyframes = c.rotationYKeyframes
                newComposition.rotationZKeyframes = c.rotationZKeyframes
                newComposition.scaleXKeyFrames = c.scaleXKeyFrames
                newComposition.scaleYKeyFrames = c.scaleYKeyFrames
                newComposition.scaleZKeyFrames = c.scaleZKeyFrames
                newComposition.name = c.name
                newComposition.sceneName = c.sceneName
                newComposition.sceneUniqueId = c.sceneUniqueId
                self.renderer.compositions.append(newComposition)
            }
        } else {
            print("no savedata")
        }
    }
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
                VStack(spacing: 3) {
                    HStack(spacing: 3) {
                        SceneLibraryList(sceneLibrary: sceneLibrary, renderer: renderer)
                            .frame(height: CGFloat(frameHeight) * displayScaleFactor)
                            .frame(minWidth: leftPanelMinWidth)
                        VStack(spacing: 0) {
                            MainShaderView(renderer: renderer)
                                .frame(width: CGFloat(frameWidth) * displayScaleFactor, height: CGFloat(frameHeight) * displayScaleFactor)
                        }
                        .frame(width: CGFloat(frameWidth) * displayScaleFactor, height: CGFloat(frameHeight) * displayScaleFactor)
                        .background(.black)
                        .border("222222".color, width: 3)
                    }
                    ControlBarView(renderer: renderer, exportManager: exportManager, projDirURL: projectDirectory)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background("222222".color)
                    EditorTimelineView(
                        renderer: renderer,
                        timelineWidth: $timelineWidth,
                        geometryProxy: geometryProxy,
                        bottomPanelMinHeight: bottomPanelMinHeight
                    )
                    .frame(minHeight: bottomPanelMinHeight)
                }
                .environment(tooltipManager)
            }
            .frame(minWidth: CGFloat(frameWidth) * displayScaleFactor + leftPanelMinWidth, minHeight: CGFloat(frameHeight) * displayScaleFactor + bottomPanelMinHeight)
        }
        .background(.black)
        .tint(.mint)
        .onKeyPress(phases: [.down, .repeat]) { press in
            print(press.key)
            return handleKeyPressCamera(press: press)
        }
    }
    
    func handleKeyPressCamera(press: KeyPress) -> KeyPress.Result {
        switch press.key {
        case "a":
            renderer.moveCamera(deltaInScreen: f2(-20, 0))
        case "A":
            renderer.moveCamera(deltaInScreen: f2(-1, 0))
        case "d":
            renderer.moveCamera(deltaInScreen: f2(20, 0))
        case "D":
            renderer.moveCamera(deltaInScreen: f2(1, 0))
        case "w":
            renderer.moveCamera(deltaInScreen: f2(0, 20))
        case "W":
            renderer.moveCamera(deltaInScreen: f2(0, 1))
        case "s":
            renderer.moveCamera(deltaInScreen: f2(0, -20))
        case "S":
            renderer.moveCamera(deltaInScreen: f2(0, -1))
        case "q":
            renderer.rollCamera(clockwiseAngleDelta: -0.2)
        case "Q":
            renderer.rollCamera(clockwiseAngleDelta: -0.01)
        case "e":
            renderer.rollCamera(clockwiseAngleDelta: 0.2)
        case "E":
            renderer.rollCamera(clockwiseAngleDelta: 0.01)
        case "\u{1B}":
            tooltipManager.showingKeyframe = nil
        case " ":
            if renderer.renderingStatus == .paused {
                renderer.play()
            } else {
                renderer.pause()
            }
        case ",":
            renderer.seekTo(secondsFromStart: renderer.currentSecondsFromStart - 10)
        case ".":
            renderer.seekTo(secondsFromStart: renderer.currentSecondsFromStart + 10)
        case "\u{7F}":
            if let showingKeyframe = tooltipManager.showingKeyframe {
                if removeKf(from: &renderer.eyeXKeyframes, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.eyeYKeyframes, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.eyeZKeyframes, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.lookXKeyFrames, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.lookYKeyFrames, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.lookZKeyFrames, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.upXKeyFrames, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.upYKeyFrames, kfToRemove: showingKeyframe) { break }
                if removeKf(from: &renderer.upZKeyFrames, kfToRemove: showingKeyframe) { break }
                for composition in renderer.compositions {
                    if removeKf(from: &composition.positionXKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.positionYKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.positionZKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.rotationXKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.rotationYKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.rotationZKeyframes, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.scaleXKeyFrames, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.scaleYKeyFrames, kfToRemove: showingKeyframe) { break }
                    if removeKf(from: &composition.scaleZKeyFrames, kfToRemove: showingKeyframe) { break }
                    for key in composition.scene.___keyframes_dict.keys {
                        if removeKf(from: &composition.scene.___keyframes_dict[key]!, kfToRemove: showingKeyframe) { break }
                    }
                }
            }
        case "\r":
            renderer.seekTo(secondsFromStart: 0)
            renderer.renderingStatus = .requestedSetup
        default:
            return .ignored
        }
        return .ignored
    }
    
    func removeKf(from keyframes: inout [Keyframe], kfToRemove: Keyframe) -> Bool {
        for kf in keyframes {
            if kf == kfToRemove {
                keyframes.removeAll { $0 == kf }
                return true
            }
        }
        return false
    }
}
