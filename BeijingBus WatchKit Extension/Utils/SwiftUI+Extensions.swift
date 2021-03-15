//
//  SwiftUI+Extensions.swift
//  BeijingBus WatchKit Extension
//
//  Created by Wang Guanyu on 2021/3/4.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}

extension View {

    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}

extension Color {
    init(rgbValue: UInt) {
        self.init(rgbValue: rgbValue, alpha: 1)
    }
    init(rgbValue: UInt, alpha: Double) {
        self.init(.sRGB,
                  red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: Double(rgbValue & 0x0000FF) / 255.0,
                  opacity: alpha)
    }
}
