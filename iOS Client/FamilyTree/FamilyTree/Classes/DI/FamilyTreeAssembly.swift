//
//  FamilyTreeAssembly.swift
//  FamilyTree
//
//  Created by Partho Biswas on 5/11/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import Foundation
import Swinject

public class FamilyTreeAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(FamilyTreeAPI.self) { r in
            return FamilyTreeAPIRequester()
        }
        
        container.register(FTHomeViewModel.self) { r in
            return FTHomeViewModel()
        }
        
//        container.register(FTHomeViewController.self) { r in
//            let controller = FTHomeViewController()
//            controller.familyTreeAPI = r.resolve(FamilyTreeAPIRequester.self)
//            controller.homeViewModel = r.resolve(FTHomeViewModel.self)
//            return controller
//        }
        
    }
    
}
