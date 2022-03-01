//
//  MatchedTransformEffect.swift
//  MatchedTransformEffect
//
//  Created by Gong Zhang on 2021/9/8.
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, watchOS 7.0, *)
struct MatchedTransformEffect<ID: Hashable>: ViewModifier {
    
    var id: ID
    var namespace: Namespace.ID
    
    @State private var transformedSize: CGSize? = nil
    @State private var intrinsicSize: CGSize? = nil
    
    private var scale: CGFloat {
        guard let intrinsicSize = intrinsicSize, let transformedSize = transformedSize else {
            return 1
        }
        
        let wScale = transformedSize.width / max(intrinsicSize.width, 1)
        let hScale = transformedSize.height / max(intrinsicSize.height, 1)
        
        // balance two axes if they have different aspect ratios
        return (wScale + hScale) / 2
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .retrieveSize(to: $intrinsicSize)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .retrieveSize(to: $transformedSize)
            .matchedGeometryEffect(id: id, in: namespace, properties: .frame)
            .fixedSize()
    }
    
}

@available(iOS 14.0, macOS 11.0, watchOS 7.0, *)
extension View {
    
    /// Defines a transform effect between two views.
    ///
    /// Use this modifier on two different views (i.e. they have different view identitiy).
    /// When one of the views appears and the other disappears, a transition animation
    /// of scale and opacity will be generated between them.
    /// 
    /// You may find the `matchedGeometryEffect()` very similar to this.
    /// The difference is that the `matchedGeometryEffect()` interpolates
    /// the frames between the two views, and triggers re-layout of the views at each frame.
    /// On the other hand, the `matchedTransformEffect()` uses scale transform
    /// and does not change view frames during the animation. This is often useful for text
    /// transition.
    ///
    /// ```swift
    /// struct Example: View {
    ///     @State private var flag = true
    ///     @Namespace private var ns
    ///
    ///     var view1: some View { ... }
    ///     var view2: some View { ... }
    ///
    ///     var body: some View {
    ///         VStack {
    ///             if flag {
    ///                 view1
    ///                     .id("view1")
    ///                     .matchedTransformEffect(id: "bubbleTransition", in: ns)
    ///             }
    ///
    ///             if !flag {
    ///                 view2
    ///                     .id("view2")
    ///                     .matchedTransformEffect(id: "bubbleTransition", in: ns)
    ///             }
    ///
    ///             Button(action: { withAnimation { flag.toggle() } }) {
    ///                 Text("Toggle")
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Important: Helpful hints:
    /// 1. The two views must have different identities, which can be specified explicitly with `id(_:)` if necessary.
    /// 2. The two views cannot appear at the same time.
    /// 3. Both views must have a deterministic size. This can be specified by `frame(width:height:)` or `fixedSize()`.
    /// 4. If the animation doesn't appear correctly, try wrapping a `ZStack` on the outer layer; this problem usually occurs in Xcode Preview.
    ///
    /// - Parameters:
    ///   - id: The identifier, used to define a transition between two views.
    ///   - namespace: The namespace in which defines the `id`.
    ///
    public func matchedTransformEffect<ID: Hashable>(id: ID, in namespace: Namespace.ID) -> some View {
        self.modifier(MatchedTransformEffect(id: id, namespace: namespace))
    }
}

@available(iOS 15.0, macOS 12.0, watchOS 8.0, *)
struct MatchedTransformEffect_Preview: PreviewProvider {
    
    struct Example: View {
        
        @State private var flag = true
        @Namespace private var ns
        
        var view1: some View {
            Text("👋 Hello")
                .foregroundColor(.white)
                .font(.body)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Capsule().fill(Color.blue))
                .fixedSize()
        }
        
        var view2: some View {
            Text("World 🎉")
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Capsule().fill(Color.green))
        }
        
        var body: some View {
            VStack {
                HStack {
                    VStack {
                        Text(".matchedTransformEffect 👏")
                        ZStack {
                            Group {
                                if flag {
                                    view1
                                        .fixedSize()
                                        .id("bubble1")
                                        .matchedTransformEffect(id: "bubbleTransition", in: ns)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            
                            Group {
                                if !flag {
                                    view2
                                        .fixedSize()
                                        .id("bubble2")
                                        .matchedTransformEffect(id: "bubbleTransition", in: ns)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Divider()
                    
                    VStack {
                        Text(".matchedGeometryEffect ❌")
                        ZStack {
                            Group {
                                if flag {
                                    view1
                                        .id("bubble3")
                                        .matchedGeometryEffect(id: "bubble", in: ns)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            
                            Group {
                                if !flag {
                                    view2
                                        .id("bubble4")
                                        .matchedGeometryEffect(id: "bubble", in: ns)
                                }
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .font(.body.monospaced())
                
                Button(action: { withAnimation(.default.speed(0.25)) { flag.toggle() } }) {
                    Text("Toggle")
                }
            }
        }
    }
    
    static var previews: some View {
        ZStack { // workaround SwiftUI animation issue in Xcode Preview
            Example()
        }
        .padding()
    }
}

