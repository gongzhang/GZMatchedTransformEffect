//
//  SizePreference.swift
//
//
//  Created by Gong Zhang on 2020/9/17.
//

import SwiftUI

enum SizePreference: PreferenceKey {
    typealias Value = CGSize?
    static var defaultValue: CGSize? { nil }
    
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
    }
}

@available(iOS 13.0, macOS 10.15, watchOS 6.0, *)
extension View {
    func retrieveSize(to binding: Binding<CGSize?>) -> some View {
        self.background(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: SizePreference.self,
                                value: proxy.size)
            }
            .onPreferenceChange(SizePreference.self, perform: { value in
                if binding.wrappedValue != value {
                    binding.wrappedValue = value
                }
            })
        )
    }
}
