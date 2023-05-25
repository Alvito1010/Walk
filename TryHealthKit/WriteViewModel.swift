//
//  WriteViewModel.swift
//  firebaseTest
//
//  Created by Alvito . on 04/05/23.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class WriteViewModel: ObservableObject{
    
    private let ref = Database.database().reference()
    
    func pushNewValue(username: String, steps: Int) {
        ref.child("\(username)").setValue(steps)
    }
    
    func createPath(username: String, steps: Int){
        ref.child("\(username)").observeSingleEvent(of: .value){
            snapshot in if snapshot.exists(){
                print("path exists")
            } else {
                self.ref.child("\(username)").setValue(steps)
            }
        }
        
    }
    
    
}

