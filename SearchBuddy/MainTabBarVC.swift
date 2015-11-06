//
//  MainTabBarVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 02/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
        self.initTabBar()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initTabBar(){
       
        self.tabBar.barTintColor = UIColor(red:0.25, green:0.71, blue:0.81, alpha:1.0)
        self.tabBar.tintColor = UIColor.whiteColor()
        
//        print("Tab bar: \( AnimalDAO.sharedInstance().allAnimals)")
        let mapSB = createStoryBoard("Map", imageName: "MapBar")
        let perfilSB = createStoryBoard("Profile", imageName: "PerfilBar")
        let feedSB = createStoryBoard("Feed", imageName: "FeedBar")
        let configSB = createStoryBoard("Config", imageName: "ConfigBar")
        let animalProfile = createStoryBoard("AnimalProfile", imageName: "PerfilBar")
        
        self.viewControllers = [mapSB,feedSB,perfilSB,configSB,animalProfile]
        self.selectedIndex = 1
        
        
    }
    
    
    func createStoryBoard(name: String, imageName: String) -> UIViewController{
        
        let storyBoard = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
        
        storyBoard?.tabBarItem.image = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        storyBoard?.tabBarItem.title = name
        
        
        return storyBoard!
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
