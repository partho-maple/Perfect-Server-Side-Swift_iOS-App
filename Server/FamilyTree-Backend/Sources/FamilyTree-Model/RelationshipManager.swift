//
//  RelationshipManager.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import SwiftSQL
import PerfectTurnstileMySQL

public struct RelationshipManager {
    
    public init() {  }
    
    
    public func create(person_ssn: String, relative_ssn: String, relation: String, relation_id: Int) throws -> RelationshipModel {
        let obj = RelationshipModel()
        
        obj.person_ssn = person_ssn
        obj.relative_ssn = relative_ssn
        obj.relation = relation
        obj.relation_id = relation_id
        
        
        do {
            try obj.create()
        } catch {
            throw error
        }
        
        return obj
    }
    
}
