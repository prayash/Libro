//
//  Renderer.swift
//  Libro
//
//  Created by Prayash Thapa on 3/15/23.
//

import Metal
import MetalKit
import simd

enum RendererError: LocalizedError {
    case badVertexDescriptor
}

class Renderer: NSObject, MTKViewDelegate {

    var device: MTLDevice
    var commandQueue: MTLCommandQueue
    var renderPipelineState: MTLRenderPipelineState
    
    override init() {
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Unable to retrieve default Metal device")
        }
        
        self.device = defaultDevice
        
        guard let queue = defaultDevice.makeCommandQueue() else {
            fatalError("Unable to create command queue")
        }
        
        self.commandQueue = queue
        
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Unable to make default Metal library")
        }
        

        let vertexFunction = library.makeFunction(name: "vs")
        let fragmentFunction = library.makeFunction(name: "fs")
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            try renderPipelineState = device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error {
            fatalError("Failed to create MTLRenderPipelineState with error: \n\(error)")
        }
        
        super.init()
    }
    
    // MARK: - MTKViewDelegate
        
    /// Called on the delegate when it is asked to render into the view
    /// - Parameter view: Target view to render into
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        
        guard let renderDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        renderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.8, 0.0, 0.9, 1)
        renderDescriptor.colorAttachments[0].loadAction = .clear
        renderDescriptor.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor)
        
        renderEncoder?.setVertexBytes(
            Geometry.triangleVertexArray,
            length: MemoryLayout<Float32>.size * Geometry.triangleVertexArray.count,
            index: 0
        )
        
        renderEncoder?.setRenderPipelineState(self.renderPipelineState)
        
        renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder?.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    /// Called whenever the drawableSize of the view will change
    /// - Parameters:
    ///   - view: `MTKView` which called this method
    ///   - size: New drawable size in pixels
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // ...
    }
}
