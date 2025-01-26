//
//  CompositionParameterEditorView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionParameterEditorView: View {
    
    let composition: Composition
    let timelineWidth: CGFloat
    let renderer: MainRenderer
    let geometryProxy: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CompositionParameterKeyframeEditorView(
                title: "Position X",
                keyframes: Binding {
                    composition.positionXKeyframes
                } set: { newValue in
                    composition.positionXKeyframes = newValue
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
                title: "Position Y",
                keyframes: Binding {
                    composition.positionYKeyframes
                } set: { newValue in
                    composition.positionYKeyframes = newValue
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
                title: "Position Z",
                keyframes: Binding {
                    composition.positionZKeyframes
                } set: { newValue in
                    composition.positionZKeyframes = newValue
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
                title: "Rotation X",
                keyframes: Binding {
                    composition.rotationXKeyframes
                } set: { newValue in
                    composition.rotationXKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 0,
                minValue: -3,
                maxValue: 3
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Rotation Y",
                keyframes: Binding {
                    composition.rotationYKeyframes
                } set: { newValue in
                    composition.rotationYKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 0,
                minValue: -3,
                maxValue: 3
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Rotation Z",
                keyframes: Binding {
                    composition.rotationZKeyframes
                } set: { newValue in
                    composition.rotationZKeyframes = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 0,
                minValue: -3,
                maxValue: 3
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Scale X",
                keyframes: Binding {
                    composition.scaleXKeyFrames
                } set: { newValue in
                    composition.scaleXKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 1,
                minValue: 0,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Scale Y",
                keyframes: Binding {
                    composition.scaleYKeyFrames
                } set: { newValue in
                    composition.scaleYKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "1e1e1e".color,
                defaultValue: 1,
                minValue: 0,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
            CompositionParameterKeyframeEditorView(
                title: "Scale Z",
                keyframes: Binding {
                    composition.scaleZKeyFrames
                } set: { newValue in
                    composition.scaleZKeyFrames = newValue
                },
                timelineWidth: timelineWidth,
                renderer: renderer,
                geometryProxy: geometryProxy,
                backgroundColor: "222222".color,
                defaultValue: 1,
                minValue: 0,
                maxValue: 30
            )
            .frame(height: ViewConfigs.layerHeight)
        }
        .frame(height: ViewConfigs.layerHeight * 9)
        .zIndex(10000)
    }
}
