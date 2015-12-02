//
//  MainTabBarVC.swift
//  SearchBuddy
//
//  Created by Gustavo Henrique on 02/10/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

// Protocolo para saber qual usuário é pra mostrar no perfil
protocol ShowUserInProfileView{
    func isCurrentUser()
}

class MainTabBarVC: UITabBarController {
    
    var clicked = false
    
    var delegateUserProfile: ShowUserInProfileView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTabBar()
        
        let buttonImage = UIImage(named: "centerButton")
        
        addCenterButtonWithImage(buttonImage!, highlightImage: nil)
        
        let nvc = self.viewControllers![3] as! UINavigationController
        let vc = nvc.viewControllers[0] as! ProfileVC
        
        self.delegateUserProfile = vc
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let index = tabBar.items?.indexOf(item)
        if index == 3{
            self.delegateUserProfile?.isCurrentUser()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addCenterButtonWithImage(buttonImage: UIImage, highlightImage: UIImage?){
        let button = UIButton(type: .Custom) as UIButton
        button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height)
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.setBackgroundImage(highlightImage, forState: UIControlState.Highlighted)
        button.addTarget(self, action: "buttonEvent", forControlEvents: UIControlEvents.TouchUpInside)
        
        let heightDifference: CGFloat = buttonImage.size.height - self.tabBar.frame.size.height
        
        print("CENTER TAB = \(self.tabBar.frame.size.height) ------ CENTER IMAGE = \(buttonImage.size.height) --------- DIFERENÇA = \(heightDifference)")
        
        if (heightDifference < 0){
            button.center = self.tabBar.center
        }else{
            var center: CGPoint = self.tabBar.center
            center.y = center.y - heightDifference/2.0
            button.center = center
        }
        self.view.addSubview(button)
    }
    
    func buttonEvent() {
        if clicked == false{
            addButtons()
            clicked = true
        }else{
            removeButtons()
            clicked = false
        }
    }
    
    func addButtons(){
        let buttonImage = UIImage(named: "patinha")
        let button = UIButton(type: .Custom) as UIButton
        button.frame = CGRectMake(0, 0, (buttonImage?.size.width)!, (buttonImage?.size.height)!)
           button.addTarget(self, action: "addAnimal", forControlEvents: UIControlEvents.TouchUpInside)
        button.setBackgroundImage(buttonImage, forState: .Normal)
        button.tag = 1
      
        let buttonImage2 = UIImage(named: "Lupa")
        let button2 = UIButton(type: .Custom) as UIButton
        button2.frame = CGRectMake(0, 0, (buttonImage2?.size.width)!, (buttonImage2?.size.height)!)
        button2.setBackgroundImage(buttonImage2, forState: .Normal)
        button2.tag = 2
        
        button.center = self.tabBar.center
        button2.center = self.tabBar.center
        
        UIView.animateWithDuration(0.5, animations: {
            button.center = self.view.center
            button.center.y = button.center.y + 230
            button.center.x = button.center.x - 50

            button2.center = self.view.center
            button2.center.y = button2.center.y + 230
            button2.center.x = button2.center.x + 50
        })
        
        
        self.view.addSubview(button2)
        self.view.addSubview(button)
    }
    
    func removeButtons(){
        let subviews = self.view.subviews as [UIView]
        for v in subviews {
            if let button = v as? UIButton {
                if button.tag == 1 || button.tag == 2 {
                    button.removeFromSuperview()
                }
            }
        }
    }

    
    func initTabBar(){
       
        self.tabBar.barTintColor = UIColor(red:0.25, green:0.71, blue:0.81, alpha:1.0)

        self.tabBar.tintColor = UIColor.whiteColor()
        
////        print("Tab bar: \( AnimalDAO.sharedInstance().allAnimals)")
//        let mapSB = createStoryBoard("Map", imageName: "MapBar")
//        let perfilSB = createStoryBoard("Profile", imageName: "PerfilBar")
//        let feedSB = createStoryBoard("Feed", imageName: "FeedBar")
//        let configSB = createStoryBoard("Config", imageName: "ConfigBar")
//        let animalProfile = createStoryBoard("AnimalProfile", imageName: "PerfilBar")
//        
//        self.viewControllers = [mapSB,feedSB,perfilSB,configSB,animalProfile]
        self.selectedIndex = 1
        
        
    }
    
    func addAnimal(){
        
        let sb = UIStoryboard(name: "AnimalProfile", bundle: nil)

       let animalVC = sb.instantiateInitialViewController() as! AnimalVC
        
        self.presentViewController(animalVC, animated: true, completion: nil)
        
        
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
