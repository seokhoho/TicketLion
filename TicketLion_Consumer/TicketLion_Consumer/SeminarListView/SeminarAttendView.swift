//
//  SeminarAttendView.swift
//  TicketLion_Comsumer
//
//  Created by 윤진영 on 2023/09/06.
//

import SwiftUI

struct SeminarAttendView: View {
    @Binding var seminar: Seminar
    let user: User
    @Binding var isShowingDetail: Bool
    @EnvironmentObject var userStore: UserStore
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("신청한 세미나")
                            .font(.title3)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        
                        SeminarInfoView(seminar: seminar)
                    }
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("신청자 정보")
                            .font(.title3)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                        
                        Grid(alignment: .topLeading) {
                            GridRow {
                                Text("이름")
                                    .modifier(textStyle())
                                
                                Text("\(userStore.name)")
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                            
                            GridRow {
                                Text("이메일")
                                    .modifier(textStyle())
                                
                                Text("\(userStore.email)")
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                            
                            GridRow {
                                Text("전화번호")
                                    .modifier(textStyle())
                                
                                Text("\(userStore.phoneNumber)")
                            }
                        }
                    }.padding()
                    Divider()
					SeminarAttendPlusView(seminar: $seminar, isShowingDetail: $isShowingDetail)
                }.navigationTitle("신청하기")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct SeminarAttendView_Previews: PreviewProvider {
    static var previews: some View {
		SeminarAttendView(seminar: .constant(Seminar.TempSeminar), user: User.usersDummy[0], isShowingDetail: .constant(true)).environmentObject(UserStore())

    }
}
