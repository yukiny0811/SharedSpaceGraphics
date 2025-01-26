//
//  EditorTimelineView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/26.
//

import SwiftUI

struct EditorTimelineView: View {
    
    let renderer: MainRenderer
    @Binding var timelineWidth: CGFloat
    let geometryProxy: GeometryProxy
    let bottomPanelMinHeight: CGFloat
    
    @State var cachedTimelineMagnification: CGFloat = 1
    @State var currentMagnification: CGFloat = 1.0
    
    var body: some View {
        GeometryReader { reader in
            ScrollView([.vertical, .horizontal]) {
                VStack(alignment: .leading, spacing: 3) {
                    Spacer()
                        .frame(height: 6)
                    HStack(alignment: .bottom, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("Layers")
                                .padding(.leading, 10)
                            Spacer()
                        }
                        .frame(width: ViewConfigs.layerLeftOffsetWidth)
                        CoolSlider(
                            currentValue: Binding<Float> {
                                Float(renderer.currentSecondsFromStart)
                            } set: { newValue in
                                renderer.seekTo(secondsFromStart: Double(newValue))
                            },
                            minValue: 0,
                            maxValue: Float(renderer.videoLength),
                            tintColor: .pink,
                            barHeight: 8
                        )
//                        .padding(.leading, ViewConfigs.layerLeftOffsetWidth)
                        .frame(height: 30)
                    }
                    .frame(height: 30)
                    
                    ZStack {
                        Rectangle()
                            .fill("171717".color)
                            .padding(.leading, ViewConfigs.layerLeftOffsetWidth)
                        VStack(spacing: 1) {
                            CompositionCameraParameterEditorView(
                                timelineWidth: timelineWidth,
                                renderer: renderer,
                                geometryProxy: geometryProxy
                            )
                            ForEach(renderer.compositions) { composition in
                                CompositionLayerView(
                                    composition: composition,
                                    renderer: renderer,
                                    timelineWidth: timelineWidth,
                                    geometryProxy: geometryProxy
                                )
                            }
                            Spacer()
                                .frame(height: 1000)
                        }
                    }
                    Spacer()
                }
                .frame(width: timelineWidth + ViewConfigs.layerLeftOffsetWidth)
                .frame(minHeight: bottomPanelMinHeight)
                .overlay {
                    let currentPortionOfTime = renderer.currentSecondsFromStart / renderer.videoLength
                    Rectangle()
                        .fill(.pink)
                        .frame(width: 1)
                        .padding(.top, 24)
                        .offset(x: (ViewConfigs.layerLeftOffsetWidth + currentPortionOfTime * Double(timelineWidth)) - (timelineWidth + ViewConfigs.layerLeftOffsetWidth) * 0.5)
                }
            }
            .frame(minHeight: bottomPanelMinHeight)
            .frame(maxWidth: .infinity)
        }
        .frame(minHeight: bottomPanelMinHeight)
        .frame(maxWidth: .infinity)
        .background("222222".color)
        .gesture(
            MagnifyGesture(minimumScaleDelta: 0)
                .onChanged { value in
                    let newWidth = 2000 * (cachedTimelineMagnification + value.magnification - 1.0)
                    if newWidth >= geometryProxy.size.width - ViewConfigs.layerLeftOffsetWidth - 50 {
                        currentMagnification = value.magnification
                        timelineWidth = newWidth
                    }
                }
                .onEnded { value in
                    cachedTimelineMagnification += currentMagnification - 1.0
                }
        )
    }
    
    func onGestureChanged(value: DragGesture.Value) {
        renderer.pause()
        let currentDragPositionPortion = (value.location.x - ViewConfigs.layerLeftOffsetWidth * 0.5 + timelineWidth * 0.5) / timelineWidth
        if currentDragPositionPortion >= 0 && currentDragPositionPortion <= 1 {
            renderer.seekTo(secondsFromStart: currentDragPositionPortion * renderer.videoLength)
        }
    }
}
