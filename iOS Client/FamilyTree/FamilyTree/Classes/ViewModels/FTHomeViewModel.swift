//
//  FTHomeViewModel.swift
//  FamilyTree
//
//  Created by Partho Biswas on 5/10/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit

class FTHomeViewModel {

    var displayArray = [TreeViewNode]()
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData] = []

    
    //MARK:  Creating tree view data source here.
    
    func loadInitialNodes(_ dataList: [TreeViewData]) -> [TreeViewNode] {
        var nodes: [TreeViewNode] = []
        
        for data in dataList where data.level == 0 {
            
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.details as RelationshipDetails?
            node.isExpanded = true
            let newLevel = data.level + 1
            node.nodeChildren = loadChildrenNodes(dataList, level: newLevel, parentId: data.id)
            
            if (node.nodeChildren?.count == 0) {
                node.nodeChildren = nil
            }
            
            nodes.append(node)
        }
        
        return nodes
    }
    
    func createDataSourceWith(person: PersonDetails, relationDetails: [RelationshipDetails]) -> [TreeViewData]
    {
        var data: [TreeViewData] = []
        
        let rootNode: RelationshipDetails? = RelationshipDetails()
        rootNode?.setRelationshipDetails(ssn: person.social_security_number!, name: person.name!, gender: person.gender!, date_of_birth: person.date_of_birth, date_of_death: person.date_of_death, relation: "It's Me", relation_id: 0, relatives: nil)
        
        data.append(TreeViewData(level: 0, details: rootNode!, id: (rootNode?.social_security_number)!, parentId: "-1")!)
        
        return self.addNodeToDataSourceWith(lavel: 0, relations: relationDetails, parentID: (rootNode?.social_security_number)!, currentNodeList: &data)
        
    }
    
    
    func addNodeToDataSourceWith(lavel: Int, relations: [RelationshipDetails], parentID: String, currentNodeList: inout [TreeViewData]) -> [TreeViewData] {
        
        for relation in relations {
            
            currentNodeList.append(TreeViewData(level: (lavel + 1), details: relation, id: (relation.social_security_number)!, parentId: parentID)!)
            
            if (relation.relatives != nil) {
                self.addNodeToDataSourceWith(lavel: (lavel + 1), relations: relation.relatives!, parentID: relation.social_security_number!, currentNodeList: &currentNodeList)
            }
            
        }
        return currentNodeList
    }
    
    //MARK:  Recursive Method to Create the Children/Grandchildren....  node arrays
    
    func loadChildrenNodes(_ dataList: [TreeViewData], level: Int, parentId: String) -> [TreeViewNode] {
        var nodes: [TreeViewNode] = []
        
        for data in dataList where data.level == level && data.parentId == parentId {
            
            let node: TreeViewNode = TreeViewNode()
            node.nodeLevel = data.level
            node.nodeObject = data.details as RelationshipDetails?
            
            node.isExpanded = false
            
            let newLevel = level + 1
            node.nodeChildren = loadChildrenNodes(dataList, level: newLevel, parentId: data.id)
            
            if (node.nodeChildren?.count == 0) {
                node.nodeChildren = nil
            }
            
            nodes.append(node)
        }
        
        return nodes
    }
    
    
    //MARK:  API calls Functions
    func fetchLoadFamilyTreeData(ssn: String, completionHandler:@escaping (Bool) -> ()) {
        do {
            FamilyTreeAPIManager.getMyDetails(ssn: ssn) { (person) in
                if (person != nil) {
                    print((person?.toJSONString(prettyPrint: true))! as String)
                    
                    do {
                        FamilyTreeAPIManager.getRelationshipDetails(ssn: (person?.social_security_number)!) { (relations) in
                            if (relations != nil) {
                                print((relations?.toJSONString(prettyPrint: true))! as String)
                                
                                //MARK:  Creating tree datasource here.
                                self.nodes = self.loadInitialNodes(self.createDataSourceWith(person: person!, relationDetails: relations!))
                                self.LoadDisplayArray()
                                
                                DispatchQueue.main.async {
//                                    ARSLineProgress.hide()
//                                    self.famityTreeTableView.reloadData()
//                                    self.showNoDataFoundViewIfNeeded(self.displayArray.count)
                                    completionHandler(true)
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completionHandler(false)
                        }
                        print("Couldn't fetch relationship details for " + (person?.social_security_number)!)
                    }
                    
                }
            }
        } catch {
            DispatchQueue.main.async {
                completionHandler(false)
            }
            print("Couldn't fetch personal details for " + ssn)
        }
    }
    
    
    
    func LoadDisplayArray() {
        self.displayArray = [TreeViewNode]()
        for node: TreeViewNode in nodes {
            self.displayArray.append(node)
            if (node.isExpanded == true) {
                self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
            }
        }
    }
    
    func addChildrenArray(_ childrenArray: [TreeViewNode]) {
        for node: TreeViewNode in childrenArray {
            self.displayArray.append(node)
            if (node.isExpanded == true ) {
                if (node.nodeChildren != nil) {
                    self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
                }
            }
        }
    }
    
}
