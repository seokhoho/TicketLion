//
//  SeminalListStore.swift
//  TicketLion_Admin
//
//  Created by 아라 on 2023/09/06.
//

import Foundation
import FirebaseFirestore

class SeminarListStore: ObservableObject {
    @Published var seminarList: [Seminar] = []
    
    let dbRef = Firestore.firestore()
    
    let currentDate = Date().timeIntervalSince1970
    
    var recruitingList: [Seminar] {
        seminarList.filter { $0.registerEndDate >= currentDate && !$0.closingStatus}
    }
    
    var closedList: [Seminar] {
        seminarList.filter { $0.registerEndDate < currentDate || $0.closingStatus}
    }
    
    func fetch() {
        dbRef.collection("Seminar").getDocuments { (snapshot, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            var temp: [Seminar] = []
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                       let seminarData = try? JSONDecoder().decode(Seminar.self, from: jsonData) {
                        temp.append(seminarData)
                    }
                }
                self.seminarList = temp
                self.seminarList.sort { $0.createdAt > $1.createdAt }
            }
        }
    }
    
    func calculateDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    func selectSeminar(id: String) -> Seminar? {
        seminarList.first { $0.id == id }
    }
}
