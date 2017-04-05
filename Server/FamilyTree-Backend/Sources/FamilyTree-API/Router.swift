//
//  Router.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

import MySQLStORM
import StORM

import SwiftSQL
import ObjectMapper


struct Router {
    func makeRoutes() -> Routes {
        
        var routes = Routes()
        
        
        routes.add(method: .post, uri: API_Endpoint.createMe, handler: {    //  OK
            request, response in
            
            var responder = "{\"error\": \"Failed to create\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode().jsonEncodedString() {
                    
                    let person: PersonDetails = PersonDetails(JSONString: json)!
                    
                    let dateOfBirth = person.date_of_birth
                    let dateOfDeath = person.date_of_death
                    
                    responder = PersonItems().create(ssn: (person.social_security_number!), name: (person.name!), gender: (person.gender!), date_of_birth: dateOfBirth, date_of_death: dateOfDeath)
                }
                
            } catch {
                responder = "{\"error\": \"Failed to create\"}"
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
            
        })
        
        
        routes.add(method: .post, uri: API_Endpoint.createNode, handler: {  //OK
            request, response in
            
            var responder = "{\"error\": \"Failed to create\"}"
            
            do {
                if let json = try request.postBodyString?.jsonDecode().jsonEncodedString() {
                    
                    let node: NodeDetails = NodeDetails(JSONString: json)!
                    
                    if (node.relation_id == nil) {
                        node.relation_id = 0
                    }
                    if (node.date_of_death == nil) {
                        node.date_of_death = 0
                    }
                    let relationshipResponder = RelationshipItems().create(person_ssn: node.social_security_number!, relative_ssn: node.relative_social_security_number!, relation: node.relation!, relation_id: Int(node.relation_id!))
                    
                    
                    
                    let jsonRes2 = try relationshipResponder.jsonDecode() as? [String: String]
                    let error2 = jsonRes2?[JSON_Keys.error]
                    
                    if (error2 == nil) {
                        
                        let dateOfBirth = person.date_of_birth
                        let dateOfDeath = person.date_of_death
                        
                        let personResponder = PersonItems().create(ssn: node.relative_social_security_number!, name: node.name!, gender: node.gender!, date_of_birth: dateOfBirth, date_of_death: dateOfDeath)

                        responder = node.toJSONString()!
                    }
                    
                }
                
            } catch {
                responder = "{\"error\": \"Failed to create\"}"
            }
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
            
        })
        
        routes.add(method: .get, uri: API_Endpoint.getPerson, handler: {  // OK
            request, response in
            
            var responder = "{\"error\": \"Failed to get person\"}"

            
            let ssn = request.param(name: JSON_Keys.SSN, defaultValue: nil)
            if (ssn != nil) {
                
                responder = PersonItems().getPerson(forSSN: ssn!)
            }
            
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
        })
        
        routes.add(method: .get, uri: API_Endpoint.getRelation, handler: {
            request, response in
            
            var responder = "{\"error\": \"Failed to get person\"}"

            
            let ssn = request.param(name: JSON_Keys.SSN, defaultValue: nil)
            if (ssn != nil) {
                
                responder = RelationshipItems().getAllRelationshipDetails(forSSN: ssn!)
            }
            
            
            response.setHeader(.contentType, value: "application/json")
            response.appendBody(string: responder)
            response.completed()
        })
        
        
        return routes
        
    }

}
