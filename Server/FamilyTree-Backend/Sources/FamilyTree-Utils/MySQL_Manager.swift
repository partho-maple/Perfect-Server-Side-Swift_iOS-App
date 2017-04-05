//
//  MySQL_Manager.swift
//  FamilyTree-Backend
//
//  Created by Partho Biswas on 3/5/17.
//
//

import Foundation
import PerfectLib
import MySQL
import PerfectHTTP

import MySQLStORM
import StORM
import PerfectTurnstileMySQL


class MySQL_Manager: NSObject {

    let dataMysql = MySQL()
    
    public func get_relative_details(person_ssn: String) throws -> [Any]? {
        
        // need to make sure something is available.
        guard dataMysql.connect(host: MySQL_Server_Config.host, user: MySQL_Server_Config.username, password: MySQL_Server_Config.password , db: MySQL_Server_Config.database, port: UInt32(MySQL_Server_Config.port)) else {
            Log.info(message: "Failure connecting to data server \(MySQL_Server_Config.host)")
            return nil
        }
        
        defer {
            dataMysql.close()  // defer ensures we close our db connection at the end of this request
        }
        
        
        // Run the Query
        let querySuccess = dataMysql.query(statement: MySQL_Queries.get_relative_details(person_ssn: person_ssn)) // Queries like >> SELECT option_name, option_value FROM options
        // make sure the query worked
        guard querySuccess else {
            Log.info(message: "Failure: \(dataMysql.errorCode()) \(dataMysql.errorMessage())")

            return nil
        }
        
        //store complete result set
        let results = dataMysql.storeResults()
        
        //setup an array to store results
        var resultArray = [[String?]]()
        
        while let row = results?.next() {
            resultArray.append(row)
            
        }
        return resultArray;
    }
}
