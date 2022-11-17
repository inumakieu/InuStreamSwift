//
//  BlurView.swift
//  Anime Now! (iOS)
//
//  Created by Erik Bautista on 9/9/22.
//
import SwiftUI

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}


struct BlurredButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .aspectRatio(1, contentMode: .fill)
            .padding(12)
            .background(BlurView(style: .systemThinMaterialDark))
    }
}
