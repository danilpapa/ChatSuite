//
//  Shimmer.swift
//  DesignKit
//
//  Created by setuper on 16.12.2025.
//

import SwiftUI

public struct BlinkViewModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false
    
    public func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.3 : 1)
            .animation(.easeInOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                blinking.toggle()
            }
    }
}

public extension View {
    
    func blinking(duration: Double = 1) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}
