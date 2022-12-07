//
//  SplashScreenView.swift
//  Crew Task
//
//  Created by Puvi1046 on 04/08/22.
//

import SwiftUI
import AppearanceFramework

struct SplashScreenView: View {
    @State var isActive : Bool = false
    var body: some View {
        if isActive {
            PLMMainView()
        } else {
            ZStack {
                    LinearGradient(gradient: Gradient(colors: [TCAppearance.shared.theme.change.primaryGradiantColor1, TCAppearance.shared.theme.change.primaryGradiantColor2]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    Image("Polygon")
                    Image("LaunchScreenLogo")
                    

            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}


