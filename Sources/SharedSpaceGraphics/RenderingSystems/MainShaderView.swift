//
//  MainShaderView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import SwiftUI
import MetalKit

public struct MainShaderView: NSViewRepresentable {
    
    let renderer: MainRenderer
    
    public init(renderer: MainRenderer) {
        self.renderer = renderer
    }
    
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = ShaderMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
}
