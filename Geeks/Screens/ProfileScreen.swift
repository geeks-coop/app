//  SearchScreen.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI
import PhotosUI
import UIKit

struct ProfileScreen: View {
    @State var currentTab: Int = 0
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#272727")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TopSwitcher(currentTab: $currentTab, tab1: "Profile Edit", tab2: "My Arts")
                if currentTab == 0 {
                    VStack(spacing: 24) {
                        ProfileItem(image: authViewModel.me?.profile ?? 0, username: authViewModel.me?.username ?? "", id: authViewModel.me?.userId ?? "", description: authViewModel.me?.description ?? "", followers: 240, followings: authViewModel.me?.follwingUsers.count ?? 0)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 12)
                        
                        HStack(spacing: 8) {
                            NavigationLink(destination: {}) {
                                Text("Edit")
                                    .typography(size: 16, lineHeight: 20, color: Color(hex: "#1E1E1E"))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#B0FF28"))
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                showLogoutAlert = true
                            }) {
                                Text("Logout")
                                    .typography(size: 16, lineHeight: 20, color: Color(hex: "#FFFFFF"))
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#565656"))
                                    .cornerRadius(8)
                            }
                            .alert("로그아웃", isPresented: $showLogoutAlert) {
                               Button("취소", role: .cancel) { }
                               Button("확인", role: .destructive) {
                                   authViewModel.logout()
                               }
                           } message: {
                               Text("정말 로그아웃 하시겠습니까?")
                           }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                } else {
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVStack(spacing: 0) {
                            ForEach(authViewModel.me?.projects ?? [], id: \.self) { i in
                                MyArtsItem(id: "\(i)")
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .overlay {
                        VStack {
                            Spacer()
                            
                            Group {
                                NavigationLink(destination: ImageSelectionDetail().navigationBarBackButtonHidden(true)) {
                                    Text("Upload My Project")
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .typography(size: 16, weight: .medium, lineHeight: 24, color: Color(hex: "1e1e1e"))
                                }
                                .padding(16)
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#B0FF28"))
                                .cornerRadius(12)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                    }
                    .refreshable {
                        authViewModel.getMe()
                    }
                }
            }
        }
    }
}

struct ProfileItem: View {
    let image: Int
    let username: String
    let id: String
    let description: String
    let followers: Int
    let followings: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 48) {
                Image("Profile/\(image)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 81, height: 81)
                    .clipShape(Circle())
                
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("\(followers)")
                        Text("Followers")
                    }
                    .frame(maxWidth: .infinity)
                    .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                    
                    VStack(spacing: 4) {
                        Text("\(followings)")
                        Text("Followings")
                    }
                    .frame(maxWidth: .infinity)
                    .typography(size: 16, weight: .medium, lineHeight: 20, color: .white)
                }
                .frame(maxWidth: .infinity)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(username)
                        .typography(size: 20, weight: .medium, lineHeight: 24, color: .white)
                    Text(id)
                        .typography(size: 16, weight: .medium, lineHeight: 20, color: Color(hex: "#6a6a6a"))
                }
                
                Text(description)
                    .typography(size: 16, weight: .medium, lineHeight: 20, color: Color(hex: "#8b8b8b"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TagItem: View {
    let content: String
    
    var body: some View {
        NavigationLink(destination: SearchResult(keyword: content).navigationBarBackButtonHidden(true)) {
            HStack(spacing: 2) {
                Text("#")
                Text(content)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .typography(size: 14, weight: .medium, lineHeight: 18, color: Color(hex: "#8b8b8b"))
            .background(Color(hex: "#3F3E3E"))
            .cornerRadius(999) 
        }
    }
}

struct NoneNavigationTagItem: View {
    let content: String
    
    var body: some View {
        HStack(spacing: 2) {
            Text("#")
            Text(content)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .typography(size: 14, weight: .medium, lineHeight: 18, color: Color(hex: "#8b8b8b"))
        .background(Color(hex: "#3F3E3E"))
        .cornerRadius(999)
    }
}

struct ImageSelectionDetail: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("selectedImagesData") private var selectedImagesData: Data = Data()
    @State private var recentImages: [UIImage] = []
    @State private var selectedImages: [UIImage] = []
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    
    @State private var selection: Int = 0
    
    @State private var selectedIndexList: [Int] = []
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    var body: some View {
        ZStack {
            Color(hex: "#272727").ignoresSafeArea()
            
            VStack(spacing: 8) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("Icon/arrow_left")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    if recentImages.count != 0 {
                        NavigationLink(destination: ImageUploadDetail(images: selectedImages).navigationBarBackButtonHidden()) {
                            Text("Next")
                                .typography(size: 16, lineHeight: 20, color: .white)
                        }
                    } else {
                        Text("Next")
                            .typography(size: 16, lineHeight: 20, color: Color(hex: "#999999"))
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .padding(.horizontal, 16)
                
                
                VStack(spacing: 0) {
                    if selectedImages.count > 0 {
                        TabView(selection: $selection) {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                let selectedImage = selectedImages[index]
                                
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fill)
                                    .frame(maxWidth: .infinity)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page)
                    } else {
                        Rectangle()
                            .fill(Color(hex: "#2F2D2D"))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fill)
                    }
                
                    ScrollView(.vertical, showsIndicators: true) {
                        HStack {
                            Button(action: {
                                showPhotoPicker = true
                            }) {
                                HStack(spacing: 4) {
                                    Text("Album")
                                        .typography(size: 16, weight: .medium, lineHeight: 20, color: Color(hex: "#a3a3a3"))
                                    
                                    Image("Icon/dropdown")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color(hex: "#5F5F5F"))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#2F2D2D"))
                                .cornerRadius(999)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showCamera = true
                            }) {
                                Image("Icon/camera")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(hex: "#a3a3a3"))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 4), spacing: 1) {
                            ForEach(recentImages.indices, id: \.self) { index in
                                Button(action: {
                                    withAnimation(.smooth(duration: 0.2)) {
                                        if selectedImages.contains(recentImages[index]) {
                                            if selectedImages.count <= 12 {
                                                if let removeIndex = selectedImages.firstIndex(of: recentImages[index]) {
                                                    selectedImages.remove(at: removeIndex)
                                                }
                                            }
                                        } else {
                                            if selectedImages.count < 12 {
                                                selectedImages.append(recentImages[index])
                                            }
                                        }
                                    }
                                }) {
                                    Image(uiImage: recentImages[index])
                                        .resizable()
                                        .frame(maxWidth: .infinity) 
                                        .aspectRatio(1, contentMode: .fit)
                                        .clipped()
                                        .overlay(
                                           selectedImages.contains(recentImages[index]) ?
                                           ZStack {
                                               Color.black.opacity(0.5)
                                               if let index = selectedImages.firstIndex(of: recentImages[index]) {
                                                   Text("\(index + 1)")
                                                       .foregroundColor(.white)
                                                       .font(.system(size: 20, weight: .bold))
                                               }
                                           } : nil
                                       )
                                }
                                .contextMenu {
                                    Button(role: .destructive, action: {
                                        recentImages.remove(at: index)
                                    }) {
                                        Label {
                                            Text("삭제")
                                                .foregroundColor(.red)
                                        } icon: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCamera) {
            CameraView(isPresented: $showCamera, image: $recentImages)
        }
        .fullScreenCover(isPresented: $showPhotoPicker) {
            PhotoPicker(images: $recentImages, selectionLimit: 12)
        }
        .onAppear {
            loadImages()
        }
        .onChange(of: recentImages) { _, newImages in
           // 이미지 배열이 변경될 때마다 저장
            saveImages(newImages)
        }
    }
    
    private func saveImages(_ images: [UIImage]) {
        let imageDataArray = images.compactMap { image in
            return image.jpegData(compressionQuality: 0.7)
        }
       
        if let encoded = try? NSKeyedArchiver.archivedData(withRootObject: imageDataArray, requiringSecureCoding: false) {
            selectedImagesData = encoded
        }
    }
   
   // 저장된 Data를 이미지 배열로 변환
   private func loadImages() {
       if let decoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(selectedImagesData) as? [Data] {
           recentImages = decoded.compactMap { imageData in
               UIImage(data: imageData)
           }
       }
   }
}

// Photo Picker 구현
struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var images: [UIImage]
    var selectionLimit: Int
    var filter: PHPickerFilter?
    var itemProviders: [NSItemProvider] = []
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = self.selectionLimit
        configuration.filter = self.filter
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            //Dismiss picker
            picker.dismiss(animated: true)

            if !results.isEmpty {
                parent.itemProviders = []
                parent.images = []
            }
            
            parent.itemProviders = results.map(\.itemProvider)
            loadImage()
        }
        
        private func loadImage() {
            for itemProvider in parent.itemProviders {
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            self.parent.images.append(image)
                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }
                    }
                }
            }
        }
        
    }
}

// CameraView 수정
struct CameraView: View {
    @Binding var isPresented: Bool
    @Binding var image: [UIImage]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ImagePicker(isPresented: $isPresented, image: $image)
        }
    }
}

// ImagePicker로 분리
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: [UIImage]
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image.insert(image, at: 0)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

struct ImageUploadDetail: View {
    @Environment(\.presentationMode) var presentationMode
    @State var projectName: String = ""
    @State var projectShortDescription: String = ""
    @State var tags: [String] = []
    @State var projectDescription: String = ""
    
    @State var isLoading: Bool = false
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    let images: [UIImage]
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image("Icon/arrow_left")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                Button(action: {
                    if !isLoading {
                        isLoading = true
                        Task {
                            let imageResponses = await withTaskGroup(of: ImageResponse.self) { group in
                           var responses: [ImageResponse] = []
                           
                           for image in images {
                               group.addTask {
                                   do {
                                       return try await ProjectService.uploadImage(image: image)
                                   } catch {
                                       print("Upload error: \(error)")
                                       return ImageResponse(status: "failed", imageUrl: "")
                                   }
                               }
                           }
                           
                           for await response in group {
                               responses.append(response)
                           }
                           
                           return responses
                       }
                       
                       let imageUrls = imageResponses.map { $0.imageUrl }
                       
                       let createResponse = try await ProjectService.create(
                           name: projectName,
                           shortDescription: projectShortDescription,
                           description: projectDescription,
                           tags: tags,
                           images: imageUrls
                       )
                       
                       isLoading = false
                        authViewModel.getMe()
                       presentationMode.wrappedValue.dismiss()
                        }
                    }
                }) {
                    if !isLoading {
                        Text("Upload")
                            .typography(size: 16, lineHeight: 20, color: .white)
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .padding(.horizontal, 16)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 16) {
                    Input(label: "프로젝트 이름", placeholder: "프로젝트 이름을 입력해주세요", text: $projectName)
                    Input(label: "프로젝트 한 줄 소개", placeholder: "프로젝트 간단하게 설명해주세요", text: $projectShortDescription)
                    TagInput(label: "태그", placeholder: "태그를 입력해주세요", tags: $tags)
                    InputArea(label: "프로젝트 설명", placeholder: "프로젝트 설명을 입력해주세요", maxLength: 300, text: $projectDescription)
                }
                .padding(.vertical, 12)
            }
        }
    }
}

#Preview {
    ContentView()
}
