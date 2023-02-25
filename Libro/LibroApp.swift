//
//  LibroApp.swift
//  Libro
//
//  Created by Prayash Thapa on 2/22/23.
//

import SwiftUI

@main
struct LibroApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                MTLCanvasView()
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
            .padding()
        }
    }
}
