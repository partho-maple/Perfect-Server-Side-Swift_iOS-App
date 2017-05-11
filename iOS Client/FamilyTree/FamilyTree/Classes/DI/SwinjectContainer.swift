//
//  SwinjectContainer.swift
//  FamilyTree
//
//  Created by Partho Biswas on 5/11/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

func createContainer() -> Container {
  let container = Container()
  
  let assembler = Assembler(container: container)
  
  assembler.apply(assembly: FamilyTreeAssembly())
    
  container.storyboardInitCompleted(FTHomeViewController.self, initCompleted: { r, c in
    c.familyTreeAPI = r.resolve(FamilyTreeAPI.self)!
    c.homeViewModel = r.resolve(FTHomeViewModel.self)!
  })
  
  return container
}
