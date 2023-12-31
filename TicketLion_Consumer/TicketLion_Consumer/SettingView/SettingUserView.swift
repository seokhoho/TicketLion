//
//  SettingUserView.swift
//  TicketLion_Comsumer
//
//  Created by 이승준 on 2023/09/11.
//

import SwiftUI

struct SettingUserView: View {
	@EnvironmentObject var userStore: UserStore
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://mblogthumb-phinf.pstatic.net/MjAyMzA0MjVfMjcy/MDAxNjgyMzU4NjI2Mzkw.dlSXH48cwR-1KMSXQChtFF2hkpkX9OUSv7YU6StCsr8g.j0q0ghFJp2Y20EfuidDV-H6Td3PhOo5-SJqmP2sLPvog.PNG.uguuuu/ai.png?type=w800")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .background(.gray)
                    .clipShape(Circle())
                    .frame(width: 75, height: 75)
            } placeholder: {
                ProgressView()
            }
            VStack(alignment: .leading) {
                Text(userStore.name) // 이름 업데이트
                    .font(.title2)
                    .bold()
                //Text(userStore.phoneNumber) // 전화번호 업데이트
                Text(userStore.email) // 이메일 업데이트
                //Text(userStore.birth) // 생년월일 업데이트
            }
        }
        .onAppear {
            // 뷰가 나타날 때 사용자 정보를 가져옵니다.
            userStore.fetchUserInfo()
        }
    }
}


struct SettingUserView_Previews: PreviewProvider {
    static var previews: some View {
        SettingUserView()
    }
}
