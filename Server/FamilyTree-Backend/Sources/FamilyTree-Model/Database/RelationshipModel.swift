//
//  RelationshipModel.swift
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

public class RelationshipModel: MySQLStORM {
    
    //:NOTE: The primary key is first property defined in the class.

    public var id: Int = 0

    public var person_ssn: String = "default"
    public var relative_ssn: String = "default"
    public var relation: String = "default"
    public var relation_id: Int = 0
    
    
    override open func table() -> String { return Relationship_Table.tableName }
    
    
    override init() {
        super.init()
    }
    
    init(person_ssn: String, relative_ssn: String, relation: String, relation_id: Int) {
        super.init()
        self.person_ssn = person_ssn
        self.relative_ssn = relative_ssn
        self.relation = relation
        self.relation_id = relation_id
        
    }
    
    override public func to(_ this: StORMRow) {
        id = Int(this.data[Relationship_Table.idColumn] as? Int32 ?? 0)
        
        person_ssn = this.data[Relationship_Table.ssnColumn] as? String ?? "default"
        relative_ssn = this.data[Relationship_Table.relative_ssnColumn] as? String ?? "default"
        relation = this.data[Relationship_Table.relationColumn] as? String ?? "default"
        relation_id = Int(this.data[Relationship_Table.relation_idColumn] as? Int32 ?? 0)
    }
    
    func rows() -> [RelationshipModel] {
        var rows = [RelationshipModel]()
        for i in 0..<self.results.rows.count {
            let row = RelationshipModel()
            row.to(self.results.rows[i])
            rows.append(row)
        }
        return rows
    }
}
