//
//  UserStore.swift
//  TicketLion_Consumer
//
//  Created by Jaehui Yu on 2023/09/12.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
class UserStore: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordCheck: String = ""
    @Published var name: String = ""
    @Published var birth: String = ""
    @Published var phoneNumber: String = ""
    
    
    @Published var appliedSeminars: [String] = []
    @Published var favoriteSeminars: [String] = []
    @Published var recentlySeminars: [String] = []
    @Published var canceledSeminars: [String] = []
    
    @Published var isCompleteSignUp = false
    
    @Published var currentUser: Firebase.User?
    
    @Published var loginSheet: Bool = false
    
    var db = Firestore.firestore()
    
    @Published var appliedSeminarDetails: [Seminar] = []
    @Published var favoriteSeminarDetails: [Seminar] = []
    @Published var canceledSeminarDetails: [Seminar] = []
    @Published var recentlySeminarsDetails: [Seminar] = []
    
    
    // 회원가입
    func signUpUser(name: String, email: String, password: String, phoneNumber: String, birth: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("회원가입 실패: \(error.localizedDescription)")
            } else if (authResult?.user) != nil {
                // 회원가입 성공
                let uuid = UUID().uuidString
                let user = User(id: uuid, name: name, phoneNumber: phoneNumber, email: email, password: password, birth: birth, appliedSeminars: [], favoriteSeminars: [], recentlySeminars: [], canceledSeminars: [])
                
                let userDictionary: [String: Any] = [
                    "id": user.id,
                    "name": user.name,
                    "phoneNumber": user.phoneNumber,
                    "email": user.email,
                    "password": user.password,
                    "birth": user.birth,
                    "appliedSeminars": user.appliedSeminars,
                    "favoriteSeminars": user.favoriteSeminars,
                    "recentlySeminars": user.recentlySeminars,
                    "canceledSeminars": user.canceledSeminars
                ]
                
                // Firestore에 데이터 추가 (이메일을 문서 ID로 사용)
                let db = Firestore.firestore()
                db.collection("users").document(email).setData(userDictionary) { error in
                    if error != nil {
                        print("회원가입 실패")
                    } else {
                        self.isCompleteSignUp = true
                    }
                }
            }
        }
    }
    
    // 사용자 정보 가져오기
    func fetchUserInfo() {
        guard let currentUser = currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(currentUser.email ?? currentUser.uid)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.name = userData?["name"] as? String ?? ""
                self.phoneNumber = userData?["phoneNumber"] as? String ?? ""
                self.favoriteSeminars = userData?["favoriteSeminars"] as? [String] ?? []
                self.appliedSeminars = userData?["appliedSeminars"] as? [String] ?? []
                self.recentlySeminars = userData?["recentlySeminars"] as? [String] ?? []
                self.canceledSeminars = userData?["canceledSeminars"] as? [String] ?? []
                self.email = userData?["email"] as? String ?? ""
                self.birth = userData?["birth"] as? String ?? ""
            } else {
                print("사용자 정보를 불러오는 중 오류가 발생했습니다.")
            }
        }
    }
    
    // 세미나 정보 가져오기
    func updateSeminarDetails() {
        
        self.appliedSeminarDetails = []
        self.favoriteSeminarDetails = []
        self.canceledSeminarDetails = []
        self.recentlySeminarsDetails = []
        
        // 신청한 세미나 정보
        for seminarID in appliedSeminars {
            db.collection("Seminar").document(seminarID).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let seminarData = document.data()
                    let category = seminarData?["category"] as? [String] ?? []
                    let name = seminarData?["name"] as? String ?? ""
                    let seminarImage = seminarData?["seminarImage"] as? String ?? ""
                    let host = seminarData?["host"] as? String ?? ""
                    let details = seminarData?["details"] as? String ?? ""
                    let maximumUserNumber = seminarData?["maximumUserNumber"] as? Int ?? 0
                    let closingStatus = seminarData?["closingStatus"] as? Bool ?? true
                    let registerStartDate = seminarData?["registerStartDate"] as? Double ?? 0
                    let registerEndDate = seminarData?["registerEndDate"] as? Double ?? 0
                    let seminarStartDate = seminarData?["seminarStartDate"] as? Double ?? 0
                    let seminarEndDate = seminarData?["seminarEndDate"] as? Double ?? 0
                    let enterUsers = seminarData?["enterUsers"] as? [String] ?? []
                    
                    let seminarDetail = Seminar(category: category, name: name, seminarImage: seminarImage, host: host, details: details, maximumUserNumber: maximumUserNumber, closingStatus: closingStatus, registerStartDate: registerStartDate, registerEndDate: registerEndDate, seminarStartDate: seminarStartDate, seminarEndDate: seminarEndDate, enterUsers: enterUsers)
                    
                    self.appliedSeminarDetails.append(seminarDetail)
                    
                } else {
                    print("세미나 정보를 불러오는 중 오류가 발생했습니다.")
                }
            }
        }
        
        // 즐겨찾기한 세미나 정보
        for seminarID in favoriteSeminars {
            db.collection("Seminar").document(seminarID).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let seminarData = document.data()
                    let category = seminarData?["category"] as? [String] ?? []
                    let name = seminarData?["name"] as? String ?? ""
                    let seminarImage = seminarData?["seminarImage"] as? String ?? ""
                    let host = seminarData?["host"] as? String ?? ""
                    let details = seminarData?["details"] as? String ?? ""
                    let maximumUserNumber = seminarData?["maximumUserNumber"] as? Int ?? 0
                    let closingStatus = seminarData?["closingStatus"] as? Bool ?? true
                    let registerStartDate = seminarData?["registerStartDate"] as? Double ?? 0
                    let registerEndDate = seminarData?["registerEndDate"] as? Double ?? 0
                    let seminarStartDate = seminarData?["seminarStartDate"] as? Double ?? 0
                    let seminarEndDate = seminarData?["seminarEndDate"] as? Double ?? 0
                    let enterUsers = seminarData?["enterUsers"] as? [String] ?? []
                    
                    let seminarDetail = Seminar(category: category, name: name, seminarImage: seminarImage, host: host, details: details, maximumUserNumber: maximumUserNumber, closingStatus: closingStatus, registerStartDate: registerStartDate, registerEndDate: registerEndDate, seminarStartDate: seminarStartDate, seminarEndDate: seminarEndDate, enterUsers: enterUsers)
                    
                    self.favoriteSeminarDetails.append(seminarDetail)
                    
                } else {
                    print("세미나 정보를 불러오는 중 오류가 발생했습니다.")
                }
            }
        }
        
        // 취소한 세미나 정보
        for seminarID in canceledSeminars {
            db.collection("Seminar").document(seminarID).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let seminarData = document.data()
                    let category = seminarData?["category"] as? [String] ?? []
                    let name = seminarData?["name"] as? String ?? ""
                    let seminarImage = seminarData?["seminarImage"] as? String ?? ""
                    let host = seminarData?["host"] as? String ?? ""
                    let details = seminarData?["details"] as? String ?? ""
                    let maximumUserNumber = seminarData?["maximumUserNumber"] as? Int ?? 0
                    let closingStatus = seminarData?["closingStatus"] as? Bool ?? true
                    let registerStartDate = seminarData?["registerStartDate"] as? Double ?? 0
                    let registerEndDate = seminarData?["registerEndDate"] as? Double ?? 0
                    let seminarStartDate = seminarData?["seminarStartDate"] as? Double ?? 0
                    let seminarEndDate = seminarData?["seminarEndDate"] as? Double ?? 0
                    let enterUsers = seminarData?["enterUsers"] as? [String] ?? []
                    
                    let seminarDetail = Seminar(category: category, name: name, seminarImage: seminarImage, host: host, details: details, maximumUserNumber: maximumUserNumber, closingStatus: closingStatus, registerStartDate: registerStartDate, registerEndDate: registerEndDate, seminarStartDate: seminarStartDate, seminarEndDate: seminarEndDate, enterUsers: enterUsers)
                    
                    self.canceledSeminarDetails.append(seminarDetail)
                    
                } else {
                    print("세미나 정보를 불러오는 중 오류가 발생했습니다.")
                }
            }
        }
        
        // 최근 본 세미나 정보
        for seminarID in recentlySeminars {
            db.collection("Seminar").document(seminarID).getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let seminarData = document.data()
                    let category = seminarData?["category"] as? [String] ?? []
                    let name = seminarData?["name"] as? String ?? ""
                    let seminarImage = seminarData?["seminarImage"] as? String ?? ""
                    let host = seminarData?["host"] as? String ?? ""
                    let details = seminarData?["details"] as? String ?? ""
                    let maximumUserNumber = seminarData?["maximumUserNumber"] as? Int ?? 0
                    let closingStatus = seminarData?["closingStatus"] as? Bool ?? true
                    let registerStartDate = seminarData?["registerStartDate"] as? Double ?? 0
                    let registerEndDate = seminarData?["registerEndDate"] as? Double ?? 0
                    let seminarStartDate = seminarData?["seminarStartDate"] as? Double ?? 0
                    let seminarEndDate = seminarData?["seminarEndDate"] as? Double ?? 0
                    let enterUsers = seminarData?["enterUsers"] as? [String] ?? []
                    
                    let seminarDetail = Seminar(category: category, name: name, seminarImage: seminarImage, host: host, details: details, maximumUserNumber: maximumUserNumber, closingStatus: closingStatus, registerStartDate: registerStartDate, registerEndDate: registerEndDate, seminarStartDate: seminarStartDate, seminarEndDate: seminarEndDate, enterUsers: enterUsers)
                    
                    self.recentlySeminarsDetails.append(seminarDetail)
                    
                } else {
                    print("세미나 정보를 불러오는 중 오류가 발생했습니다.")
                }
            }
        }
    }
    
    var passwordsMatch: Bool {
        // 두 비밀번호가 일치하는지 확인
        return password == passwordCheck
    }
    
    func isValidEmail() -> Bool {
        // [A-Z0-9a-z._%+-] 영어 대문자 소문자 특수문자까지 가능
        // @뒤에 대소문자 숫자만 가능
        // [A-Za-z] 영어 대소문자만 가능
        // {2, 30} 2~30글자까지만 허용
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.(com|co\\.kr|go\\.kr)"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var isPasswordValid: Bool {
        // 비밀번호가 최소 8자 이상, 특수문자와 숫자를 포함하는지 확인
        let passwordRegex = "^(?=.*[0-9]).{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func openAppNotificationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    /// 로그인
    @MainActor
    func login(email: String, password: String) async throws {
        do {
            var result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUser =  result.user
            self.fetchUserInfo() // 로그인 후 사용자 정보 업데이트
        } catch {
            print("\(error.localizedDescription)")
        }
        
        //		await Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
        //            if let error = error {
        //                print("error: \(error.localizedDescription)")
        //                return
        //            }
    }
    
    /// 로그아웃
    func logout() {
        
        email = ""
        password = ""
        passwordCheck = ""
        name = ""
        birth = ""
        phoneNumber = ""
        appliedSeminars = []
        favoriteSeminars = []
        recentlySeminars = []
        canceledSeminars = []
        
        currentUser = nil
        try? Auth.auth().signOut()
    }
    
    /// 오토 로그인
    func autoLogin() async {
        guard let currentUser = currentUser else { return }
        do {
            try await login(email: currentUser.email ?? "", password:"")
        } catch {
            
        }
        
    }
    
    //MARK: - 세미나 List 함수
    
    func addFavoriteSeminar(seminarID: String) {
        guard let currentUser = currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(currentUser.email ?? currentUser.uid)
        
        userRef.updateData([
            "favoriteSeminars" : favoriteSeminars + [seminarID]
        ]) { err in
            if let err = err {
                print("\(err.localizedDescription)")
            } else { print("") }
        }
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.favoriteSeminars = userData?["favoriteSeminars"] as? [String] ?? []
            } else {
                print("사용자 정보를 불러오는 중 오류가 발생했습니다.")
            }
        }
        
    }
    
    func removeFavoriteSeminar(seminarID: String) {
        guard let currentUser = currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(currentUser.email ?? currentUser.uid)
        
        userRef.updateData([
            "favoriteSeminars" : favoriteSeminars.filter { $0 != seminarID }
        ]) { err in
            if let err = err {
                print("\(err.localizedDescription)")
            } else { print("") }
        }
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.favoriteSeminars = userData?["favoriteSeminars"] as? [String] ?? []
            } else {
                print("사용자 정보를 불러오는 중 오류가 발생했습니다.")
            }
        }
    }
    
    func addSeminar(seminarID: String) {
        guard let currentUser = currentUser else {
            return
        }
        //appliedSeminars
        
        let userRef = db.collection("users").document(currentUser.email ?? currentUser.uid)
        
        userRef.updateData([
            "appliedSeminars" : appliedSeminars + [seminarID],
            "canceledSeminars" : canceledSeminars.filter { $0 != seminarID }
        ]) { err in
            if let err = err {
                print("\(err.localizedDescription)")
            } else { print("") }
        }
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.appliedSeminars = userData?["appliedSeminars"] as? [String] ?? []
                self.canceledSeminars = userData?["canceledSeminars"] as? [String] ?? []
            } else {
                print("사용자 정보를 불러오는 중 오류가 발생했습니다.")
            }
        }
    }
    
    func cancelSeminar(seminarID: String) {
        guard let currentUser = currentUser else {
            return
        }
        let userRef = db.collection("users") .document (currentUser.email ?? currentUser.uid)
        
        userRef.updateData(
            ["appliedSeminars" : appliedSeminars.filter { $0 != seminarID },
             "canceledSeminars" : canceledSeminars + [seminarID]
            ]
        ) { err in
            if let err = err {
                print("\(err.localizedDescription)")
            } else { print("") }
        }
        
        userRef .getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.appliedSeminars = userData?["appliedSeminars"] as? [String] ?? []
                self.canceledSeminars = userData?["canceledSeminars"] as? [String] ?? []
            } else {
                print ("사용자 정보를 불러오는 중 오류가 발생했습니다. ")
            }
        }
    }
    
    func addRecentlySeminar(seminarID: String) {
        guard let currentUser = currentUser else {
            return
        }
        
        let userRef = db.collection("users").document(currentUser.email ?? currentUser.uid)
        
        userRef.updateData([
            "recentlySeminars" : recentlySeminars + [seminarID]
        ]) { err in
            if let err = err {
                print("\(err.localizedDescription)")
            } else { print("") }
        }
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                self.recentlySeminars = userData?["recentlySeminars"] as? [String] ?? []
            } else {
                print("사용자 정보를 불러오는 중 오류가 발생했습니다.")
            }
        }
    }
}

