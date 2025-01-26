//
//  ShaderMTKView.swift
//  SharedSpaceGraphicsEditor
//
//  Created by Yuki Kuwashima on 2025/01/23.
//
import MetalKit

public class ShaderMTKView: MTKView {
    
    let renderer: MainRenderer
    
    init(renderer: MainRenderer) {
        self.renderer = renderer
        super.init(frame: .zero, device: Library.device)
        
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = 60
        self.autoResizeDrawable = true
        self.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        self.sampleCount = 1
        self.depthStencilPixelFormat = .depth32Float_stencil8
        self.layer?.isOpaque = false
        self.layer?.contentsScale = 3
        
        let options: NSTrackingArea.Options = [
            .mouseMoved,
            .activeAlways,
            .inVisibleRect,
        ]
        let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let mousePos = mousePos(event: event, viewFrame: self.superview!.frame)
        renderer.onDrag(mousePos: mousePos, delta: f2(Float(event.deltaX), Float(event.deltaY)))
    }
    
    func mousePos(event: NSEvent, viewFrame: NSRect) -> simd_float2 {
        var location = event.locationInWindow
        location.y = event.window!.contentRect(
            forFrameRect: event.window!.frame
        ).height - location.y
        location -= CGPoint(x: viewFrame.minX, y: viewFrame.minY)
        return simd_float2(Float(location.x), Float(location.y))
    }
    
    public override func scrollWheel(with event: NSEvent) {
        renderer.onScroll(delta: f2(Float(event.deltaY), Float(event.deltaX)))
    }
}
