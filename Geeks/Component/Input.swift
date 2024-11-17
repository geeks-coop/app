//
//  Input.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/12/24.
//

import SwiftUI

struct Input: View {
    let label: String
    let placeholder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(label)
                .typography(size: 16, lineHeight: 24, color: .white)
            
            TextField(text: $text, prompt: Text(placeholder)) {
                Text(label)
                    .typography(size: 16, lineHeight: 24, color: .white)
            }
            .textInputAutocapitalization(.never)
            .padding(16)
            .background(Color(hex: "#2F2D2D"))
            .cornerRadius(8)
        }
        .padding(.horizontal, 16)
    }
}

struct SearchInput: View {
   let placeholder: String
   @Binding var text: String
   
   var body: some View {
       TextField(placeholder, text: $text)
           .textInputAutocapitalization(.never)
           .typography(size: 16, lineHeight: 24, color: .white)
           .padding(.horizontal, 16)
           .padding(.vertical, 4)
           .background(Color(hex: "#2F2D2D"))
           .cornerRadius(8)
   }
}

struct SecureInput: View {
   let label: String
   let placeholder: String
   
   @Binding var text: String
   @State private var isSecure: Bool = true
   
   var body: some View {
       VStack(alignment: .leading, spacing: 16) {
           Text(label)
               .typography(size: 16, lineHeight: 24, color: .white)
           
           HStack {
               if isSecure {
                   SecureField(placeholder, text: $text)
                       .typography(size: 16, lineHeight: 24, color: .white)
                       .frame(height: 22)
               } else {
                   TextField(placeholder, text: $text)
                       .typography(size: 16, lineHeight: 24, color: .white)
                       .frame(height: 22)
               }
               
               Button(action: {
                   isSecure.toggle()
               }) {
                   Image(systemName: isSecure ? "eye.slash" : "eye")
                       .foregroundColor(Color(hex: "#8B8B8B"))
                       .typography(size: 16, lineHeight: 24, color: .white)
               }
           }
           .padding(16)
           .background(Color(hex: "#2F2D2D"))
           .cornerRadius(8)
       }
       .padding(.horizontal, 16)
   }
}

struct TagInput: View {
    let label: String
    let placeholder: String
    
    @Binding var tags: [String]
    @State var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(label)
                .typography(size: 16, lineHeight: 24, color: .white)
            
            VStack(alignment: .leading, spacing: 12) {
                if !tags.isEmpty {
                    FlowLayout(spacing: 8) {
                        ForEach(tags, id: \.self) { tag in
                            Button(action: {
                                tags.removeAll { $0 == tag }
                            }) {
                                NoneNavigationTagItem(content: tag) 
                            }
                        }
                    }
                }
                
                TextField(text: $text, prompt: Text(placeholder)) {
                    Text(label)
                        .typography(size: 16, lineHeight: 24, color: .white)
                }
                .textInputAutocapitalization(.never)
                .onChange(of: text) { oldValue, newValue in
                    if newValue.contains(",") || newValue.contains(" ") {
                        let newTags = newValue.components(separatedBy: [",", " "])
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                            .filter { !$0.isEmpty && !tags.contains($0) } // 빈 문자열과 중복 제거

                        tags.append(contentsOf: newTags)

                        text = ""
                    }
                }
                .padding(16)
                .background(Color(hex: "#2F2D2D"))
                .cornerRadius(8)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct InputArea: View {
   let label: String
   let placeholder: String
   let maxLength: Int
   
   @Binding var text: String
   @State private var currentLength: Int = 0
   
   var body: some View {
       VStack(alignment: .leading, spacing: 16) {
           HStack {
               Text(label)
                   .typography(size: 16, lineHeight: 24, color: .white)
               
               Spacer()
               
               Text("\(currentLength)/\(maxLength)")
                   .typography(size: 14, lineHeight: 20, color: Color(hex: "#8B8B8B"))
           }
           
           TextEditor(text: Binding(
               get: { text },
               set: { newValue in
                   let filtered = String(newValue.prefix(maxLength))
                   text = filtered
                   currentLength = filtered.count
               }
           ))
           .textInputAutocapitalization(.never)
           .frame(height: 240)
           .padding(16)
           .typography(size: 16, lineHeight: 24, color: .white)
           .scrollContentBackground(.hidden)
           .background(Color(hex: "#2F2D2D"))
           .cornerRadius(8)
           .onChange(of: text) { _, newValue in
               currentLength = newValue.count
           }
           
           // Placeholder Text
           .overlay(
               ZStack {
                   if text.isEmpty {
                       Text(placeholder)
                           .typography(size: 16, lineHeight: 24, color: Color(hex: "#8B8B8B"))
                           .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                           .padding(24)
                   }
               }
           )
       }
       .padding(.horizontal, 16)
   }
}

#Preview {
    VStack {
        InputArea(
                   label: "프로젝트 설명",
                   placeholder: "프로젝트에 대해 설명해주세요",
                   maxLength: 500,
                   text: .constant("")
               )
    }
}
