//
//  FamilyTreeAPI.swift
//  FamilyTree
//
//  Created by Partho Biswas on 5/11/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import Foundation
import Siesta
import SwiftyJSON

protocol FamilyTreeAPI {
    
    // MARK: API call to create myself
    func createMe(personDetails: PersonDetails, completionHandler:@escaping (_ personDetails: PersonDetails?) -> ())
    
    // MARK: API call to create relation
    func createNode(nodeDetails: NodeDetails, completionHandler:@escaping (_ nodeDetails: NodeDetails?) -> ())
    
    // MARK: API call to get my info
    func getMyDetails(ssn: String, completionHandler:@escaping (_ personDetails: PersonDetails?) -> ())
    
    // MARK: API call to get my relationship info
    func getRelationshipDetails(ssn: String, completionHandler:@escaping (_ relations: [RelationshipDetails]?) -> ())
}


class FamilyTreeAPIRequester: FamilyTreeAPI {
    
    // MARK: Configuration
    private let service = Service(baseURL: "http://" + HTTP_Server_Config.serverAddress + ":" + String(HTTP_Server_Config.letserverPort))
    init() {
        
        #if DEBUG
            // Bare-bones logging of which network calls Siesta makes:
            LogCategory.enabled = [.network]
            
            // For more info about how Siesta decides whether to make a network call,
            // and when it broadcasts state updates to the app:
            LogCategory.enabled = LogCategory.common
            
            // For the gory details of what Siesta’s up to:
            LogCategory.enabled = LogCategory.detailed
        #endif
        
        // Global configuration
        service.configure {
            $0.expirationTime = 120
        }
    }
    
    
    // MARK: API call to create myself
    func createMe(personDetails: PersonDetails, completionHandler:@escaping (_ personDetails: PersonDetails?) -> ()) {
        
        self.service.resource(API_Endpoint.createMe).request(.post, json: personDetails.toJSON()).onSuccess { (data) in
            let response = data.content
            
            let jsonRes = response as? [String: String]
            let error = jsonRes?[JSON_Keys.error]
            print(error ?? "No Error")
            
            if (error == nil) {
                let person: PersonDetails = PersonDetails(JSON: response as! [String : Any])!
                debugPrint("Response: " + String(describing: person))
                
                completionHandler(person)
            } else {
                completionHandler(nil)
            }
            
            }.onFailure { (error) in
                debugPrint("Error: " + String(describing: error))
                
                completionHandler(nil)
        }
    }
    
    
    
    // MARK: API call to create relation
    func createNode(nodeDetails: NodeDetails, completionHandler:@escaping (_ nodeDetails: NodeDetails?) -> ()) {
        
        self.service.resource(API_Endpoint.createNode).request(.post, json: nodeDetails.toJSON()).onSuccess { (data) in
            let response = data.content
            
            let jsonRes = response as? [String: String]
            let error = jsonRes?[JSON_Keys.error]
            print(error ?? "No Error")
            
            if (error == nil) {
                let node: NodeDetails = NodeDetails(JSON: response as! [String : Any])!
                debugPrint("Response: " + String(describing: node))
                
                completionHandler(node)
            } else {
                completionHandler(nil)
            }
            
            }.onFailure { (error) in
                debugPrint("Error: " + String(describing: error))
                
                completionHandler(nil)
        }
    }
    
    
    
    // MARK: API call to get my info
    func getMyDetails(ssn: String, completionHandler:@escaping (_ personDetails: PersonDetails?) -> ()) {
        
        self.service.resource(API_Endpoint.getPerson).withParam(JSON_Keys.SSN, ssn).request(.get).onSuccess { (data) in
            let response = data.content
            
            let jsonRes = response as? [String: String]
            let error = jsonRes?[JSON_Keys.error]
            print(error ?? "No Error")
            
            if (error == nil) {
                let person: PersonDetails = PersonDetails(JSON: response as! [String : Any])!
                debugPrint("Response: " + String(describing: person))
                
                completionHandler(person)
            } else {
                completionHandler(nil)
            }
            
            }.onFailure { (error) in
                debugPrint("Error: " + String(describing: error))
                
                completionHandler(nil)
        }
    }
    
    
    
    // MARK: API call to get my relationship info
    func getRelationshipDetails(ssn: String, completionHandler:@escaping (_ relations: [RelationshipDetails]?) -> ()) {
        
        self.service.resource(API_Endpoint.getRelation).withParam(JSON_Keys.SSN, ssn).request(.get).onSuccess { (data) in
            let response = data.content
            
            let jsonRes = response as? [String: String]
            let error = jsonRes?[JSON_Keys.error]
            print(error ?? "No Error")
            
            if (error == nil) {
                let relationObjects = Relations(JSON: response as! [String : Any])!
                debugPrint("Response: " + String(describing: relationObjects.relations))
                
                completionHandler(relationObjects.relations)
            } else {
                completionHandler(nil)
            }
            
            }.onFailure { (error) in
                debugPrint("Error: " + String(describing: error))
                
                completionHandler(nil)
        }
    }
}
