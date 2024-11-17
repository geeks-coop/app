//  SearchScreen.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI

struct SocialScreen: View {
    @State var currentTab: Int = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#272727")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TopSwitcher(currentTab: $currentTab, tab1: "Chatting", tab2: "Notification")
                if currentTab == 0 {
                    LazyVStack(spacing: 12) {
                        ForEach(1...4, id: \.self) { _ in
                            ChattingItem(image: "https://www.shutterstock.com/image-photo/beautiful-golden-retriever-cute-puppy-260nw-2526542701.jpg", username: "권지원", content: "뭐해", time: "방금 전")
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(1...4, id: \.self) { _ in
                            NotificationItem(image: "https://www.shutterstock.com/image-photo/beautiful-golden-retriever-cute-puppy-260nw-2526542701.jpg", username: "권지원", title: "인사해요!", content: "인사 받아줘요", date: "방금 전")
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct ChattingItem: View {
    let image: String
    let username: String
    let content: String
    let time: String
    
    var body: some View {
        NavigationLink(destination: {}) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(username)
                            .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                        Text(time)
                            .typography(size: 12, weight: .medium, lineHeight: 16, color: Color(hex: "#6a6a6a"))
                    }
                    
                    Text(content)
                        .typography(size: 14, weight: .medium, lineHeight: 18, color: Color(hex: "#8b8b8b"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(8)
        }
    }
}

struct NotificationItem: View {
    let image: String
    let username: String
    let title: String
    let content: String
    let date: String
    
    var body: some View {
        Button(action: {}) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        AsyncImage(url: URL(string: image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 28, height: 28)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        Text(username)
                            .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                    }
                    
                    Spacer()
                    
                    Text(date)
                        .typography(size: 12, weight: .medium, lineHeight: 16, color: Color(hex: "#6a6a6a"))
                }
                
                Text(title)
                    .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                
                Text(content)
                    .typography(size: 14, weight: .medium, lineHeight: 18, color: Color(hex: "#8b8b8b"))
            }
        }
    }
}

#Preview {
    SocialScreen()
}
