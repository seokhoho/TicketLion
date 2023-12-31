//
//  SettingSignUpEmailView.swift
//  TicketLion_Comsumer
//
//  Created by 김윤우 on 2023/09/06.
//

import SwiftUI

struct SettingSignUpEmailView: View {
    
	@EnvironmentObject var userStore: UserStore
    
//    @Binding var isCompleteSignUp: Bool
    @EnvironmentObject var router: Router
    
    
    
    var body: some View {
            NavigationStack(path: $router.path) {
                VStack(alignment: .leading, spacing: 25) {
                    Divider()
                        .background(Color("AnyButtonColor"))
                    
                    HStack {
                        Text("로그인시 사용할\n") +
                        Text("이메일 아이디").fontWeight(.bold) +
                        Text("를 입력해주세요")
                        
                        Spacer()
                        
                        Text("1/5")
                    }
                    .font(.title2)
                    
                    TextField("ex)example@google.com", text: $userStore.email)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(5)
                        .textInputAutocapitalization(.never)
                        .textContentType(.none)
                    
                    NavigationLink {
                        SettingSignUpPasswordView(/* isCompleteSignUp: $isCompleteSignUp*/)
                    } label: {
                        Text("다음")
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(userStore.isValidEmail() ? Color("AnyButtonColor") : Color.gray)
                            .cornerRadius(5)
                    }
                    .disabled(!userStore.isValidEmail())
                }
                .padding()
                .navigationTitle("회원가입")
                .navigationBarTitleDisplayMode(.inline)
                Spacer()
            }
        }
    }

struct SettingSignUpEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SettingSignUpEmailView(/* isCompleteSignUp: .constant(false) */)
        }
    }
}
