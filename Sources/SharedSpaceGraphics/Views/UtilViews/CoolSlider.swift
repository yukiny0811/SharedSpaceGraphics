//
//  CoolSlider.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CoolSlider: View {
    
    @Binding var currentValue: Float
    let minValue: Float
    let maxValue: Float
    let tintColor: Color
    let barHeight: CGFloat
    
    var portionValue: Float {
        (currentValue - minValue) / (maxValue - minValue)
    }
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                ZStack {
                    let minOpacity = min(1.0, pointLength(from: minValue, to: currentValue, width: Float(reader.size.width)) / 50)
                    Text(String(format: "%.2f", minValue))
                        .font(.system(size: 8))
                        .opacity(Double(minOpacity) * 0.7)
                        .offset(x: -reader.size.width * 0.5)
                    let maxOpacity = min(1.0, pointLength(from: currentValue, to: maxValue, width: Float(reader.size.width)) / 50)
                    Text(String(format: "%.2f", maxValue))
                        .font(.system(size: 8))
                        .opacity(Double(maxOpacity) * 0.7)
                        .offset(x: -reader.size.width * 0.5 + reader.size.width)
                    HStack(alignment: .bottom) {
                        Text(String(format: "%.2f", currentValue))
                            .font(.system(size: 8))
                            .opacity(0.7)
                            .offset(x: -reader.size.width * 0.5 + reader.size.width * CGFloat(portionValue))
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(.background)
                        .stroke(Color.gray, lineWidth: 0.5)
                    Rectangle()
                        .fill(tintColor)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .frame(width: reader.size.width * CGFloat(portionValue))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                        .offset(x: -reader.size.width * 0.5 + reader.size.width * CGFloat(portionValue) * 0.5)
                }
                .frame(height: barHeight)
                .onTapGesture { event in
                    let portion = event.x / reader.size.width
                    setCurrentValue(newValue: minValue + (maxValue - minValue) * Float(portion))
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { event in
                            let portion = event.location.x / reader.size.width
                            setCurrentValue(newValue: minValue + (maxValue - minValue) * Float(portion))
                        }
                )
            }
        }
    }
    
    func setCurrentValue(newValue: Float) {
        currentValue = min(maxValue, max(minValue, newValue))
    }
    
    func pointLength(from start: Float, to end: Float, width: Float) -> Float {
        let startPixelPos = (start - minValue) / (maxValue - minValue) * width
        let endPixelPos = (end - minValue) / (maxValue - minValue) * width
        return abs(endPixelPos - startPixelPos)
    }
}

#Preview {
    @Previewable @State var value: Float = 0.0
    VStack {
        CoolSlider(currentValue: $value, minValue: -1, maxValue: 1, tintColor: .mint, barHeight: 6)
            .frame(width: 300)
    }
    .frame(width: 400, height: 50)
    .background(.black)
}
