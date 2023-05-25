//
//  ReadViewModel.swift
//  firebaseTest
//
//  Created by Alvito . on 05/05/23.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class ReadViewModel: ObservableObject {
    var ref = Database.database().reference()
    @Published var value: Int? = nil
    
    
    
    func readValue() {
        ref.child("path").observeSingleEvent(of: .value) { snapshot in
            self.value = snapshot.value as? Int ?? 3
        }
        print("read is running")
    }
    
    func observeSteps(username: String) {
        ref.child("\(username)").observe(.value) { snapshot in
            self.value = snapshot.value as? Int ?? 0
        }
    }
    
//    func observeTileChange(columnIndex: Int, rowIndex: Int, otp: String){
//        ref.child("\(otp)/\(columnIndex)\(rowIndex)").observe(.value) { snapshot in
//            self.value = snapshot.value as? Int ?? 3
//        }
//    }
    
}
