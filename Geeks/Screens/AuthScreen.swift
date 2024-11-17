//
//  AuthScreen.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/14/24.
//

import SwiftUI

struct AuthScreen: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#1e1e1e")
                .ignoresSafeArea()
            
            VStack(spacing: 261) {
                Image("Logo")
                    .resizable()
                    .frame(width: 209, height: 116)
                
                Group {
                    NavigationLink(destination: LoginScreen().navigationBarBackButtonHidden(true)) {
                        Text("로그인")
                            .typography(size: 16, lineHeight: 24, color: .white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color(hex: "#2F2D2D"))
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .padding(.bottom, 36)
            .ignoresSafeArea(.keyboard)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoginScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var id: String = ""
    @State var password: String = ""
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
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

                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .ignoresSafeArea(.keyboard)
                
                Spacer()
                
                VStack(spacing: 120) {
                    VStack(spacing: 36) {
                        Image("Logo")
                            .resizable()
                            .frame(width: 133, height: 74)
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            VStack(spacing: 16) {
                                Input(label: "ID", placeholder: "아이디를 입력해주세요", text: $id)
                                SecureInput(label: "Password", placeholder: "비밀번호를 입력해주세요", text: $password)
                            }
                            
                            NavigationLink(destination: SignupScreen().navigationBarBackButtonHidden(true)) {
                                Text("계정이 없으신가요?")
                                    .typography(size: 14, lineHeight: 24, color: Color(hex: "#DCD6D6"))
                                    .underline()
                            }
                            .padding(.horizontal, 16)
                            .padding(.trailing, 8)
                        }
                    }
                    
                    VStack(spacing: 24) {
                        Text(authViewModel.errorMessage ?? "")
                            .typography(size: 16, lineHeight: 24, color: Color(hex: "#FF6A6A"))
                        
                        Group {
                            Button(action: {
                                authViewModel.login(userId: id, password: password)
                            }) {
                                Text("시작하기")
                                    .typography(size: 16, lineHeight: 24, color: Color(hex: "#1E1E1E"))
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(authViewModel.isLoginLoading ? Color(hex: "#6B9423") : Color(hex: "#B0FF28"))
                                    .cornerRadius(12)
                            }
                            .disabled(authViewModel.isLoginLoading)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .padding(.bottom, 36)
            .ignoresSafeArea(.keyboard)
        }
    }
}

struct SignupScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var id: String = ""
    @State var nickname: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    
    @StateObject var authViewModel = AuthViewModel.shared
    
    var body: some View {
        ZStack(alignment: .bottom) {
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

                }
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .padding(.horizontal, 16)
                .ignoresSafeArea(.keyboard)
                
                Spacer()
                
                VStack(spacing: 120) {
                    VStack(spacing: 16) {
                        Input(label: "ID", placeholder: "아이디를 입력해주세요", text: $id)
                        Input(label: "Nickname", placeholder: "닉네임을 입력해주세요", text: $nickname)
                        SecureInput(label: "Password", placeholder: "비밀번호를 입력해주세요", text: $password)
                        SecureInput(label: "Password Confirm", placeholder: "비밀번호를 다시 입력해주세요", text: $passwordConfirm)
                    }
                    
                    VStack(spacing: 24) {
                        Text(authViewModel.errorMessage ?? "")
                            .typography(size: 16, lineHeight: 24, color: Color(hex: "#FF6A6A"))
                        
                        Group {
                            Button(action: {
                                authViewModel.signup(userId: id, nickname: nickname, password: password)
                            }) {
                                Text("가입하기")
                                    .typography(size: 16, lineHeight: 24, color: Color(hex: "#1E1E1E"))
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(authViewModel.isLoginLoading ? Color(hex: "#6B9423") : Color(hex: "#B0FF28"))
                                    .cornerRadius(12)
                            }
                            .disabled(authViewModel.isLoginLoading)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
            .padding(.bottom, 36)
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    NavigationView {
        AuthScreen()
    }
}
