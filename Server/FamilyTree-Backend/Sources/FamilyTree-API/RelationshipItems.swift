//
//  RelationshipItems.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import SwiftSQL

class RelationshipItems {
    
    var ssnOfRetrivedPersons: [String] = []
    
    func create(person_ssn: String, relative_ssn: String, relation: String, relation_id: Int) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do  {
            let newItem = try RelationshipManager().create(person_ssn: person_ssn, relative_ssn: relative_ssn, relation: relation, relation_id: relation_id)
            
            let json: [String: Any] = [JSON_Keys.relation_id: "\(newItem.relation_id)", JSON_Keys.SSN: "\(newItem.person_ssn)", JSON_Keys.relative_SSN: newItem.relative_ssn, JSON_Keys.relation_type: "\(newItem.relation)"]
            
            response = try json.jsonEncodedString()
        } catch {
            
        }
        
        return response
    }
    
    
    public func getAllRelationshipDetails(forSSN ssn: String) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            
            let relations: [Any]? = try MySQL_Manager().get_relative_details(person_ssn: ssn)
            var relationResponse: [RelationshipDetails]? = [RelationshipDetails]()
            
            self.ssnOfRetrivedPersons.append(ssn)
            
            if (relations?.count)! > 0 {
                
                for relation in relations! {
                    
                    let item: [String] = relation as! [String]
                    let relativeSSN: String = item[4]
                    
                    let relationshipDetails: RelationshipDetails = RelationshipDetails()!
                    relationshipDetails.setRelationshipDetails(ssn: item[4], name: item[0], gender: item[1], date_of_birth: Double(item[2]), date_of_death: Double(item[3]), relation: item[5], relation_id: Int(item[6]), relatives: self.getRelationFor(ssn: relativeSSN))
                    
                    relationResponse?.append(relationshipDetails)
                }
            } else {
                response = "{\"error\": \"Dont have any relation\"}"
            }
            
            let relationObjects = Relations()
            relationObjects?.setRelations(relationResponse)
            
            response = (relationObjects?.toJSONString(prettyPrint: true))!
        } catch {
            response = "{\"error\": \"Failed to get\"}"
        }
        
        self.ssnOfRetrivedPersons.removeAll()
        return response
    }
    
    
    public func getRelationFor(ssn: String) -> [RelationshipDetails]? {
        if self.ssnOfRetrivedPersons.contains(ssn) {
            return nil
        } else {
            self.ssnOfRetrivedPersons.append(ssn)
            
            do {
                
                let relations: [Any]? = try MySQL_Manager().get_relative_details(person_ssn: ssn)
                
                if (relations?.count)! > 0 {
                    var relationResponse: [RelationshipDetails]? = [RelationshipDetails]()
                    
                    for relation in relations! {
                        
                        let item: [String] = relation as! [String]
                        let relativeSSN: String = item[4]
                        
                        let relationshipDetails: RelationshipDetails = RelationshipDetails()!
                        relationshipDetails.setRelationshipDetails(ssn: item[4], name: item[0], gender: item[1], date_of_birth: Double(item[2]), date_of_death: Double(item[3]), relation: item[5], relation_id: Int(item[6]), relatives: self.getRelationFor(ssn: relativeSSN))
                        
                        relationResponse?.append(relationshipDetails)
                    }
                    
                    return relationResponse
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
}
