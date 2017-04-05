//
//  PersonModel.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/3/17.
//
//

import Foundation
import MySQLStORM
import StORM
import SwiftSQL
import PerfectLib

public class PersonModel: MySQLStORM {
    
    //:NOTE: The primary key is first property defined in the class.

    public var ssn: String = "default"
    public var name: String = "default"
    public var gender: String = "default"
    
    public var date_of_birth: Double = 0
    
    public var date_of_death: Double?
    
    
    func setDateOfBirth(_ date: Date) {
        date_of_birth = date.timeIntervalSince1970
    }
    
    
    func setDateOfDeath(_ date: Date) {
        date_of_death = date.timeIntervalSince1970
    }
    
    override open func table() -> String { return Person_Table.tableName }
    
    override init() {
        super.init()
    }
    
    init(_ ssn: String, name: String, gender: String, dateOfBirth: Double, dateOfDeath: Double) {
        super.init()
        self.ssn = ssn
        self.name = name
        self.gender = gender
        self.date_of_birth = dateOfBirth
        self.date_of_death = dateOfDeath
        
    }
    
    override public func to(_ this: StORMRow) {

        ssn = this.data[Person_Table.ssnColumn] as? String ?? "default"
        name = this.data[Person_Table.nameColumn] as? String ?? "default"
        gender = this.data[Person_Table.genderColumn] as? String ?? "default"
        date_of_birth = this.data[Person_Table.date_of_birthColumn] as? Double ?? 0
        date_of_death = this.data[Person_Table.date_of_deathColumn] as? Double ?? 0
    }
    
    func rows() -> [PersonModel] {
        var rows = [PersonModel]()
        for i in 0..<self.results.rows.count {
            let row = PersonModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }

}
