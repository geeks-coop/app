//
//  MyArtsItem.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/14/24.
//
import SwiftUI

struct MyArtsItem: View {
    let id: String
    
    @State var project: ProjectResponse! = nil
    @State var pressedHeart: Bool = false
    
    @State var isLoading = false
    
    @State var likes: Int = 0
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    @State var isHeartLoading = false
    
    var body: some View {
        NavigationLink(destination: MyArtsDetail(id: id)) {
            VStack(spacing: 16) {
                if let imageUrl = project?.images[0].url, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        ZStack {
                            Rectangle()
                                .fill(Color(hex: "#444444"))
                                .frame(maxWidth: .infinity)
                                .frame(height: 361)
                            
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                GeometryReader { geometry in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: geometry.size.width, height: 361)
                                        .clipped()
                                        .position(
                                            x: geometry.size.width / 2,
                                            y: 361 / 2
                                        )
                                }
                                .frame(height: 361)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(.white)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    }
                    
                    .overlay {
                        VStack {
                            Spacer()
                            
                            VStack(alignment: .leading) {
                                Spacer()
                                
                                Text(project?.name ?? "")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 20)
                            .background(
                                LinearGradient(
                                    stops: [
                                        .init(color: Color(hex: "#000000").opacity(0.01), location: 0),
                                        .init(color: Color(hex: "#000000").opacity(0.8), location: 1)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                } else {
                    defaultImageView
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image("Profile/\(project?.createdByProfile ?? 0)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 24, height: 24)
                            .clipShape(Circle())
                        
                        Text(project?.createdBy ?? "")
                            .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                    }
                    
                    Spacer()
                    
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
                    .disabled(isHeartLoading || isLoading)
                }
                
                FlowLayout {
                    ForEach(project?.tags ?? [], id: \.self) {
                        TagItem(content: $0)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .onAppear {
            isLoading = true
            Task {
                project = try await ProjectService.get(id: id).project
                
                if project != nil {
                    let response = try await ProjectService.getHeartUsers(projectId: project.id)
                    likes = response.count
                    pressedHeart = response.contains(authViewModel.me?.userId ?? "")
                }
                isLoading = false
            }
        }
    }
    
    private var defaultImageView: some View {
           ZStack {
               Color(hex: "#444444")
               
               Image(systemName: "photo")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 48, height: 48)
                   .foregroundColor(.white)
           }
           .frame(maxWidth: .infinity) // UIScreen.main.bounds.width 대신 maxWidth 사용
            .frame(height: 361)
           .overlay {
               VStack {
                   Spacer()
                   
                   VStack(alignment: .leading) {
                       Spacer()
                       
                       Text(project?.name ?? "")
                           .frame(maxWidth: .infinity, alignment: .leading)
                           .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                   }
                   .frame(maxWidth: .infinity)
                   .frame(height: 100)
                   .padding(.horizontal, 24)
                   .padding(.vertical, 20)
                   .background(
                       LinearGradient(
                           stops: [
                               .init(color: Color(hex: "#000000").opacity(0.01), location: 0),
                               .init(color: Color(hex: "#000000").opacity(0.8), location: 1)
                           ],
                           startPoint: .top,
                           endPoint: .bottom
                       )
                   )
               }
           }
           .clipShape(RoundedRectangle(cornerRadius: 24))
       }
    
    func cropImageToCenterSquare(_ image: UIImage) -> UIImage? {
        let imageSize = image.size
        let shortLength = min(imageSize.width, imageSize.height)
        
        let origin = CGPoint(
            x: imageSize.width / 2,
            y: imageSize.height / 2
        )
        
        // 잘라낼 사각형 크기를 정사각형으로 설정
        let square = CGRect(origin: origin, size: CGSize(width: shortLength/2, height: shortLength/2))
        
        guard let cgImage = image.cgImage?.cropping(to: square) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
