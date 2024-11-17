//
//  MyArtsItem.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/14/24.
//
import SwiftUI

struct MyArtsDetail: View {
    let id: String
    
    @State var project: ProjectResponse? = nil
    
    @State var pressedHeart: Bool = false
    
    @State var isLoading: Bool = false
    
    @State var timeAgo: String = ""
    
    @State var isHeartLoading = false
    
    @Environment(\.dismiss) var dismiss
    @State var likes: Int = 3
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    var body: some View {
        ZStack {
            Color(hex: "#1E1E1E")
                .ignoresSafeArea()
            
            if isLoading {
                ProgressView()
            } else {
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("Icon/arrow_left")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()

                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .padding(.horizontal, 16)
                    .ignoresSafeArea(.keyboard)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(project?.name ?? "")
                                        .typography(size: 20, lineHeight: 24, color: .white)
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 4) {
                                        Button(action: {}) {
                                            Text("Follow")
                                                .typography(size: 16, lineHeight: 20, color: Color(hex: "#1E1E1E"))
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 16)
                                                .background(Color(hex: "#B0FF28"))
                                                .cornerRadius(99)
                                        }
                                        
                                        NavigationLink(destination: {}) {
                                            Text("Message")
                                                .typography(size: 16, lineHeight: 20, color: .white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 16)
                                                .background(Color(hex: "#2D2D2D"))
                                                .cornerRadius(99)
                                        }
                                    }
                                }
                                
                                HStack {
                                    HStack(spacing: 4) {
                                        Image("Profile/\(project?.createdByProfile ?? 0)")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 24, height: 24)
                                            .clipShape(Circle())
                                        
                                        Text(project?.createdBy ?? "")
                                            .typography(size: 16, lineHeight: 20, color: .white)
                                        
                                        Spacer()
                                        
                                        
                                    }
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 8) {
                                        Text(timeAgo)
                                            .typography(size: 14, lineHeight: 18, color: Color(hex: "#a3a3a3"))
                                        
                                        Button(action: {
                                            withAnimation(.smooth(duration: 0.2)) {
                                                if project != nil {
                                                    isHeartLoading = true
                                                    Task {
                                                        do {
                                                            let response = try await ProjectService.heartProject(projectId: project!.id)
                                                            likes = try await ProjectService.getHeartUsers(projectId: project!.id).count
                                                            pressedHeart = response
                                                            
                                                            isHeartLoading = false
                                                        } catch {
                                                            throw error
                                                        }
                                                    }
                                                }
                                            }
                                        }) {
                                            HStack(spacing: 4) {
                                                Image(pressedHeart ? "Icon/Filled/heart" : "Icon/heart")
                                                    .renderingMode(.template)
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(pressedHeart ? Color(hex: "#FF5E5E") : Color(hex: "#A3A3A3"))
                                                
                                                Text("\(likes)")
                                                    .typography(size: 14, weight: .medium, lineHeight: 18, color: Color(hex: "#a3a3a3"))
                                            }
                                        }
                                        .disabled(isLoading || isHeartLoading)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            
                            VStack(spacing: 16) {
                                VStack(spacing: 0) {
                                    ForEach(project?.images ?? []) { img in
                                        if let imageUrl = img.url, let url = URL(string: imageUrl) {
                                            AsyncImage(url: url) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                VStack(spacing: 16) {
                                    Rectangle()
                                        .fill(Color(hex: "#373737"))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                    
                                    
                                    FlowLayout {
                                        ForEach(project?.tags ?? [], id: \.self) {
                                            TagItem(content: $0)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            isLoading = true
            Task {
                let response = try await ProjectService.get(id: id)
                project = response.project
                
                if project != nil {
                    let response = try await ProjectService.getHeartUsers(projectId: project!.id)
                    likes = response.count
                    pressedHeart = response.contains(authViewModel.me?.userId ?? "")
                }
                
                isLoading = false
            }
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if project != nil {
                if let date = dateFormatter.date(from: project!.createdAt) {
                    timeAgo = date.timeAgo() // "n일 전"
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
