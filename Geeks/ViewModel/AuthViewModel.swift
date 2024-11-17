//
//  AuthViewModel.swift
//  Geeks
//
//  Created by  jwkwon0817 on 11/14/24.
//
import Foundation
import Alamofire

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String? = ""
    @Published var isLoginLoading = false
    @Published var isSignupLoading = false
    @Published var me: MeResponse? = nil
   
   static let shared = AuthViewModel()
   
   init() {
       checkAuthentication()
   }
   
    private func checkAuthentication() {
        Task {
            isLoading = true  // 체크 시작 전 로딩 상태 true
            do {
                let _: EmptyResponse = try await APIClient.shared.request("/project/list", authRequired: true)
                isAuthenticated = true
            } catch {
                if let afError = error as? AFError,
                   let statusCode = afError.responseCode,
                   statusCode == 401 {
                    isAuthenticated = false
                    getMe()
                }
            }
            isLoading = false  // 체크 완료 후 로딩 상태 false
        }
    }
   
   func login(userId: String, password: String) {
       Task {
           isLoginLoading = true
           do {
               errorMessage = nil
               
               let response = try await AuthService.login(userId: userId, password: password)
               
               if KeychainHelper.update(token: response.accessToken, forAccount: "accessToken") {
                   isAuthenticated = true
               }
           } catch {
               isAuthenticated = false
               errorMessage = "아이디 또는 비밀번호가 맞지 않습니다."
               isLoginLoading = false
               throw error
           }
           isLoginLoading = false
       }
   }
    
    func signup(userId: String, nickname: String, password: String) {
        Task {
            isLoginLoading = true
            do {
                errorMessage = nil
                
                let response = try await AuthService.signup(userId: userId, nickname: nickname, password: password)
                
                if KeychainHelper.update(token: response.accessToken, forAccount: "accessToken") {
                    isAuthenticated = true
                }
            } catch {
                isAuthenticated = false
                errorMessage = "형식이 잘못되었습니다."
                isLoginLoading = false
                throw error
            }
            isLoginLoading = false
        }
    }
    
    func getMe() {
        Task {
            do {
                let response = try await AuthService.me()
                
                print(response)
                
                me = response
            } catch {
                throw error
            }
        }
    }
    
    func logout() {
        if KeychainHelper.delete(forAccount: "accessToken") {
            isAuthenticated = false
        }
    }
}

struct EmptyResponse: Codable {}
