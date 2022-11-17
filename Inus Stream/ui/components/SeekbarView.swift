//
//  SeekbarView.swift
//  Anime Now! (iOS)
//
//  Created by Erik Bautista on 9/22/22.
//
import SwiftUI

enum DragState: Equatable {
    case inactive
    case dragging(value: CGPoint)

    var value: CGPoint? {
        switch self {
        case .inactive:
            return nil
        case .dragging(let value):
            return value
        }
    }

    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}

struct SeekbarView: View {

    typealias EditingChanged = (Bool) -> Void

    @Binding var progress: Double
    @Binding var currentTime: Double
    @Binding var duration: Double?
    
    @State var preloaded: Double = 0.0
    var onEditingCallback: EditingChanged?

    @State var dragState = DragState.inactive
    @State var sentEditingCallback = false

    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .leading) {
                // Background
                BlurView(style: .systemThinMaterialDark)

                // Preloaded
                Color.gray
                    .frame(width: preloaded * reader.size.width)

                // Progress
                Color.white
                    .frame(
                        width: progress * reader.size.width,
                        alignment: .leading
                    )
            }
                .frame(
                    width: reader.size.width,
                    height: reader.size.height * (dragState.isDragging ? 1.75 : 1),
                    alignment: .leading
                )
                .clipShape(Capsule())
                .onChange(of: dragState) { newValue in
                    switch newValue {
                    case .inactive:
                        onEditingCallback?(false)
                        sentEditingCallback = false
                    case let .dragging(value):
                        if !sentEditingCallback {
                            onEditingCallback?(true)
                            sentEditingCallback = true
                        }

                        let locationX = value.x
                        let percentage = locationX / reader.size.width
                        progress = max(0, min(1.0, percentage))
                        currentTime = (duration ?? 1.0) * progress
                        print(currentTime)
                    }
                }
                .gesture(
                    DragGesture(
                        minimumDistance: 5
                    )
                        .onChanged({ value in
                            dragState = .dragging(value: value.location)
                        })
                        .onEnded({ _ in
                            dragState = .inactive
                        })
                )
                .animation(.spring(response: 0.3), value: dragState.isDragging)
        }
    }
}

struct SeekbarView_Previews: PreviewProvider {
    struct BindingProvider: View {
        @State var progress = 0.25
        @State var currentTime = 5.0
        @State var duration: Double? = 20.0
            

        var body: some View {
            SeekbarView(progress: $progress, currentTime: $currentTime, duration: $duration, preloaded: 0.0)
        }
    }

    static var previews: some View {
        BindingProvider()
            .frame(width: 300, height: 6)
    }
        
}
