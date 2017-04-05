//
//  Utils.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/4/17.
//
//

import Foundation

struct JSON_Keys {

    public static let SSN = "social_security_number"
    public static let name = "name"
    public static let gender = "gender"
    public static let date_of_birth = "date_of_birth"
    public static let date_of_death = "date_of_death"
    public static let relative_SSN = "relative_social_security_number"
    public static let relation_type = "relation_type"
    public static let relation_id = "relation_id"
    public static let id = "id"
    
    public static let relatives = "relatives"
    public static let person = "person"
    
    public static let error = "error"
    
    public static let relations = "relations"
    
}

struct MySQL_Server_Config {
    public static let host		= "127.0.0.1"
    public static let username	= "root"
    public static let password	= ""
    public static let database	= "crossover_database"
    public static let port		= 3306
    
}


struct HTTP_Server_Config {
    
    public static let serverAddress = "192.168.0.103"
    public static let serverName = "localhost"
    public static let serverPort = 8181
    public static let documentRoot = "webroot"
    
}

struct API_Endpoint {
    
    public static let createMe = "/api/v1/createMe"
    public static let createNode = "/api/v1/createNode"
    public static let getPerson = "/api/v1/getPerson"
    public static let getRelation = "/api/v1/getRelation"
    
}

struct Person_Table {
    
    public static let tableName = "person_items"
    
    public static let idColumn = "id"
    public static let ssnColumn = "ssn"
    public static let nameColumn = "name"
    public static let genderColumn = "gender"
    public static let date_of_birthColumn = "dateOfBirth"
    public static let date_of_deathColumn = "dateOfDeath"
    
}

struct Relationship_Table {
    
    public static let tableName = "relarionship_items"
    
    public static let idColumn = "id"
    public static let ssnColumn = "ssn"
    public static let relative_ssnColumn = "relative_ssn"
    public static let relationColumn = "relation"
    public static let relation_idColumn = "relation_id"
    
}

struct MySQL_Queries {
    
    public static func get_relative_ssns(person_ssn: String) -> String {
        return ""
    }
    
    public static func get_relative_details(person_ssn: String) -> String {
        return "select name, gender, date_of_birth, date_of_death, relative_ssn, relation, relation_id from person_items,relarionship_items where person_items.ssn=relarionship_items.relative_ssn and relarionship_items.person_ssn='" + person_ssn + "';"
        
        
    }
    
    public static func get_person_details(person_ssn: String) -> String {
        return "select * from person_items where person_items.ssn = '" + person_ssn + "';"
    }
}













