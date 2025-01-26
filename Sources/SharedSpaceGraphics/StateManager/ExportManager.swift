//
//  File.swift
//  SharedSpaceGraphics
//
//  Created by Yuki Kuwashima on 2025/01/27.
//

import MetalKit
import SwiftUI
import AVFoundation

public enum ExportFileType: String, Sendable, CaseIterable {
    case png
    case jpeg
    case mp4
    
    var imageName: String {
        switch self {
        case .png:
            "png"
        case .jpeg:
            "jpeg"
        case .mp4:
            "jpeg"
        }
    }
}

@Observable
@MainActor
public class ExportManager: ObservableObject, @unchecked Sendable {
    
    var currentProgress: Double = 0
    
    public func export(renderer: MainRenderer, fps: Double, exportFolderURL: URL, fileName: String, fileType: ExportFileType) async -> [URL] {
        let videoLength = renderer.videoLength
        var frameGlobalTimeInSeconds: [Double] = []
        var currentTimeInSeconds: Double = 0
        while currentTimeInSeconds < videoLength {
            frameGlobalTimeInSeconds.append(currentTimeInSeconds)
            currentTimeInSeconds += 1.0 / fps
        }
        
        let exportTexture = TextureUtils.create(
            width: renderer.width,
            height: renderer.height,
            pixelFormat: .bgra8Unorm,
            label: "export tex",
            isRenderTarget: true,
            resourceMode: .storageModeShared
        )
        let exportDepthTexture = TextureUtils.create(
            width: renderer.width,
            height: renderer.height,
            pixelFormat: .depth32Float_stencil8,
            label: "export depth tex",
            isRenderTarget: true,
            resourceMode: .storageModeShared
        )
        
        var exportedImageUrls: [URL] = []
        
        var frameCount: Int = 1
        for globalTime in frameGlobalTimeInSeconds {
            renderer.drawForExport(globalTimeForExport: globalTime, exportTexture: exportTexture, exportDepthTexture: exportDepthTexture)
            let exportName: String = fileName + "_" + String(format: "%05d", frameCount) + "." + fileType.imageName
            let exportURL = exportFolderURL.appending(path: exportName)
            if let data = ExportUtils.exportImage(texture: exportTexture, filetype: fileType) {
                do {
                    try await data.writeAsync(to: exportURL)
                    exportedImageUrls.append(exportURL)
                } catch {
                    print(error, "export data write error")
                }
            } else {
                print("fail to convert mtltexture -> png data")
            }
            frameCount += 1
            currentProgress = Double(frameCount - 1) / Double(frameGlobalTimeInSeconds.count)
        }
        
        return exportedImageUrls
    }
    
    public func generateVideo(folderURL: URL, frameUrls: [URL], fps: Double, movieName: String) async {
        await withCheckedContinuation { continuation in
            guard let assetwriter = try? AVAssetWriter(outputURL: folderURL.appending(path: movieName + ".mp4"), fileType: .mp4) else {
                fatalError("aaa")
            }
            
            guard let settingsAssistant = AVOutputSettingsAssistant(preset: .preset1920x1080)?.videoSettings else {
                fatalError("aaa2")
            }
            let assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: settingsAssistant)
            let assetWriterAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: assetWriterInput, sourcePixelBufferAttributes: nil)
            assetwriter.add(assetWriterInput)
            assetwriter.startWriting()
            assetwriter.startSession(atSourceTime: CMTime.zero)
            let framesPerSecond = fps
            let totalFrames = frameUrls.count
            var frameCount = 0
            while frameCount < totalFrames {
                let url = frameUrls[frameCount]
                if let data = try? Data(contentsOf: url), let pixelBuffer = dataToCVPixelBuffer(data: data) {
                    if assetWriterInput.isReadyForMoreMediaData {
                        let frameTime = CMTimeMake(value: Int64(frameCount), timescale: Int32(framesPerSecond))
                        assetWriterAdaptor.append(pixelBuffer, withPresentationTime: frameTime)
                        frameCount+=1
                    }
                } else {
                    print("no data")
                }
            }
            //close everything
            assetWriterInput.markAsFinished()
            assetwriter.finishWriting {
                continuation.resume(with: .success(()))
            }
        }
    }
    
    func dataToCVPixelBuffer(data: Data) -> CVPixelBuffer? {
        guard let image = NSImage(data: data) else {
            print("Error: Unable to create UIImage from data.")
            return nil
        }
        
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            print("Error: UIImage does not have a CGImage.")
            return nil
        }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let attributes: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue!,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue!
        ]
        
        var pixelBuffer: CVPixelBuffer?
        
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB, // Choose appropriate pixel format
            attributes as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            print("Error: Failed to create CVPixelBuffer.")
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            print("Error: Unable to create CGContext.")
            CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            return nil
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        return buffer
    }
}

