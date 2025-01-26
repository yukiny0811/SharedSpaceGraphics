//
//  CompositionLayerView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct CompositionLayerView: View {
    
    let composition: Composition
    let renderer: MainRenderer
    let timelineWidth: CGFloat
    let geometryProxy: GeometryProxy
    
    @State var parameterEditorShown = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 0) {
                CompositionHeaderView(renderer: renderer, composition: composition, parameterEditorShown: $parameterEditorShown)
                    .frame(width: ViewConfigs.layerLeftOffsetWidth, height: ViewConfigs.layerHeight)
                CompositionTimelineView(timelineWidth: timelineWidth, composition: composition, renderer: renderer)
            }
            .frame(height: ViewConfigs.layerHeight)
            
            if parameterEditorShown {
                VStack(alignment: .leading, spacing: 0) {
                    CompositionParameterEditorView(
                        composition: composition,
                        timelineWidth: timelineWidth,
                        renderer: renderer,
                        geometryProxy: geometryProxy
                    )
                    ForEach(Array(composition.scene.___keyframes_dict.keys.enumerated()), id: \.element.self) { (i, key) in
                        SceneParameterEditorView(scene: composition.scene, parameterKey: key, timelineWidth: timelineWidth, renderer: renderer, geometryProxy: geometryProxy, backgroundColor: i.isMultiple(of: 2) ? "1e1e1e".color : "222222".color)
                    }
                    ForEach(composition.scene.__getOutputList()) { outputEndpoint in
                        OutputCell(outputEndpoint: outputEndpoint, timelineWidth: timelineWidth, renderer: renderer)
                    }
                }
                .background("282828".color)
            }
        }
        .opacity(composition.eyesOpen ? 1.0 : 0.3)
    }
}
