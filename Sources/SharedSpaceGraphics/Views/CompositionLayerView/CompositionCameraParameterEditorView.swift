//
//  CompositionParameterEditorView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionCameraParameterEditorView: View {
    
    let timelineWidth: CGFloat
    let renderer: MainRenderer
    let geometryProxy: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CompositionParameterKeyframeEditorView(
                title: "Eye X",
                keyframes: Binding {
                    renderer.eyeXKeyframes
                } set: { newValue in
                    renderer.eyeXKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Eye Y",
                keyframes: Binding {
                    renderer.eyeYKeyframes
                } set: { newValue in
                    renderer.eyeYKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Eye Z",
                keyframes: Binding {
                    renderer.eyeZKeyframes
                } set: { newValue in
                    renderer.eyeZKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            
            CompositionParameterKeyframeEditorView(
                title: "LookAtCenter X",
                keyframes: Binding {
                    renderer.lookXKeyFrames
                } set: { newValue in
                    renderer.lookXKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "LookAtCenter Y",
                keyframes: Binding {
                    renderer.lookYKeyFrames
                } set: { newValue in
                    renderer.lookYKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "LookAtCenter Z",
                keyframes: Binding {
                    renderer.lookZKeyFrames
                } set: { newValue in
                    renderer.lookZKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 1,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            
            CompositionParameterKeyframeEditorView(
                title: "Up Vector X",
                keyframes: Binding {
                    renderer.upXKeyFrames
                } set: { newValue in
                    renderer.upXKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            
            CompositionParameterKeyframeEditorView(
                title: "Up Vector Y",
                keyframes: Binding {
                    renderer.upYKeyFrames
                } set: { newValue in
                    renderer.upYKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 1,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            
            CompositionParameterKeyframeEditorView(
                title: "Up Vector Z",
                keyframes: Binding {
                    renderer.upZKeyFrames
                } set: { newValue in
                    renderer.upZKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -30,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
        }
        .frame(height: ViewConfigs.layerHeight * 9)
        .zIndex(10000)
    }
}
