//
//  RelationshipModel.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import ObjectMapper
import RealmSwift

final class RelationshipModel: Object {
    
    dynamic var id: Int = 0

    dynamic var person_ssn: String = "default"
    dynamic var relative_ssn: String = "default"
    dynamic var relation: String = "default"
    dynamic var relation_id: Int = 0
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(map: Map) {
        self.init()
        mapping(map: map)
    }
}



extension RelationshipModel : Mappable {
    
    // Mappable
    func mapping(map: Map) {
        
        //TODO: To be finished
        id <- map[JSON_Keys.gender]
        person_ssn <- map[JSON_Keys.SSN]
        relative_ssn <- map[JSON_Keys.name]
        relation <- map[JSON_Keys.relation_type]
        relation_id <- map[JSON_Keys.relation_id]
    }
}
