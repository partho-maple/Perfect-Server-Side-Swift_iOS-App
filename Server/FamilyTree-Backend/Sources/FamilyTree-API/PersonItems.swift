//
//  PersonItems.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import SwiftSQL

struct PersonItems {

    func create(ssn: String, name: String, gender: String, date_of_birth: Double?, date_of_death: Double?) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do  {
            let newItem = try PersonManager().create(ssn: ssn, name: name, gender: gender, date_of_birth: date_of_birth, date_of_death: date_of_death)
            
            let person = PersonDetails()
            person?.setPersonDetails(newItem)
            
            let json = person?.toJSONString(prettyPrint: true)
            response = json!
            
        } catch {
            response = "{\"error\": \"An Unknown Error Occured\"}"
        }
        
        return response
    }
    
    
    func getPerson(forSSN ssn: String) -> String {
        var response = "{\"error\": \"An Unknown Error Occured\"}"
        
        do {
            let newItem = try PersonManager().get(forSSN: ssn)
            
            let person = PersonDetails();
            person?.setPersonDetails(newItem)
            let json = person?.toJSONString(prettyPrint: true)
            response = json!
            
        } catch {
            response = "{\"error\": \"Failed to get\"}"
        }
        
        return response
    }
    
    
}
