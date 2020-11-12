//
//  User.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 10/11/2020.
//
import CoreLocation

struct User {
    let uid: String
    let fullname: String
    let email: String
    let accountType: String
    var location: CLLocation?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? String ?? ""
    }
}
