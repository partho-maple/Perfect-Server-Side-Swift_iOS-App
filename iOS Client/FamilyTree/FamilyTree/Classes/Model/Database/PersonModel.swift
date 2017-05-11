//
//  PersonModel.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import ObjectMapper
import RealmSwift

final class PersonModel: Object {
    
    dynamic var ssn: String = "default"
    dynamic var name: String = "default"
    dynamic var gender: String = "default"
    
    dynamic var date_of_birth: Double = 0
    
    var date_of_death = RealmOptional<Double>()
    
    
    func setDateOfBirth(_ date: Date) {
        date_of_birth = date.timeIntervalSince1970
    }
    
    
    func setDateOfDeath(_ date: Date) {
        date_of_death = RealmOptional<Double>(date.timeIntervalSince1970)
    }
    
    override static func indexedProperties() -> [String] {
        return ["ssn"]
    }
    
    override static func primaryKey() -> String? {
        return "ssn"
    }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
//    convenience init(_ ssn: String, name: String, gender: String, dateOfBirth: Double, dateOfDeath: Double) {
//        super.init()
//        self.ssn = ssn
//        self.name = name
//        self.gender = gender
//        self.date_of_birth = dateOfBirth
//        self.date_of_death = dateOfDeath
//    }
}


extension PersonModel : Mappable {
    
    // Mappable
    func mapping(map: Map) {
        ssn <- map[JSON_Keys.SSN]
        name <- map[JSON_Keys.name]
        gender <- map[JSON_Keys.gender]
        date_of_birth <- map[JSON_Keys.date_of_birth]
        date_of_death <- map[JSON_Keys.date_of_death]
    }
}
