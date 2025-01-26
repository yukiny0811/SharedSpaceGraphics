//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import Foundation

enum SaveManager {
    static func save(renderer: MainRenderer, projDirURL: URL) {
        let compositions: [CompositionCodable] = renderer.compositions.map { c in
            var minMaxDefDict: [String: MinMaxDef] = [:]
            for key in c.scene.___keyframes_minMaxDefault_dict.keys {
                let value = c.scene.___keyframes_minMaxDefault_dict[key]!
                let mmd = MinMaxDef(min: value.min, max: value.max, def: value.def)
                minMaxDefDict[key] = mmd
            }
            return CompositionCodable(
                id: c.id,
                scene: SceneCodable(
                    ___keyframes_dict: c.scene.___keyframes_dict,
                    ___keyframes_minMaxDefault_dict: minMaxDefDict
                ),
                startTime: c.startTime,
                length: c.length,
                transform: c.transform,
                positionXKeyframes: c.positionXKeyframes,
                positionYKeyframes: c.positionYKeyframes,
                positionZKeyframes: c.positionZKeyframes,
                rotationXKeyframes: c.rotationXKeyframes,
                rotationYKeyframes: c.rotationYKeyframes,
                rotationZKeyframes: c.rotationZKeyframes,
                scaleXKeyFrames: c.scaleXKeyFrames,
                scaleYKeyFrames: c.scaleYKeyFrames,
                scaleZKeyFrames: c.scaleZKeyFrames,
                name: c.name,
                sceneName: c.sceneName,
                sceneUniqueId: c.sceneUniqueId
            )
        }
        let data = ProjectData(
            compositions: compositions,
            videoLength: renderer.videoLength,
            width: renderer.width,
            height: renderer.height,
            displayScaleFactor: renderer.displayScaleFactor,
            eyeXKeyframes: renderer.eyeXKeyframes,
            eyeYKeyframes: renderer.eyeYKeyframes,
            eyeZKeyframes: renderer.eyeZKeyframes,
            lookXKeyFrames: renderer.lookXKeyFrames,
            lookYKeyFrames: renderer.lookYKeyFrames,
            lookZKeyFrames: renderer.lookZKeyFrames,
            upXKeyFrames: renderer.upXKeyFrames,
            upYKeyFrames: renderer.upYKeyFrames,
            upZKeyFrames: renderer.upZKeyFrames
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let encodedData = try! encoder.encode(data)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        try! jsonString.write(to: projDirURL.appending(path: "projectData.json"), atomically: true, encoding: .utf8)
    }
}
