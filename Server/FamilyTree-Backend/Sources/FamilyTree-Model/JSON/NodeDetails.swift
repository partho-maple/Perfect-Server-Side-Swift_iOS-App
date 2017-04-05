//
//  NodeDetails.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/5/17.
//
//

import Foundation
import ObjectMapper

class NodeDetails: Mappable {

    var social_security_number: String?
    var relative_social_security_number: String?

    var name: String?
    var gender: String?
    var date_of_birth: Double?
    var date_of_death: Double?
    
    var relation: String?
    var relation_id: Int?
    var relatives: [RelationshipDetails]?
    
    
    required init?(map: Map) {
        
    }
    
    
    init?() {
        
    }
    
    
    // Mappable
    func mapping(map: Map) {
        social_security_number  <- map[JSON_Keys.SSN]
        relative_social_security_number <- map[JSON_Keys.relative_SSN]
        name <- map[JSON_Keys.name]
        gender <- map[JSON_Keys.gender]
        date_of_birth <- map[JSON_Keys.date_of_birth]
        date_of_death <- map[JSON_Keys.date_of_death]
        relation <- map[JSON_Keys.relation_type]
        relation_id <- map[JSON_Keys.relation_id]
        relatives <- map[JSON_Keys.relatives]
    }
    
}
