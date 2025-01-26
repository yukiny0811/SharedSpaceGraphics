//
//  KeyframeViewFloat.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI
import SwiftUITooltip

struct KeyframeView: View {
    
    @Environment(TooltipManager.self) var tooltipManager
    
    let kf: Keyframe
    let timelineWidth: CGFloat
    let geometryProxy: GeometryProxy
    
    init(kf: Keyframe, timelineWidth: CGFloat, geometryProxy: GeometryProxy) {
        self.kf = kf
        self.timelineWidth = timelineWidth
        self.geometryProxy = geometryProxy
    }
    
    var body: some View {
        Rectangle()
            .fill(Color.mint.opacity(0.0001))
            .frame(width: 20, height: 20)
            .overlay {
                if tooltipManager.showingKeyframe == kf {
                    TimelineView(.animation) { timeline in
                        let date = timeline.date.timeIntervalSinceReferenceDate
                        let angle = Angle.degrees(50.0 * date.truncatingRemainder(dividingBy: 8))
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.mint)
                            .frame(width: 8, height: 8)
                            .scaleEffect(1.2)
                            .rotationEffect(angle)
                    }
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.mint)
                        .frame(width: 8, height: 8)
                        .rotationEffect(.degrees(45))
                }
            }
            .tooltip(tooltipManager.showingKeyframe == kf, side: .top, config: TooltipUtils.tooltipConfig) {
                CoolSlider(
                    currentValue: Binding<Float> {
                        kf.value
                    } set: { newValue in
                        kf.value = newValue
                    },
                    minValue: kf.minValue,
                    maxValue: kf.maxValue,
                    tintColor: .mint,
                    barHeight: 6
                )
                .frame(width: 200, height: 23)
                .padding(.horizontal, 8)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let deltaX = value.translation.width
                        let portionGlobal = deltaX / timelineWidth
                        kf.globalTime += portionGlobal
                    }
            )
            .offset(x: kf.globalTime * timelineWidth - timelineWidth * 0.5)
            .onTapGesture {
                if let showingKeyframe = tooltipManager.showingKeyframe {
                    if showingKeyframe.id == kf.id {
                        tooltipManager.showingKeyframe = nil
                    } else {
                        tooltipManager.showingKeyframe = kf
                    }
                } else {
                    tooltipManager.showingKeyframe = kf
                }
            }
    }
}
