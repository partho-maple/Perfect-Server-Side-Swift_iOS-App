//
//  AppDelegate.swift
//  FamilyTree
//
//  Created by Partho Biswas on 3/7/17.
//  Copyright © 2017 Partho Biswas. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Swinject
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        /*
        //  Creating me
        do {
            let personDetails = try PersonDetails()
            personDetails?.setPersonDetails("Partho005", name: "Partho", gender: "Male", dateOfBirth: Date().timeIntervalSince1970, dateOfDeath: 0)
            
            
            FamilyTreeAPIManager.createMe(personDetails: personDetails!) { (person) in
                if (person != nil) {
                    print((person?.toJSONString(prettyPrint: true))! as String)
                }
            }
        } catch {
            print("got error")
        }
        */
        
        
        /*
        // Creating node
        do {
            let nodeDetails = NodeDetails()
            nodeDetails?.setNodeDetails(ssn: "Partho007", relative_ssn: "Partho001", name: "Partho", gender: "Male", dateOfBirth: Date().timeIntervalSince1970, dateOfDeath: 0, relation: "Me", relation_id: 1, relatives: nil)
            
            
            FamilyTreeAPIManager.createNode(nodeDetails: nodeDetails!) { (node) in
                if (node != nil) {
                    print((node?.toJSONString(prettyPrint: true))! as String)
                }
            }
        } catch {
            print("got error")
        }
        */
        
        
        /*
        // Getting my details
        do {
            FamilyTreeAPIManager.getMyDetails(ssn: "Partho0070") { (person) in
                if (person != nil) {
                    print((person?.toJSONString(prettyPrint: true))! as String)
                }
            }
        } catch {
            print("got error")
        }
        */
        

        /*
        // Getting my relationship details
        do {
            FamilyTreeAPIManager.getRelationshipDetails(ssn: "Partho007") { (relations) in
                if (relations != nil) {
                    print((relations?.toJSONString(prettyPrint: true))! as String)
                }
            }
        } catch {
            print("got error")
        }
        */
        
        
//        let assembler = try! Assembler(assemblies: [FamilyTreeAssembly()])
//        let viewController = assembler.resolver.resolve(FTHomeViewController.self)!
        
        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: createContainer())
        window?.rootViewController = storyboard.instantiateInitialViewController()
        
        
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = viewController
//        window?.makeKeyAndVisible()
        
        
        
        
        
        
        self.applyDefaultAppearance()
        IQKeyboardManager.shared().isEnabled = true

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

