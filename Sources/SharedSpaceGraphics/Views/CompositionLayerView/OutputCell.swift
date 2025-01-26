//
//  OutputCell.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/25.
//

import SwiftUI

struct OutputCell: View {
    
    let outputEndpoint: ConnectionEndpoint
    let timelineWidth: CGFloat
    var inputEndpoints: [String: [ConnectionEndpoint]] = [:] //composition id : input connections
    var inputCompositions: [String: Composition] = [:]
    
    @State var selectedCompositionId: String?
    @State var selectedInputEndpoint: ConnectionEndpoint?
    
    init(outputEndpoint: ConnectionEndpoint, timelineWidth: CGFloat, renderer: MainRenderer) {
        self.outputEndpoint = outputEndpoint
        self.timelineWidth = timelineWidth
        
        let compositions = renderer.compositions
        for composition in compositions {
            inputEndpoints[composition.id] = []
            inputEndpoints[composition.id]! += composition.scene.__getInputList()
            inputCompositions[composition.id] = composition
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Text(outputEndpoint.name)
                    .font(.caption)
                    .padding(.horizontal, 10)
                Spacer()
                if selectedCompositionId != nil {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: ViewConfigs.layerIconSize, height: ViewConfigs.layerIconSize)
                        .padding(.horizontal, 8)
                        .foregroundStyle(.pink)
                        .onTapGesture {
                            outputEndpoint.targetEndpoint?.value = nil
                            outputEndpoint.targetEndpoint = nil
                            selectedCompositionId = nil
                            selectedInputEndpoint = nil
                        }
                }
            }
            .frame(width: ViewConfigs.layerLeftOffsetWidth, height: ViewConfigs.layerHeight)
            GeometryReader { reader in
                ZStack {
                    Rectangle()
                        .fill("222222".color)
                        .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
                    HStack {
                        Picker("Composition", selection: $selectedCompositionId) {
                            ForEach(Array(inputEndpoints.keys), id: \.self) { compositionId in
                                Text(inputCompositions[compositionId]!.name.isEmpty ? Utils.shortUUID(uuid: compositionId) : inputCompositions[compositionId]!.name)
                                    .tag(compositionId)
                            }
                        }
                        .frame(width: 300)
                        if let selectedCompositionId {
                            let endpoints = inputEndpoints[selectedCompositionId]!
                            Picker("Input Endpoint", selection: $selectedInputEndpoint) {
                                ForEach(endpoints) { inputEndpoint in
                                    Text(inputEndpoint.name)
                                        .tag(inputEndpoint)
                                }
                            }
                            .frame(width: 300)
                        }
                        Spacer()
                    }
                    .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
                }
                .frame(width: timelineWidth, height: ViewConfigs.layerHeight)
            }
            .frame(height: ViewConfigs.layerHeight)
        }
        .frame(height: ViewConfigs.layerHeight)
        .zIndex(10000)
        .onChange(of: selectedInputEndpoint) {
            outputEndpoint.targetEndpoint = selectedInputEndpoint
        }
    }
}
