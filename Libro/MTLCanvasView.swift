//
//  MTLCanvasView.swift
//  Libro
//
//  Created by Prayash Thapa on 2/22/23.
//

import MetalKit
import SwiftUI

struct MTLCanvasView: NSViewRepresentable {
    class Coordinator: NSObject {
        var parent: MTLCanvasView
        var renderer: Renderer
        
        init(_ parent: MTLCanvasView) {
            self.parent = parent
            self.renderer = Renderer.init()
            super.init()
        }
    }
    
    /// Creates the custom instance that communicates changes from
    /// the view to other parts of the SwiftUI interface.
    ///
    /// Implement this method if changes to your view might affect other parts
    /// of your app. In your implementation, create a custom Swift instance that
    /// can communicate with other parts of your interface. For example, you
    /// might provide an instance that binds its variables to SwiftUI
    /// properties, causing the two to remain synchronized. If your view doesn't
    /// interact with other parts of your app, you don't have to provide a
    /// coordinator.
    ///
    /// SwiftUI calls this method before calling the
    /// ``NSViewRepresentable/makeNSView(context:)`` method. The system provides
    /// your coordinator instance either directly or as part of a context
    /// structure when calling the other methods of your representable instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates the view object and configures its initial state.
    ///
    /// You must implement this method and use it to create your view object.
    /// Configure the view using your app's current data and contents of the
    /// `context` parameter. The system calls this method only once, when it
    /// creates your view for the first time. For all subsequent updates, the
    /// system calls the ``NSViewRepresentable/updateNSView(_:context:)``
    /// method.
    ///
    /// - Parameter context: A context structure containing information about
    ///   the current state of the system.
    ///
    /// - Returns: Your AppKit view configured with the provided information.
    func makeNSView(context: NSViewRepresentableContext<MTLCanvasView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator.renderer
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }
        
        mtkView.isPaused = false
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        return mtkView
    }
    
    /// Updates the state of the specified view with new information from
    /// SwiftUI.
    ///
    /// When the state of your app changes, SwiftUI updates the portions of your
    /// interface affected by those changes. SwiftUI calls this method for any
    /// changes affecting the corresponding AppKit view. Use this method to
    /// update the configuration of your view to match the new state information
    /// provided in the `context` parameter.
    ///
    /// - Parameters:
    ///   - nsView: Your custom view object.
    ///   - context: A context structure containing information about the current
    ///     state of the system.
    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MTLCanvasView>) {
        // ...
    }
}
