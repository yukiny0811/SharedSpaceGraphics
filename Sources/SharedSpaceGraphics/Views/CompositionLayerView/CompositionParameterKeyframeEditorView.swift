//
//  CompositionParameterKeyframeEditorView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/26.
//

import SwiftUI

struct CompositionParameterKeyframeEditorView: View {
    
    @Environment(TooltipManager.self) var tooltipManager
    
    let title: String
    @Binding var keyframes: [Keyframe]
    let timelineWidth: CGFloat
    let renderer: MainRenderer
    let geometryProxy: GeometryProxy
    let backgroundColor: Color
    let defaultValue: Float
    let minValue: Float
    let maxValue: Float
    
    init(
        title: String,
        keyframes: Binding<[Keyframe]>,
        timelineWidth: CGFloat,
        renderer: MainRenderer,
        geometryProxy: GeometryProxy,
        backgroundColor: Color,
        defaultValue: Float,
        minValue: Float,
        maxValue: Float
    ) {
        self.title = title
        self._keyframes = keyframes
        self.timelineWidth = timelineWidth
        self.renderer = renderer
        self.geometryProxy = geometryProxy
        self.backgroundColor = backgroundColor
        self.defaultValue = defaultValue
        self.minValue = minValue
        self.maxValue = maxValue
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.caption)
                    .padding(.horizontal, 10)
                Spacer()
                if !keyframes.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: ViewConfigs.layerIconSize, height: ViewConfigs.layerIconSize)
                        .padding(.horizontal, 8)
                        .foregroundStyle(.pink)
                        .onTapGesture {
                            keyframes.removeAll()
                        }
                }
            }
            .frame(width: ViewConfigs.layerLeftOffsetWidth, height: ViewConfigs.layerHeight)
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
                ForEach(keyframes) { kf in
                    KeyframeView(kf: kf, timelineWidth: timelineWidth, geometryProxy: geometryProxy)
                }
            }
            .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
            .onTapGesture { event in
                let newKeyframeTimePortion = event.x / timelineWidth
                let newValue = InterpolationUtils.calculateInterpolated(keyframes: keyframes, globalTimeNormalized: renderer.currentSecondsFromStart / renderer.videoLength, defaultValue: defaultValue)
                keyframes.append(Keyframe(id: UUID().uuidString, globalTime: newKeyframeTimePortion, value: newValue, minValue: minValue, maxValue: maxValue))
            }
            .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
        }
        .frame(height: ViewConfigs.layerHeight)
    }
}
