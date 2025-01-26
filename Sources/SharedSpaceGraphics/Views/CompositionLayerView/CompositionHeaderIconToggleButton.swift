//
//  CompositionHeaderIconView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionHeaderIconToggleButton: View {
    
    @Binding var isOn: Bool
    let systemNameOn: String
    let systemNameOff: String
    
    var body: some View {
        Button {
            withAnimation {
                isOn.toggle()
            }
        } label: {
            if isOn {
                Image(systemName: systemNameOn)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ViewConfigs.layerIconSize, height: ViewConfigs.layerIconSize)
                    .foregroundStyle(.white.opacity(0.8))
            } else {
                Image(systemName: systemNameOff)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: ViewConfigs.layerIconSize, height: ViewConfigs.layerIconSize)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .buttonStyle(.plain)
    }
}
