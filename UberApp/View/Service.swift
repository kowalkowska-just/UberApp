//
//  Service.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shered = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData(completion: @escaping(User) -> Void) {
        print("DEBUG: Current uid is: \(currentUid!)")
        
        REF_USERS.child(currentUid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)

            completion(user)
        }
    }
}
