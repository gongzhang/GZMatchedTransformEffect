# GZMatchedTransformEffect

<img src="https://user-images.githubusercontent.com/4470629/156162433-5d6d4b56-1789-4b39-9661-99da713786dc.gif" width="550"></img>

Create a smooth transition between any two SwiftUI Views. It is very similar to the built-in `.matchedGeometryEffect()` modifier, but the effect is much smoother.

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/gongzhang/GZMatchedTransformEffect", .upToNextMajor(from: "1.0.0"))
]
```

## Quick Start

1. Use the same `.matchedTransformEffect()` modifier on both views.
2. Control the appearance and disappearance of two views in a `withAnimation` block

```swift
struct Example: View {
    @State private var flag = true
    @Namespace private var ns

    var view1: some View { ... }
    var view2: some View { ... }

    var body: some View {
        VStack {
            if flag {
                view1
                    .fixedSize()
                    .id("view1")
                    .matchedTransformEffect(id: "transition", in: ns) // ⬅️
            }

            if !flag {
                view2
                    .fixedSize()
                    .id("view2")
                    .matchedTransformEffect(id: "transition", in: ns) // ⬅️
            }

            Button(action: { withAnimation { flag.toggle() } }) {
                Text("Toggle")
            }
        }
    }
}
```
