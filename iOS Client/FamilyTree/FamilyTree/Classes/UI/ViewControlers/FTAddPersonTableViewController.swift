//
//  FTAddPersonTableViewController.swift
//  FamilyTree
//
//  Created by Partho Biswas on 3/14/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Foundation
import Former
import Toaster
import ARSLineProgress

class FTAddPersonTableViewController: FormViewController { //UITableViewController {
    
    var isAddingRelation: Bool = true
    var saveBarBtnVar: UIBarButtonItem?
    private var person: PersonDetails?
    private var node: NodeDetails?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            person = try PersonDetails()
            node = try NodeDetails()
        } catch {
            print("got error")
        }

        saveBarBtnVar = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addButtonTapped(_:)))
        self.navigationItem.setRightBarButtonItems([saveBarBtnVar!], animated: true)
        
        configure()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            ARSLineProgress.show()
        }
        if self.isAddingRelation {
            let mySSN = Defaults[.mySSN]
            self.node?.social_security_number = mySSN
            
            if (((self.node?.social_security_number) != nil) && ((self.node?.relative_social_security_number) != nil) && ((self.node?.name) != nil) && ((self.node?.gender) != nil) && ((self.node?.date_of_birth) != nil && (Int((self.node?.date_of_birth)!) > 0)) && ((self.node?.relation) != nil)) {
                
                FamilyTreeAPIManager.createNode(nodeDetails: node!) { (node) in
                    
                    if (node != nil) {
                        print((node?.toJSONString(prettyPrint: true))! as String)
                        let toast = Toast(text: "Creation successfull!", delay: 0, duration: 2)
                        toast.show()
                        DispatchQueue.main.async {
                            ARSLineProgress.hide()
                        }
                        
                    } else {
                        let toast = Toast(text: "Couldn't create. Something went wrong!", delay: 0, duration: 2)
                        toast.show()
                        DispatchQueue.main.async {
                            ARSLineProgress.hide()
                        }
                    }
                }
                
            } else {
                let toast = Toast(text: "Please enter required values!", delay: 0, duration: Delay.long)
                toast.show()
                DispatchQueue.main.async {
                    ARSLineProgress.hide()
                }
            }
            
        } else {
            if (((self.person?.social_security_number) != nil) && ((self.person?.name) != nil) && ((self.person?.gender) != nil) && ((self.person?.date_of_birth) != nil && (Int((self.person?.date_of_birth)!) > 0))) {
                
                do {
                    FamilyTreeAPIManager.createMe(personDetails: self.person!) { (person) in
                        if (person != nil) {
                            print((person?.toJSONString(prettyPrint: true))! as String)
                            
                            Defaults[.mySSN] = person?.social_security_number
                            let toast = Toast(text: "Creation successfull!", delay: 0, duration: Delay.long)
                            toast.show()
                            DispatchQueue.main.async {
                                ARSLineProgress.hide()
                            }
                        } else {
                            let toast = Toast(text: "Couldn't create. Checking If user exists!", delay: 0, duration: Delay.long)
                            toast.show()
                            DispatchQueue.main.async {
                                ARSLineProgress.hide()
                            }
                            
                            FamilyTreeAPIManager.getMyDetails(ssn: (self.person?.social_security_number)!) { (person) in
                                if (person != nil) {
                                    print((person?.toJSONString(prettyPrint: true))! as String)
                                    
                                    Defaults[.mySSN] = person?.social_security_number
                                    let toast = Toast(text: "User exists!", delay: 0, duration: Delay.long)
                                    toast.show()
                                    DispatchQueue.main.async {
                                        ARSLineProgress.hide()
                                    }
                                    
                                } else {
                                    let toast = Toast(text: "User doesn't exists!", delay: 0, duration: 2)
                                    toast.show()
                                    DispatchQueue.main.async {
                                        ARSLineProgress.hide()
                                    }
                                }
                            }
                            
                        }
                    }
                } catch {
                    let toast = Toast(text: "Couldn't create. Server error!", delay: 0, duration: Delay.long)
                    toast.show()
                    DispatchQueue.main.async {
                        ARSLineProgress.hide()
                    }
                }
                
            } else {
                let toast = Toast(text: "Please enter required values!", delay: 0, duration: Delay.long)
                toast.show()
                DispatchQueue.main.async {
                    ARSLineProgress.hide()
                }
            }
        }
    }
    
    
    private lazy var formerInputAccessoryView: FormerInputAccessoryView = FormerInputAccessoryView(former: self.former)

    
    private func configure() {
        title = "Add Profile"
        tableView.contentInset.top = 0
        tableView.contentInset.bottom = 40
        
        // Create RowFomers
        let ssnRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "SSN"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add SSN"
            }.onTextChanged {
                print($0)
                if (self.isAddingRelation) {
                    self.node?.relative_social_security_number = $0
                } else {
                    self.person?.social_security_number = $0
                }
        }
        let nameRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Name"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add name"
            }.onTextChanged {
                print($0)
                if (self.isAddingRelation) {
                    self.node?.name = $0
                } else {
                    self.person?.name = $0
                }
        }
        let genderRow = InlinePickerRowFormer<ProfileLabelCell, String>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Gender"
            }.configure {
                let genders = ["Male", "Female"]
                $0.pickerItems = genders.map {
                    InlinePickerItem(title: $0)
                }
                if (self.isAddingRelation) {
                    self.node?.gender = "Male"
                } else {
                    self.person?.gender = "Male"
                }
            }.onValueChanged {
                print($0)
                if (self.isAddingRelation) {
                    self.node?.gender = $0.title
                } else {
                    self.person?.gender = $0.title
                }
        }
        let birthdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "Birthday"
            }.configure {_ in 

            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.displayTextFromDate {
                return String.mediumDateNoTime(date: $0)
            }.onDateChanged {
                let date: Date = $0
                print(String(date.timeIntervalSince1970))
                if (self.isAddingRelation) {
                    self.node?.date_of_birth = date.timeIntervalSince1970
                } else {
                    self.person?.date_of_birth = date.timeIntervalSince1970
                }
        }
        let deathdayRow = InlineDatePickerRowFormer<ProfileLabelCell>(instantiateType: .Nib(nibName: "ProfileLabelCell")) {
            $0.titleLabel.text = "DeathDay"
            }.configure {_ in
                
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .date
            }.displayTextFromDate {
                return String.mediumDateNoTime(date: $0)
            }.onDateChanged {
                let date: Date = $0
                print(String(date.timeIntervalSince1970))
                if (self.isAddingRelation) {
                    self.node?.date_of_death = date.timeIntervalSince1970
                } else {
                    self.person?.date_of_birth = date.timeIntervalSince1970
                }
        }

        let relationRow = TextFieldRowFormer<ProfileFieldCell>(instantiateType: .Nib(nibName: "ProfileFieldCell")) { [weak self] in
            $0.titleLabel.text = "Relation"
            $0.textField.inputAccessoryView = self?.formerInputAccessoryView
            }.configure {
                $0.placeholder = "Add relation"
            }.onTextChanged {
                print($0)
                self.node?.relation = $0
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
        
        if (self.isAddingRelation) {
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
