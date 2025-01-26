//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/26.
//

import MetalKit

public enum TextureUtils {
    public static func create(
        width: Int,
        height: Int,
        pixelFormat: MTLPixelFormat,
        label: String?,
        isRenderTarget: Bool = true,
        resourceMode: MTLResourceOptions = .storageModePrivate
    ) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        if isRenderTarget {
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        } else {
            descriptor.usage = [.shaderRead, .shaderWrite]
        }
        descriptor.resourceOptions = resourceMode
        let texture = Library.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
}
