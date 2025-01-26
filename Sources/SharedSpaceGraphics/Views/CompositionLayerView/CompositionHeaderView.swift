//
//  CompositionHeaderView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionHeaderView: View {
    
    let composition: Composition
    @Binding var parameterEditorShown: Bool
    
    var body: some View {
        HStack {
            TextField(
                Utils.shortUUID(uuid: composition.id),
                text: Binding {
                    composition.name
                } set: { newValue in
                    composition.name = newValue
                }
            )
            .textFieldStyle(.plain)
            .padding(.horizontal, 3)
            
            Spacer()
            
            CompositionHeaderIconToggleButton(
                isOn: $parameterEditorShown,
                systemNameOn: "gearshape.fill",
                systemNameOff: "gearshape.fill"
            )
            .padding(.trailing, 3)
            
            CompositionHeaderIconToggleButton(
                isOn: Binding<Bool> {
                    composition.eyesOpen
                } set: { newValue in
                    composition.eyesOpen = newValue
                },
                systemNameOn: "eye",
                systemNameOff: "eye.slash"
            )
            .padding(.trailing, 3)
        }
        .padding(.horizontal, 6)
    }
}
