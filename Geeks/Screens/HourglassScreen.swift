//  SearchScreen.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI

struct HourglassScreen: View {
    var body: some View {
        ZStack {
            Color(hex: "#272727")
                .ignoresSafeArea()
            
            Text("Hourglass Screen")
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    HourglassScreen()
}
