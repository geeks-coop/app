//
//  ContentView.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/11/24.
//

import SwiftUI
import Alamofire

enum Tab {
    case search, hourglass, social, profile
}

struct ContentView: View {
    @State var selection: Tab = .profile
    @StateObject private var authViewModel = AuthViewModel.shared
    
    var body: some View {
        NavigationView {
            if authViewModel.isLoading {
                // 로딩 화면
                ZStack {
                    Color(hex: "#1e1e1e")
                        .ignoresSafeArea() 
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            } else {
                if !authViewModel.isAuthenticated {
                    AuthScreen()
                } else {
                    TabView(selection: $selection) {
                        SearchScreen()
                            .tag(Tab.search)
                            .tabItem {
                                Image("Icon/search")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Search")
                            }
                        
                        HourglassScreen()
                            .tag(Tab.hourglass)
                            .tabItem {
                                Image("Icon/hourglass")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Hourglass")
                            }
                        
                        SocialScreen()
                            .tag(Tab.social)
                            .tabItem {
                                Image("Icon/social")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Social")
                            }
                        
                        ProfileScreen()
                            .tag(Tab.profile)
                            .tabItem {
                                Image("Icon/profile")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                
                                Text("Profile")
                            }
                    }
                    .tint(.white)
                    .onAppear {
                        UITabBar.appearance().unselectedItemTintColor = UIColor(hex: "7A7A7A")
                        UITabBar.appearance().backgroundColor = UIColor(hex: "1e1e1e")
                    }
                }
            }
        }
        .onAppear {
            authViewModel.getMe()
        }
    }
}


struct ErrorResponse: Codable {
    let message: String
}

#Preview {
    ContentView()
}
