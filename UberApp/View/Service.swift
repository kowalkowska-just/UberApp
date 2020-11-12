//
//  Service.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 09/11/2020.
//

import Firebase
import CoreLocation
import GeoFire

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_DRIVER_LOCATIONS = DB_REF.child("driver-locations")

struct Service {
    
    static let shered = Service()
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        print("DEBUG: Current uid is: \(uid)")
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)

            completion(user)
        }
    }
    
    func fetchDrivers(location: CLLocation, completion: @escaping(User) -> Void) {
     
        let geofire = GeoFire(firebaseRef: REF_DRIVER_LOCATIONS)
        REF_DRIVER_LOCATIONS.observe(.value) { (snapshot) in
            geofire.query(at: location, withRadius: 50).observe(.keyEntered, with: { (uid, location) in
                print("DEBUG: Uid is \(uid)")
                print("DEBUG: Location coordinates \(location.coordinate)")

                self.fetchUserData(uid: uid) { (user) in
                    
                    var driver = user
                    
                    driver.location = location
                    completion(driver)
                }
            })
        }
    }
}
