//
//  SceneLibraryList.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/26.
//

import SwiftUI

struct SceneLibraryList: View {
    
    let sceneLibrary: [SharedSpaceScene.Type]
    let renderer: MainRenderer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Scenes")
                .font(.title)
                .bold()
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 0)
            List {
                ForEach(0..<sceneLibrary.count, id: \.self) { sceneIndex in
                    HStack {
                        Text(sceneLibrary[sceneIndex].sceneName)
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.foreground)
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("Created by \(sceneLibrary[sceneIndex].author)")
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.foreground)
                            Text("Unique ID: \(sceneLibrary[sceneIndex].id)")
                                .font(.caption)
                                .bold()
                                .foregroundStyle(.foreground.opacity(0.5))
                        }
                    }
                    .listRowInsets(.init())
                    .padding(12)
                    .background {
                        RoundedRectangle(cornerRadius: 3)
                            .fill("333333".color)
                    }
                    .onTapGesture {
                        renderer.addScene(sceneLibrary[sceneIndex])
                    }
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .background("222222".color)
    }
}
