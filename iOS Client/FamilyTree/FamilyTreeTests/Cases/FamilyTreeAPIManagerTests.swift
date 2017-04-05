//
//  FamilyTreeAPIManagerTests.swift
//  FamilyTree
//
//  Created by Partho Biswas on 4/1/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import XCTest
@testable import FamilyTree

class FamilyTreeAPIManagerTests: XCTestCase {
    
    private var mPersonDetails: PersonDetails?
    private var mRelationshipDetails: RelationshipDetails?
    private var mNodeDetails: NodeDetails?
    
    override func setUp() {
        super.setUp()
        mPersonDetails = MockModelsUtil.createPersonDetails()
        mRelationshipDetails = MockModelsUtil.createRelationshipDetails()
        mNodeDetails = MockModelsUtil.createNodeDetails()
    }
    
    override func tearDown() {
        mPersonDetails = nil
        mRelationshipDetails = nil
        mNodeDetails = nil
        super.tearDown()
    }
    
    
    func testGetPersonDetails_Success_OnRealServer() {
        
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be successfull")
        mPersonDetails?.social_security_number = "UnitTestSSN"  // Prerequisit:  This given user("UnitTestSSN") should already be presend into database to pass this testcase.
        
        // when
        FamilyTreeAPIManager.getMyDetails(ssn: (mPersonDetails?.social_security_number!)!) { (person) in
            
            expectation.fulfill()
            
            XCTAssertNotNil(person, "Didn't get relationship details")
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetPersonDetails_Failure_OnRealServer() {
        
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be unsuccessfull")
        mPersonDetails?.social_security_number = Helper.getRandomString(length: 10)
        
        // when
        FamilyTreeAPIManager.getMyDetails(ssn: (mPersonDetails?.social_security_number!)!) { (person) in
            
            expectation.fulfill()
            
            if (person != nil) {
                XCTAssertNotEqual(self.mPersonDetails?.social_security_number, person?.social_security_number, "Got relationship details")
            } else {
                XCTAssertNil(person, "Got relationship details")
            }
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRelationshipDetails_Success_OnRealServer() {
        
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be unsuccessfull")
        mPersonDetails?.social_security_number = "UnitTestSSN"  // Prerequisit:  This given user("UnitTestSSN") should already be presend into database to pass this testcase.
        
        // when
        FamilyTreeAPIManager.getRelationshipDetails(ssn: (mPersonDetails?.social_security_number)!) { (relations) in
            
            expectation.fulfill()
            XCTAssertNotNil(relations, "Didn't get relationship details")
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetRelationshipDetails_Failure_OnRealServer() {
        
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be unsuccessfull")
        mPersonDetails?.social_security_number = Helper.getRandomString(length: 10)
        
        // when
        FamilyTreeAPIManager.getRelationshipDetails(ssn: (mPersonDetails?.social_security_number)!) { (relations) in
            
            expectation.fulfill()
            
            if (relations != nil) {
                XCTAssertEqual(0, relations?.count, "Got relationship details")
            } else {
                XCTAssertNil(relations, "Got relationship details")
            }
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateMe_Success_OnRealServer() {

        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be successfull")
        mPersonDetails?.social_security_number = Helper.getRandomString(length: 10)
        
        // when
        FamilyTreeAPIManager.createMe(personDetails: mPersonDetails!) { (person) in
            
            expectation.fulfill()
            
            XCTAssertNotNil(person, "Didn't get relationship details")
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateMe_Failure_OnRealServer() {
        
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be successfull")
        mPersonDetails?.social_security_number = "UnitTestSSN"  // Prerequisit:  This given user("UnitTestSSN") should already be presend into database to pass this testcase.
        
        // when
        FamilyTreeAPIManager.createMe(personDetails: mPersonDetails!) { (person) in
            
            expectation.fulfill()
            
            XCTAssertNil(person, "Didn't get relationship details")
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testCreateNode_Success_OnRealServer() {
        // given
        let expectation = self.expectation(description: "Expected load personal details from server to be successfull")
        mNodeDetails?.social_security_number = "UnitTestSSN"  // Prerequisit:  This given user("UnitTestSSN") should already be presend into database to pass this testcase.
        mNodeDetails?.relative_social_security_number = Helper.getRandomString(length: 10)
        
        // when
        FamilyTreeAPIManager.createNode(nodeDetails: mNodeDetails!) { (node) in
            
            expectation.fulfill()
            
            XCTAssertNotNil(node, "Didn't get node details")
        }
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
