//
//  SearchScreen.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI

struct SearchScreen: View {
    @StateObject var authViewModel = AuthViewModel.shared
    @State var text: String = ""
    
    @State var projectList: [ProjectResponse] = []
    
    @AppStorage("recentSearch") private var recentSearchData: Data = Data()
    @State private var recentSearches: [String] = []
    
    var body: some View {
        ZStack {
            Color(hex: "#272727")
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 24) {
                    HStack(spacing: 8) {
                        SearchInput(placeholder: "검색어를 입력해주세요", text: $text)
                        if !text.isEmpty {
                            NavigationLink(destination: SearchResult(keyword: text).navigationBarBackButtonHidden(true)) {
                                Image("Icon/searchButton")
                                    .renderingMode(.template)
                                    .foregroundStyle(.white)
                            }
                            .simultaneousGesture(TapGesture().onEnded {
                                saveSearch(text)
                            })
                        } else {
                            Image("Icon/searchButton")
                                .renderingMode(.template)
                                .foregroundStyle(Color(hex: "#7A7A7A")) // 비활성화 색상
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading) {
                            Text("최근 검색어")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                                .border(width: 1, edges: [.bottom], color: Color(hex: "#eee"))
                            
                            VStack(spacing: 4) {
                                if recentSearches.count > 0 {
                                    ForEach(recentSearches.indices, id: \.self) { index in
                                        let recentSearch = recentSearches[index]
                                        
                                        NavigationLink(destination: SearchResult(keyword: recentSearch).navigationBarBackButtonHidden(true)) {
                                            Text(recentSearch)
                                                .typography(size: 16, lineHeight: 22, color: Color(hex: "#878787"))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 16)
                                                .background(Color(hex: "#222"))
                                                .cornerRadius(6)
                                        }
                                        .contextMenu {
                                            Button(role: .destructive, action: {
                                                deleteSearch(at: index)
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
                                } else {
                                    VStack {
                                        Text("최근 검색어가 없습니다.")
                                            .typography(size: 16, lineHeight: 22, color: Color(hex: "#999"))
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .onAppear {
            loadRecentSearches()
            
            Task {
                projectList = try await ProjectService.getList(limit: 10).projects
            }
        }
    }
    
    private func saveSearch(_ search: String) {
           var searches = recentSearches
           // 중복 제거
           searches.removeAll { $0 == search }
           // 최신 검색어를 앞에 추가
           searches.insert(search, at: 0)
           // 최대 10개만 유지
           if searches.count > 10 {
               searches = Array(searches.prefix(10))
           }
           
           recentSearches = searches
           
           // JSON으로 인코딩하여 저장
           if let encoded = try? JSONEncoder().encode(searches) {
               recentSearchData = encoded
           }
       }
    
    private func deleteSearch(at index: Int) {
            var searches = recentSearches
            searches.remove(at: index)
            recentSearches = searches
            saveToStorage(searches)
        }
        
        private func saveToStorage(_ searches: [String]) {
            if let encoded = try? JSONEncoder().encode(searches) {
                recentSearchData = encoded
            }
        }
       
       // 저장된 검색어 로드 함수
       private func loadRecentSearches() {
           if let decoded = try? JSONDecoder().decode([String].self, from: recentSearchData) {
               recentSearches = decoded
           }
       }
}

struct SearchResult: View {
    @Environment(\.presentationMode) var presentationMode
    
    let keyword: String
    
    @State var searchResultList: [ProjectResponse] = []
    
    @State var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color(hex: "#272727").ignoresSafeArea()
            
            VStack(spacing: 8) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image("Icon/arrow_left")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.white)
                            
                            Text(keyword)
                                .typography(size: 24, weight: .semibold, lineHeight: 28, color: .white)
                        }
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .padding(.horizontal, 16)

                ScrollView(.vertical, showsIndicators: true) {
                    if isLoading {
                        ProgressView()
                    } else {
                        if searchResultList.count <= 0 {
                            Text("결과가 없습니다.")
                        } else {
                            ForEach(searchResultList) { project in
                                MyArtsItem(
                                    id: project.id
                                )
                            }
                        }
                    }
                }
                
            }
        }
        .onAppear {
            isLoading = true
            Task {
                searchResultList = try await ProjectService.search(keyword: keyword).projects
                
                isLoading = false
            }
        }
    }
}

#Preview {
    NavigationView {
        SearchScreen()
    }
}
