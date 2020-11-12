//
//  Service.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import Firebase
import CoreLocation

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")

struct Service {
    
    static let shered = Service()
    
    func fetchUserData(completion: @escaping(User) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        print("DEBUG: Current uid is: \(currentUid)")
        REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)

            completion(user)
        }
    }
}
