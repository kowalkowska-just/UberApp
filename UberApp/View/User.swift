//
//  User.swift
//  UberApp
//
//  Created by Justyna Kowalkowska on 10/11/2020.
//
import CoreLocation

enum AccountType: Int {
    case passenger
    case driver
}

struct User {
    let uid: String
    let fullname: String
    let email: String
    var accountType: AccountType!
    var location: CLLocation?
    var homeLocation: String?
    var workLocation: String?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        if let home = dictionary["homeLocation"] as? String {
            self.homeLocation = home
        }
        
        if let work = dictionary["workLocation"] as? String {
            self.workLocation = work
        }
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
