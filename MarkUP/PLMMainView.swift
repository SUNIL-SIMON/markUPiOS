// PLMMainView.swift
// Task
//
// Created by SIMON on 10/11/21.
//
import Foundation
import SwiftUI
import AppearanceFramework
struct PLMMainView: View {
    @ObservedObject var presenter = PLMPresenter.shared
    var tabContentsView : PLMTabContentsView!
    @State var offlineBanner = false
    @State var onlineBanner = false
    @State var consecutiveOnlineRollBack = false
    
    init() {
        if tabContentsView == nil{
          tabContentsView = PLMTabContentsView(_presenter: presenter)
          print("init viewset : TCtabContentsView + ")
        }
  }
  var body: some View {
      let _ = print("MAIN PAGE RELOADED")
        GeometryReader { geo in
            VStack(spacing: 0) {
                   tabContentsView
                 }
              }.edgesIgnoringSafeArea(.top)
      }
}
