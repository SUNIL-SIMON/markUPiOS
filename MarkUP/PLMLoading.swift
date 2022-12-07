//
//  PLMLoading.swift
//  MarkUP
//
//  Created by SIMON on 06/12/22.
//

import Foundation
import SwiftUI
import AppearanceFramework

public struct LoadingView<Content>: View where Content: View {
    @Binding public var isShowing: Bool
    public var content: () -> Content
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)
                
                VStack {
                    TCActivityIndicatorView(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2, height: geometry.size.height / 5)
                .foregroundColor(Color.red)
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
                
            }
        }
    }
}
public struct TCActivityIndicatorView: UIViewRepresentable {
    @Binding public var isAnimating: Bool
    public let style: UIActivityIndicatorView.Style
    
    public func makeUIView(context: UIViewRepresentableContext<TCActivityIndicatorView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<TCActivityIndicatorView>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public struct ProgressIndicator: View {
    
    public init() {}
    
    public var body: some View {
        
        ZStack {
            
            TCAppearance.shared.theme.color.progressBackground
                .opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView {
            }
            .padding()
            .background(TCAppearance.shared.theme.color.progressForeground)
            .cornerRadius(5.0)
        }
    }
}
