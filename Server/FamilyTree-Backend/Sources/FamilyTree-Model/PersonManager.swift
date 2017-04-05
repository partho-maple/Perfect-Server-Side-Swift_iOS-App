//
//  PersonManager.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import SwiftSQL
import PerfectTurnstileMySQL

public struct PersonManager {
    
    public init() {  }
    
    public func create(ssn: String, name: String, gender: String, date_of_birth: Double?, date_of_death: Double?) throws -> PersonModel {
        let obj = PersonModel()
        
        obj.ssn = ssn
        obj.name = name
        obj.gender = gender
        obj.date_of_birth = date_of_birth!
        obj.date_of_death = date_of_death
        
        
        do {
            try obj.create()
        } catch {
            throw error
        }
        
        return obj
    }

    
    public func get(forSSN ssn: String) throws -> PersonModel {
        let obj = PersonModel()
        
        do {
            try obj.get(ssn)
        } catch {
            throw error
        }
        
        return obj
    }
    
    
    public func get(forSSNs SSNs: [String]) throws -> [PersonModel] {
        var items = [PersonModel]()
        
        for ssn in SSNs {
            let obj = PersonModel()
            
            do {
                try obj.get(ssn)
            } catch {
                throw error
            }
            
            items.append(obj)
        }
        
        return items
    }

}
