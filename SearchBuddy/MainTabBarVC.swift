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
       
        let mapSB = createStoryBoard("Map", imageName: "MedalGoals")
        let perfilSB = createStoryBoard("Perfil", imageName: "PerfilBar")
        let feedSB = createStoryBoard("Feed", imageName: "FeedBar")
        
        self.viewControllers = [mapSB,feedSB,perfilSB]
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
