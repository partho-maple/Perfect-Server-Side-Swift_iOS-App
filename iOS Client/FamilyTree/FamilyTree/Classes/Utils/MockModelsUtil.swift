//
//  MockModelsUtil.swift
//  FamilyTree
//
//  Created by Partho Biswas on 4/2/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit

class MockModelsUtil: NSObject {

    public class func createPersonDetails() -> PersonDetails {
        var personDetails: PersonDetails?
        do {
            personDetails = try PersonDetails();
            personDetails?.social_security_number = "Partho007"
            personDetails?.name = "Partho"
            personDetails?.gender = "Male"
            personDetails?.date_of_birth = 0
            personDetails?.date_of_death = 0
            
        } catch {
            print("Got error while creating PersonDetails")
        }
        return personDetails!
    }
    
    public class func createRelationshipDetails() -> RelationshipDetails {
        var relationshipDetails: RelationshipDetails?
        do {
            relationshipDetails = try RelationshipDetails();
            relationshipDetails?.social_security_number = "Partho007"
            relationshipDetails?.name = "Partho"
            relationshipDetails?.gender = "Male"
            relationshipDetails?.date_of_birth = 0
            relationshipDetails?.date_of_death = 0
            
        } catch {
            print("Got error while creating PersonDetails")
        }
        return relationshipDetails!
    }
    
    public class func createNodeDetails() -> NodeDetails {
        var nodeDetails: NodeDetails?
        do {
            nodeDetails = try NodeDetails();
            nodeDetails?.social_security_number = "Partho007"
            nodeDetails?.relative_social_security_number = Helper.getRandomString(length: 10)
            nodeDetails?.name = "Partho"
            nodeDetails?.gender = "Male"
            nodeDetails?.date_of_birth = 0
            nodeDetails?.date_of_death = 0
            nodeDetails?.relation = "Test relation"
            nodeDetails?.relation_id = 10
            
        } catch {
            print("Got error while creating NodeDetails")
        }
        return nodeDetails!
    }
    
}
