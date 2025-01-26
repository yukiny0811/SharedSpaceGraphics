//
//  SceneParameterEditorView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct SceneParameterEditorView: View {
    
    let scene: any SharedSpaceScene
    let parameterKey: String
    let timelineWidth: CGFloat
    let renderer: MainRenderer
    let geometryProxy: GeometryProxy
    let backgroundColor: Color
    
    @State var lastCachedKeyframeUpdateDate = Date()
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(parameterKey[parameterKey.index(parameterKey.startIndex, offsetBy: 2)..<parameterKey.endIndex])
                    .font(.caption)
                    .padding(.horizontal, 10)
                Spacer()
                if lastCachedKeyframeUpdateDate != Date() && !scene.___keyframes_dict[parameterKey]!.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: ViewConfigs.layerIconSize, height: ViewConfigs.layerIconSize)
                        .padding(.horizontal, 8)
                        .foregroundStyle(.pink)
                        .onTapGesture {
                            scene.___keyframes_dict[parameterKey]?.removeAll()
                            lastCachedKeyframeUpdateDate = Date()
                        }
                }
            }
            .frame(width: ViewConfigs.layerLeftOffsetWidth, height: ViewConfigs.layerHeight)
            GeometryReader { reader in
                TimelineView(.animation(minimumInterval: 0.1, paused: false)) { context in
                    ZStack {
                        Rectangle()
                            .fill(backgroundColor)
                            .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
                        
                        ForEach(scene.___keyframes_dict[parameterKey]!) { kf in
                            KeyframeView(kf: kf, timelineWidth: timelineWidth, geometryProxy: geometryProxy)
                        }
                        .onAppear {
                            lastCachedKeyframeUpdateDate = scene.___keyframes_updated_date
                        }
                    }
                }
                .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
                .onTapGesture { event in
                    let newKeyframeTimePortion = event.x / reader.size.width
                    let newValue = InterpolationUtils.calculateInterpolated(keyframes: scene.___keyframes_dict[parameterKey]!, globalTimeNormalized: newKeyframeTimePortion, defaultValue: scene.___keyframes_minMaxDefault_dict[parameterKey]!.def)
                    scene.___keyframes_dict[parameterKey]!.append(Keyframe(id: UUID().uuidString, globalTime: newKeyframeTimePortion, value: newValue, minValue: scene.___keyframes_minMaxDefault_dict[parameterKey]!.min, maxValue: scene.___keyframes_minMaxDefault_dict[parameterKey]!.max))
                    scene.___keyframes_updated_date = Date()
                }
            }
            .frame(height: ViewConfigs.layerHeight)
        }
        .frame(height: ViewConfigs.layerHeight)
        .zIndex(10000)
    }
}
