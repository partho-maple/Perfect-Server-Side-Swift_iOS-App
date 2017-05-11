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
import Swinject

class FTHomeViewController: UIViewController {
    
    @IBOutlet weak var famityTreeTableView: UITableView!
    @IBOutlet weak var refreshBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    
//    var displayArray = [TreeViewNode]()
//    var nodes: [TreeViewNode] = []
//    var data: [TreeViewData] = []
    
    
    // Dependencies
    var homeViewModel: FTHomeViewModel!
    var familyTreeAPI: FamilyTreeAPI!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.famityTreeTableView.delegate = self
        self.famityTreeTableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(FTHomeViewController.expandCollapseNode(_:)), name: NSNotification.Name(rawValue: "TreeNodeButtonClicked"), object: nil)
        
        Defaults[.mySSN] = "Partho007"
        
        let mySSN = Defaults[.mySSN]
        
        if (mySSN == nil) {
            self.showNoDataFoundViewIfNeeded(0)
        } else {
//            self.fetchLoadFamilyTreeData(ssn: mySSN!)
            
            ARSLineProgress.show()
            self.homeViewModel.fetchLoadFamilyTreeData(ssn: mySSN!, completionHandler: { (success) in
                ARSLineProgress.hide()
                if (success) {
                    self.famityTreeTableView.reloadData()
                    self.showNoDataFoundViewIfNeeded(self.homeViewModel.displayArray.count)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let mySSN = Defaults[.mySSN]
        if (mySSN == nil) {
            self.showNoDataFoundViewIfNeeded(0)
        } else {
//            self.fetchLoadFamilyTreeData(ssn: mySSN!)
            ARSLineProgress.show()
            self.homeViewModel.fetchLoadFamilyTreeData(ssn: mySSN!, completionHandler: { (success) in
                ARSLineProgress.hide()
                if (success) {
                    self.famityTreeTableView.reloadData()
                    self.showNoDataFoundViewIfNeeded(self.homeViewModel.displayArray.count)
                }
            })
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
                let delails: RelationshipDetails? = self.homeViewModel.displayArray[self.getIndexPathForSelectedCell()!.row].nodeObject as! RelationshipDetails
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
//            self.fetchLoadFamilyTreeData(ssn: mySSN!)
            ARSLineProgress.show()
            self.homeViewModel.fetchLoadFamilyTreeData(ssn: mySSN!, completionHandler: { (success) in
                ARSLineProgress.hide()
                if (success) {
                    self.famityTreeTableView.reloadData()
                    self.showNoDataFoundViewIfNeeded(self.homeViewModel.displayArray.count)
                }
            })
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {

        
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
    
}



extension FTHomeViewController {
//    //MARK:  API calls Functions
//    func fetchLoadFamilyTreeData(ssn: String) {
//        ARSLineProgress.show()
//        do {
//            FamilyTreeAPIManager.getMyDetails(ssn: ssn) { (person) in
//                if (person != nil) {
//                    print((person?.toJSONString(prettyPrint: true))! as String)
//                    
//                    do {
//                        FamilyTreeAPIManager.getRelationshipDetails(ssn: (person?.social_security_number)!) { (relations) in
//                            if (relations != nil) {
//                                print((relations?.toJSONString(prettyPrint: true))! as String)
//                                
//                                //MARK:  Creating tree datasource here.
//                                self.nodes = self.homeViewModel.loadInitialNodes(self.homeViewModel.createDataSourceWith(person: person!, relationDetails: relations!))
//                                self.LoadDisplayArray()
//                                
//                                DispatchQueue.main.async {
//                                    ARSLineProgress.hide()
//                                    self.famityTreeTableView.reloadData()
//                                    self.showNoDataFoundViewIfNeeded(self.displayArray.count)
//                                }
//                            }
//                        }
//                    } catch {
//                        DispatchQueue.main.async {
//                            ARSLineProgress.hide()
//                        }
//                        print("Couldn't fetch relationship details for " + (person?.social_security_number)!)
//                    }
//                    
//                }
//            }
//        } catch {
//            DispatchQueue.main.async {
//                ARSLineProgress.hide()
//            }
//            print("Couldn't fetch personal details for " + ssn)
//        }
//    }
}


extension FTHomeViewController {
    //MARK:  Node/Data Functions
    func expandCollapseNode(_ notification: Notification) {
        self.homeViewModel.LoadDisplayArray()
        
        DispatchQueue.main.async {
            self.famityTreeTableView.reloadData()
            self.showNoDataFoundViewIfNeeded(self.homeViewModel.displayArray.count)
        }
    }
    
//
//    func LoadDisplayArray() {
//        self.displayArray = [TreeViewNode]()
//        for node: TreeViewNode in nodes {
//            self.displayArray.append(node)
//            if (node.isExpanded == true) {
//                self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
//            }
//        }
//    }
//    
//    func addChildrenArray(_ childrenArray: [TreeViewNode]) {
//        for node: TreeViewNode in childrenArray {
//            self.displayArray.append(node)
//            if (node.isExpanded == true ) {
//                if (node.nodeChildren != nil) {
//                    self.addChildrenArray(node.nodeChildren as! [TreeViewNode])
//                }
//            }
//        }
//    }
}


extension FTHomeViewController {
    
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
}


extension FTHomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    // MARK: - Tableview methodes
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homeViewModel.displayArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let node: TreeViewNode = self.homeViewModel.displayArray[indexPath.row]
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
        self.performSegue(withIdentifier: "TreeToDetailsSegue", sender: indexPath)
    }
}
