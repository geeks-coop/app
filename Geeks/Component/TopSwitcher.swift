//
//  TopSwitcher.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI

struct TopSwitcher: View {
    @Binding var currentTab: Int
    
    let tab1: String
    let tab2: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                currentTab = 0
            }) {
                Text(tab1)
                    .foregroundColor(currentTab == 0 ? .white : Color(hex: "#4c4c4c"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(width: 1, edges: [.bottom], color: currentTab == 0 ? .white : Color(hex: "#4c4c4c"))
            
            Button(action: {
                currentTab = 1
            }) {
                Text(tab2)
                    .foregroundColor(currentTab == 1 ? .white : Color(hex: "#4c4c4c"))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(width: 1, edges: [.bottom], color: currentTab == 1 ? .white : Color(hex: "#4c4c4c"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 54)
    }
}

#Preview {
    TopSwitcher(currentTab: .constant(0), tab1: "Tab1", tab2: "Tab2")
}
