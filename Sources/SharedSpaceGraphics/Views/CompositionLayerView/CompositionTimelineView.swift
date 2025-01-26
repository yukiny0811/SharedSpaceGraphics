//
//  CompositionTimelineView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionTimelineView: View {
    
    let timelineWidth: CGFloat
    let composition: Composition
    let renderer: MainRenderer
    
    enum GestureStatus {
        case normal
        case sizeChangeLeading
        case sizeChangeTrailing
    }
    
    @State var gestureStatus: GestureStatus = .normal
    @State var prevPositionNormalized: CGFloat?
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill("1a1a1a".color)
                .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
            let compositionWidthInView = composition.length / renderer.videoLength * timelineWidth
            let compositionStartXInView = composition.startTime / renderer.videoLength * timelineWidth
            Rectangle()
                .fill("555555".color)
                .frame(width: compositionWidthInView)
                .overlay {
                    HStack {
                        Rectangle()
                            .fill("4a4a4a".color)
                            .frame(width: 8)
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0.01)
                                    .onChanged { event in
                                        gestureStatus = .sizeChangeLeading
                                        let newPositionNormalized = (event.location.x) / timelineWidth
                                        if let prevPositionNormalized {
                                            let diffNormalized = (newPositionNormalized - prevPositionNormalized)
                                            composition.length -= diffNormalized * renderer.videoLength
                                            composition.startTime += diffNormalized * renderer.videoLength
                                        }
                                        prevPositionNormalized = newPositionNormalized
                                    }
                                    .onEnded { _ in
                                        gestureStatus = .normal
                                    }
                            )
                        Text(composition.sceneName)
                            .foregroundStyle(.foreground.opacity(0.7))
                        Spacer()
                        Rectangle()
                            .fill("4a4a4a".color)
                            .frame(width: 8)
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0.01)
                                    .onChanged { event in
                                        gestureStatus = .sizeChangeTrailing
                                        let newPositionNormalized = (event.location.x) / timelineWidth
                                        if let prevPositionNormalized {
                                            let diffNormalized = (newPositionNormalized - prevPositionNormalized)
                                            composition.length += diffNormalized * renderer.videoLength
                                        }
                                        prevPositionNormalized = newPositionNormalized
                                    }
                                    .onEnded { _ in
                                        gestureStatus = .normal
                                    }
                            )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 3))
                .offset(x: compositionStartXInView - timelineWidth * 0.5 + compositionWidthInView * 0.5)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { event in
                            if gestureStatus == .normal {
                                let newPositionNormalized = (event.location.x - compositionWidthInView) / timelineWidth
                                if let prevPositionNormalized {
                                    let diffNormalized = newPositionNormalized - prevPositionNormalized
                                    composition.startTime += diffNormalized * renderer.videoLength
                                }
                                prevPositionNormalized = newPositionNormalized
                            }
                        }
                        .onEnded { event in
                            prevPositionNormalized = nil
                        }
                )
        }
        .clipped()
    }
}

// wip
