//
//  PersonDetails.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/5/17.
//
//

import Foundation
import ObjectMapper
import SwiftSQL

class PersonDetails:  Mappable {

    var social_security_number: String?
    var name: String?
    var gender: String?
    var date_of_birth: Double?
    var date_of_death: Double?
    
    required init?(map: Map) {

    }
    
    
    init?() {
        
    }
    
    
    public func setPersonDetails(_ person: PersonModel) {
        self.social_security_number = person.ssn
        self.name = person.name
        self.gender = person.gender
        self.date_of_birth = person.date_of_birth
        self.date_of_death = person.date_of_death
    }

    
    // Mappable
    func mapping(map: Map) {
        social_security_number <- map[JSON_Keys.SSN]
        name <- map[JSON_Keys.name]
        gender <- map[JSON_Keys.gender]
        date_of_birth <- map[JSON_Keys.date_of_birth]
        date_of_death <- map[JSON_Keys.date_of_death]
    }
}
