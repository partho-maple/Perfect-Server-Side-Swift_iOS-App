//
//  FTHomeViewController.swift
//  FamilyTree
//
//  Created by Partho Biswas on 3/14/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Foundation
import ARSLineProgress

class FTHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var famityTreeTableView: UITableView!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
    var displayArray = [TreeViewNode]()
    var indentation: Int = 0
    var nodes: [TreeViewNode] = []
    var data: [TreeViewData] = []
    private var selectedIndexPath: IndexPath? = IndexPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.famityTreeTableView.delegate = self
        self.famityTreeTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(FTHomeViewController.expandCollapseNode(_:)), name: NSNotification.Name(rawValue: "TreeNodeButtonClicked"), object: nil)
        
        let mySSN = Defaults[.mySSN]
        
        if (mySSN == nil) {
            self.showNoDataFoundViewIfNeeded(0)
        } else {
            self.fetchLoadFamilyTreeData(ssn: mySSN!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mySSN = Defaults[.mySSN]
        if (mySSN == nil) {
            self.showNoDataFoundViewIfNeeded(0)
        } else {
            self.fetchLoadFamilyTreeData(ssn: mySSN!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "TreeToDetailsSegue" {
            let indexPath: IndexPath? = (sender as? IndexPath)
            let destViewController: FTPersonDetailsTableViewController? = segue.destination as? FTPersonDetailsTableViewController
            
            do {
                let delails: RelationshipDetails? = self.displayArray[self.getIndexPathForSelectedCell()!.row].nodeObject as! RelationshipDetails
                if delails?.date_of_death == nil {
                    delails?.date_of_death = 0
                }
                
                if indexPath?.row == 0 {
                    let person: PersonDetails = try PersonDetails()!
                    person.setPersonDetails((delails?.social_security_number!)!, name: (delails?.name!)!, gender: (delails?.gender!)!, dateOfBirth: (delails?.date_of_birth!)!, dateOfDeath: (delails?.date_of_death!)!)
                    destViewController?.isShowingRelation = false
                    destViewController?.person? = person
                    destViewController?.setupWith(isShowingRelation: false, person: person, node: nil)
                } else {
                    let node: NodeDetails = try NodeDetails()!
                    node.setNodeDetails(ssn: "N/A", relative_ssn: (delails?.social_security_number!)!, name: (delails?.name!)!, gender: (delails?.gender!)!, dateOfBirth: (delails?.date_of_birth!)!, dateOfDeath: delails?.date_of_death!, relation: (delails?.relation)!, relation_id: delails?.relation_id, relatives: nil)
                    destViewController?.isShowingRelation = true
                    destViewController?.node? = node
                    destViewController?.setupWith(isShowingRelation: true, person: nil, node: node)
                }
            } catch {
                print("Couldn't create PersonDetails")
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        let mySSN = Defaults[.mySSN]
        
        if (mySSN == nil) {
            self.showNoDataFoundViewIfNeeded(0)
        } else {
            self.fetchLoadFamilyTreeData(ssn: mySSN!)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        //        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        //        let controller: FTAddPersonTableViewController = storyboard.instantiateViewController(withIdentifier: addViewControllerIdentifire) as! FTAddPersonTableViewController
        //
        //        let mySSN = Defaults[.mySSN]
        //        if (mySSN == nil) {
        //            controller.isAddingRelation = false
        //        } else {
        //            controller.isAddingRelation = true
        //        }
        //
        //        self.present(controller, animated: true, completion: nil)
        
        if let viewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: addViewControllerIdentifire) as? FTAddPersonTableViewController {
            
            let mySSN = Defaults[.mySSN]
            if (mySSN == nil) {
                viewController.isAddingRelation = false
            } else {
                viewController.isAddingRelation = true
            }
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    //MARK:  Node/Data Functions
    
    func expandCollapseNode(_ notification: Notification) {
        self.LoadDisplayArray()
        
        DispatchQueue.main.async {
            self.famityTreeTableView.reloadData()
            self.showNoDataFoundViewIfNeeded(self.displayArray.count)
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
    
    //
    //    func LoadDisplayArray() {
    //        self.displayArray = [TreeViewNode]()
    //        for node: TreeViewNode in nodes {
    //            self.displayArray.append(node)
    //            if (node.nodeChildren != nil) {
    //                node.isExpanded = true
    //                self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
    //            }
    //        }
    //    }
    //
    //    func addChildrenArray(_ childrenArray: [TreeViewNode]) {
    //        for node: TreeViewNode in childrenArray {
    //            self.displayArray.append(node)
    ////            if (node.isExpanded == false ) {
    //                if (node.nodeChildren != nil) {
    //                    node.isExpanded = true
    //                    self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
    //                }
    ////            }
    //        }
    //    }
    //
    //
    //
    //    func reloadDisplayArray() {
    //        self.displayArray = [TreeViewNode]()
    //        for node: TreeViewNode in nodes {
    //            self.displayArray.append(node)
    //            if (node.isExpanded == true) {
    //                self.reAddChildrenArray(node.nodeChildren as! [TreeViewNode])
    //            }
    //        }
    //    }
    //
    //    func reAddChildrenArray(_ childrenArray: [TreeViewNode]) {
    //        for node: TreeViewNode in childrenArray {
    //            self.displayArray.append(node)
    //            if (node.isExpanded == true ) {
    //                if (node.nodeChildren != nil) {
    //                    self.reAddChildrenArray(node.nodeChildren as! [TreeViewNode])
    //                }
    //            }
    //        }
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // MARK: - Tableview methodes
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node: TreeViewNode = self.displayArray[indexPath.row]
        let cell  = (self.famityTreeTableView.dequeueReusableCell(withIdentifier: "FamilyTreeTableViewCell") as! FamilyTreeTableViewCell)
        
        let relation = node.nodeObject as! RelationshipDetails?
        
        cell.treeNode = node
        cell.titleLable.text = relation?.name
        cell.subTitleLable.text = relation?.relation
        
        if (node.isExpanded == true) {
            cell.setTheButtonBackgroundImage(UIImage(named: "whiteOpen")!)
        } else {
            cell.setTheButtonBackgroundImage(UIImage(named: "whiteClose")!)
        }
        
        cell.setNeedsDisplay()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "TreeToDetailsSegue", sender: indexPath)
    }
    
    // MARK: - Utility methodes
    
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath:IndexPath?
        
        if self.famityTreeTableView.indexPathsForSelectedRows!.count > 0 {
            indexPath = self.famityTreeTableView.indexPathsForSelectedRows![0]
        }
        return indexPath
    }
    
    func showNoDataFoundViewIfNeeded(_ rows: Int) {
        if rows == 0 {
            let imageview = UIImageView(frame: self.view.bounds)
            imageview.contentMode = .scaleAspectFill
            let imageName: String = kTableViewBGImageName
            imageview.image = UIImage(named: imageName)
            self.famityTreeTableView.backgroundView = imageview
            self.famityTreeTableView.separatorColor = UIColor.clear
        }
        else {
            self.famityTreeTableView.backgroundView = nil
            self.famityTreeTableView.separatorColor = UIColor(red: CGFloat(214.0 / 255), green: CGFloat(213.0 / 255), blue: CGFloat(214.0 / 255), alpha: CGFloat(1.0))
        }
    }
    
    
    
    // MARK: - New Utility Methodes
    func fetchLoadFamilyTreeData(ssn: String) {
        ARSLineProgress.show()
        do {
            FamilyTreeAPIManager.getMyDetails(ssn: ssn) { (person) in
                if (person != nil) {
                    print((person?.toJSONString(prettyPrint: true))! as String)
                    
                    do {
                        FamilyTreeAPIManager.getRelationshipDetails(ssn: (person?.social_security_number)!) { (relations) in
                            if (relations != nil) {
                                print((relations?.toJSONString(prettyPrint: true))! as String)
                                
                                //  Creating datasource here.
                                self.nodes = self.loadInitialNodes(self.createDataSourceWith(person: person!, relationDetails: relations!))
                                self.LoadDisplayArray()
                                
                                DispatchQueue.main.async {
                                    ARSLineProgress.hide()
                                    self.famityTreeTableView.reloadData()
                                    self.showNoDataFoundViewIfNeeded(self.displayArray.count)
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            ARSLineProgress.hide()
                        }
                        print("Couldn't fetch relationship details for " + (person?.social_security_number)!)
                    }
                    
                }
            }
        } catch {
            DispatchQueue.main.async {
                ARSLineProgress.hide()
            }
            print("Couldn't fetch personal details for " + ssn)
        }
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
    
}
