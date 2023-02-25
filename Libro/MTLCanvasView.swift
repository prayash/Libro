//
//  MTLCanvasView.swift
//  Libro
//
//  Created by Prayash Thapa on 2/22/23.
//

import MetalKit
import SwiftUI

struct MTLCanvasView: NSViewRepresentable {
    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MTLCanvasView
        var device: MTLDevice!
        var metalCommandQueue: MTLCommandQueue!
        
        init(_ parent: MTLCanvasView) {
            self.parent = parent
            if let device = MTLCreateSystemDefaultDevice() {
                self.device = device
            }
            
            self.metalCommandQueue = device.makeCommandQueue()!
            super.init()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // ...
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else {
                return
            }
            
            guard let commandBuffer = metalCommandQueue.makeCommandBuffer() else {
                return
            }
            
            guard let rpd = view.currentRenderPassDescriptor else {
                return
            }
            
            rpd.colorAttachments[0].clearColor = MTLClearColorMake(0, 1, 0, 1)
            rpd.colorAttachments[0].loadAction = .clear
            rpd.colorAttachments[0].storeAction = .store
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: rpd)
            encoder?.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<MTLCanvasView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MTLCanvasView>) {
        // ...
    }
}
