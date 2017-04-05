//
//  DefaultsKeys.swift
//  FamilyTree
//
//  Created by Partho Biswas on 3/14/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import Foundation
import SwiftyUserDefaults


struct UserDefaultsKeys {
    public static let mySSN = "mySSN"
}


extension DefaultsKeys {
    static let mySSN = DefaultsKey<String?>(UserDefaultsKeys.mySSN)
}
