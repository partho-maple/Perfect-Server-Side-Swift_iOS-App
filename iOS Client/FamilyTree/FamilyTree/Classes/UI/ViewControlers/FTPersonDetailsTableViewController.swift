//
//  FTPersonDetailsTableViewController.swift
//  FamilyTree
//
//  Created by Partho Biswas on 3/14/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Foundation
import Former
import ARSLineProgress
import Swinject

class FTPersonDetailsTableViewController: FormViewController { //UITableViewController {
    
    var isShowingRelation: Bool = true
    
    var person: PersonDetails?
    var node: NodeDetails?
    
    func setupWith(isShowingRelation: Bool, person: PersonDetails?, node: NodeDetails?)  {
        self.isShowingRelation = isShowingRelation
        self.person = person
        self.node = node
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)
    
    
    private func configure() {
        title = "Details Info"
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 40
        
        // Create RowFomers
        
        let ssnRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "SSN"
                $0.subText = (isShowingRelation ? self.node?.relative_social_security_number : self.person?.social_security_number)
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        let nameRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Name"
                $0.subText = (isShowingRelation ? self.node?.name : self.person?.name)
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        let genderRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Gender"
                $0.subText = (isShowingRelation ? self.node?.gender : self.person?.gender)
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        let birthdayRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Birth Date"
                
                var date: Date?
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                var dateString: String
                
                if (self.isShowingRelation) {
                    if ((self.node?.date_of_birth) != nil && (Int((self.node?.date_of_birth)!) > 0)) {
                        date = Date(timeIntervalSince1970: (self.node?.date_of_birth)!)
                        dateString = dateFormatter.string(from:date!)
                    } else {
                        dateString = ""
                    }
                } else {
                    if ((self.person?.date_of_birth) != nil && (Int((self.person?.date_of_birth)!) > 0)) {
                        date = Date(timeIntervalSince1970: (self.person?.date_of_birth)!)
                        dateString = dateFormatter.string(from:date!)
                    } else {
                        dateString = ""
                    }
                }
                $0.subText = dateString
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        let deathdayRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Death Day"
                
                var date: Date?
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let dateString: String
                
                if (self.isShowingRelation) {
                    if ((self.node?.date_of_death) != nil && (Int((self.node?.date_of_death)!) > 0)) {
                        date = Date(timeIntervalSince1970: (self.node?.date_of_death)!)
                        dateString = dateFormatter.string(from:date!)
                    } else {
                        dateString = ""
                    }
                } else {
                    if ((self.person?.date_of_death) != nil && (Int((self.person?.date_of_death)!) > 0)) {
                        date = Date(timeIntervalSince1970: (self.person?.date_of_death)!)
                        dateString = dateFormatter.string(from:date!)
                    } else {
                        dateString = ""
                    }
                }
                
                $0.subText = dateString
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        
        
        let relationRow = LabelRowFormer<FormLabelCell>()
            .configure {
                $0.text = "Relation"
                $0.subText = self.node?.relation
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
        }
        
        // Create Headers
        
        let createHeader: ((String) -> ViewFormer) = { text in
            return LabelViewFormer<FormLabelHeaderView>()
                .configure {
                    $0.viewHeight = 40
                    $0.text = text
            }
        }
        
        // Create SectionFormers
        
        if (self.isShowingRelation) {
            let aboutSection = SectionFormer(rowFormer: ssnRow, nameRow, genderRow, birthdayRow, deathdayRow)
                .set(headerViewFormer: createHeader("About"))
            let moreSection = SectionFormer(rowFormer: relationRow)
                .set(headerViewFormer: createHeader("Relationship Infomation"))
            
            former.append(sectionFormer: aboutSection, moreSection)
                .onCellSelected { [weak self] _ in
                    self?.formerInputAccessoryView.update()
            }
        } else {
            let aboutSection = SectionFormer(rowFormer: ssnRow, nameRow, genderRow, birthdayRow)
                .set(headerViewFormer: createHeader("About"))
            
            former.append(sectionFormer: aboutSection)
                .onCellSelected { [weak self] _ in
                    self?.formerInputAccessoryView.update()
            }
        }
        
    }
}
