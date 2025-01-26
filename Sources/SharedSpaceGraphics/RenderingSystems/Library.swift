//
//  Library.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//

import MetalKit

@VertexObject
struct ResizeVertex {
    var position: simd_float3
    var uv: simd_float2
}

actor Library {
    static let device = MTLCreateSystemDefaultDevice()!
    static let commandQueue = device.makeCommandQueue()!
    static let library = try! device.makeDefaultLibrary(bundle: .module)
    static let textureLoader: MTKTextureLoader = MTKTextureLoader(device: device)
    
    static func createDepthStencilDescriptor(compareFunc: MTLCompareFunction, writeDepth: Bool) -> MTLDepthStencilDescriptor {
        let depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = compareFunc
        depthStateDesc.isDepthWriteEnabled = writeDepth
        return depthStateDesc
    }
    
    static let resizePipelineState: MTLRenderPipelineState = {
        let vertFunc = library.makeFunction(name: "resize_vert")!
        let fragFunc = library.makeFunction(name: "resize_frag")!
        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = vertFunc
        desc.fragmentFunction = fragFunc
        desc.colorAttachments[0].pixelFormat = .bgra8Unorm
        desc.depthAttachmentPixelFormat = .depth32Float_stencil8
        desc.stencilAttachmentPixelFormat = .depth32Float_stencil8
        desc.vertexDescriptor = ResizeVertex.generateVertexDescriptor()
        return try! Library.device.makeRenderPipelineState(descriptor: desc)
    }()
}
