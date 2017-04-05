//
//  main.swift
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
import PerfectTurnstileMySQL
import TurnstilePerfect

// Create HTTP server.
let server = HTTPServer()



// Set the connection properties for the MySQL Server
MySQLConnector.host		= MySQL_Server_Config.host
MySQLConnector.username	= MySQL_Server_Config.username
MySQLConnector.password	= MySQL_Server_Config.password
MySQLConnector.database	= MySQL_Server_Config.database
MySQLConnector.port		= MySQL_Server_Config.port



// Setup our Model in the Database and setup table if it doesn't exist
let person = PersonModel()
try? person.setup()

let relationship = RelationshipModel()
try? relationship.setup()



// Setup main API
let routes = Router().makeRoutes()
server.addRoutes(routes)



server.serverAddress = HTTP_Server_Config.serverAddress // Check from "System Preferrence" >> Network >> Advance >> TCP/IP
//server.serverName = HTTP_Server_Config.serverName
server.serverPort = UInt16(HTTP_Server_Config.serverPort)
server.documentRoot = HTTP_Server_Config.documentRoot


do {
    // Launch the servers based on the configuration data.
    try server.start()
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}


