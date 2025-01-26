//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import MetalKit

public enum ExportUtils {
//    static func exportImage(texture: MTLTexture?) -> Data? {
//        guard let texture else {
//            print("no texture")
//            return nil
//        }
//        guard let ciImage = CIImage(mtlTexture: texture, options: nil) else {
//            print("no ciimage")
//            return nil
//        }
//        guard let cgImage = ciImage.cgImage else {
//            print("no cgimage")
//            return nil
//        }
//        let finalimage = NSImage(
//            cgImage: cgImage,
//            size: NSSize(width: texture.width, height: texture.height)
//        )
//        guard let tiffData = finalimage.tiffRepresentation else {
//            print("no tiffdata")
//            return nil
//        }
//        guard let bitmapRep = NSBitmapImageRep(data: tiffData) else {
//            print("no bitmaprep")
//            return nil
//        }
//        guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
//            print("no pngdata")
//            return nil
//        }
//        return pngData
//    }
    
    static func exportImage(texture: MTLTexture, filetype: ExportFileType) -> Data? {
        let bytesPerRow = texture.width * 4
        let length = bytesPerRow * texture.height
        
        let rgbaBytes = UnsafeMutableRawPointer.allocate(byteCount: length, alignment: MemoryLayout<UInt8>.alignment)
        
        defer {
            rgbaBytes.deallocate()
        }
        
        let destinationRegion = MTLRegion(
            origin: .init(x: 0, y: 0, z: 0),
            size: .init(
                width: texture.width,
                height: texture.height,
                depth: texture.depth
            )
        )
        texture.getBytes(rgbaBytes, bytesPerRow: bytesPerRow, from: destinationRegion, mipmapLevel: 0)
        
        let colorScape = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageByteOrderInfo.order32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        guard let data = CFDataCreate(nil, rgbaBytes.assumingMemoryBound(to: UInt8.self), length) else {
            print("failed to create nil data")
            return nil
        }
        guard let dataProvider = CGDataProvider(data: data) else {
            print("no data provider")
            return nil
        }
        guard let cgImage = CGImage(
            width: texture.width,
            height: texture.height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: bytesPerRow,
            space: colorScape,
            bitmapInfo: bitmapInfo,
            provider: dataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            print("no cgimage")
            return nil
        }
        let finalimage = NSImage(
            cgImage: cgImage,
            size: NSSize(width: texture.width, height: texture.height)
        )
        guard let tiffData = finalimage.tiffRepresentation else {
            print("no tiffdata")
            return nil
        }
        guard let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            print("no bitmaprep")
            return nil
        }
        switch filetype {
        case .png:
            guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
                print("no pngdata")
                return nil
            }
            return pngData
        case .jpeg, .mp4:
            guard let jpgData = bitmapRep.representation(using: .jpeg, properties: [:]) else {
                print("no pngdata")
                return nil
            }
            return jpgData
        }
    }
}
