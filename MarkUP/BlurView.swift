//
//  BlurView.swift
//  MarkUP
//
//  Created by SIMON on 06/12/22.
//

import Foundation
import SwiftUI
import UIKit
public struct TCBlurView: UIViewRepresentable {
    public func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    public func makeUIView(context: Context) -> UIView {
        let blurView = TCEffectsBlurView()
        return blurView
    }
}
public class TCEffectsBlurView: UIView {
    var blurView : UIVisualEffectView!
    public init() {
        super.init(frame: .zero)
        let blurEffect = UIBlurEffect(style:  .light)
        if #available(iOS 10.0, *) {
            self.blurView = TCEffectsView.init(effect: blurEffect, intensity: 0.08)
        } else {
            self.blurView.effect = blurEffect
        }
        self.addSubview(blurView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.blurView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }

}
@available(iOS 10.0, *)
public class TCEffectsView : UIVisualEffectView {
    private var animator: UIViewPropertyAnimator!
    
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration:1, curve:.linear){[unowned self] in self.effect = effect}
        animator.fractionComplete = intensity
        if #available(iOS 11.0, *) {
            animator.pausesOnCompletion  = true
        } else {
           
        }

    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
