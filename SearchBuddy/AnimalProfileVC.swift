//
//  AnimalProfileVC.swift
//  SearchBuddy
//
//  Created by Ludimila da Bela Cruz on 09/11/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class AnimalProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate {
    
    
    //scroll
    var pageControl: UIPageControl!
    var scrollView: UIScrollView!
    var animalPicture: UIImageView!
    var endereco: String!
    
    //tableView
    @IBOutlet weak var tableView: UITableView!
    
    //algo
    @IBOutlet weak var animalName: UILabel!
    @IBOutlet weak var animalBreed: UILabel!

    
    var currentAnimal: Animal!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        
        
        self.loadScroll()
        self.configuraPageControl()
        
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.separatorColor = UIColor.orangeColor()
    
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func viewDidAppear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
        
           let cell = tableView.dequeueReusableCellWithIdentifier("locationCell", forIndexPath: indexPath) as! AnimalLocationTableViewCell
            
            if currentAnimal.animalStatus?.situation == "Estou perdido!"{
                cell.lastLocation.text = String(currentAnimal?.local)

            }else{
                cell.lastLocation.text = currentAnimal.animalStatus?.situation
            }
            

            return cell
        }
        
       else if indexPath.row == 1{
            
         let cell = tableView.dequeueReusableCellWithIdentifier("ownerCell", forIndexPath: indexPath) as! AnimalOwnerTableViewCell
            
            cell.ownerName.text = currentAnimal?.animalOwner?.name
            
            return cell
        }
        
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCellWithIdentifier("aboutCell", forIndexPath: indexPath) as! AnimalAboutTableViewCell
            return cell

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell", forIndexPath: indexPath) as! DescriptionTableViewCell
            
            cell.descriptionAnimal.text = currentAnimal.animalDescription
    
            return cell
        }
        
    }
    
    
    //scroll
    
    func loadScroll(){
        
        
        self.scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
        self.scrollView.delegate = self
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.view.addSubview(self.scrollView)
        
        var tamanho = CGFloat()
        
        for var i = 1; i <= 3; i++ {
           
       
            self.scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/2)
            self.scrollView.bounces = false
            
            if i == 1{
                self.animalPicture = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height/2))
                tamanho = tamanho + self.animalPicture.frame.size.width
            }else{
                self.animalPicture = UIImageView(frame: CGRectMake(tamanho, 0, self.view.frame.width, self.view.frame.height/2))
                tamanho = tamanho + self.animalPicture.frame.size.width
            }//fim else
            
            
            self.animalPicture.contentMode = .ScaleAspectFit
            self.animalPicture.image = UIImage(named:"animal"+String(i))
            self.configuraGradiente()
            self.scrollView.addSubview(self.animalPicture)

        }//fim for
        self.scrollView.contentSize = CGSizeMake(tamanho , self.scrollView.frame.size.height)
    }//fim funcao
    
    
    func configuraPageControl() {
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 50))
        self.pageControl.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/CGFloat(3))
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.whiteColor()
        self.pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.orangeColor()
        
        self.view.insertSubview(self.pageControl, aboveSubview: self.animalPicture)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pagina = floor((self.scrollView.contentOffset.x - self.scrollView.frame.size.width/2)/self.scrollView.frame.width)+1
        self.pageControl.currentPage = Int(pagina)
        
    }

    func configuraGradiente(){
        
        let gradientPicture = UIImage(named: "gradiente")
        let gradient = UIImageView.init(image: gradientPicture)
        let frame = self.animalPicture.frame
        gradient.frame = CGRectMake(0,frame.height - (frame.height/2),frame.width*(frame.width/10), frame.height/2)
        self.animalPicture.addSubview(gradient)
    
        let name = UILabel()
        let breed = UILabel()
        
        name.text = currentAnimal?.animalName
        breed.text = currentAnimal?.breed
        
        
        self.view.insertSubview(name, aboveSubview: gradient)
        

    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.isEdittingProfile()
    }
    
    
    
    func isEdittingProfile(){
        let rightBarButton = UIBarButtonItem(title: "Concluir", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneEditProfile"))
        
        rightBarButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func doneEditProfile(){
        let indexpath = NSIndexPath(forRow: 3, inSection: 0)
        let cell = self.tableView.cellForRowAtIndexPath(indexpath) as! DescriptionTableViewCell
        
        self.currentAnimal.animalDescription = cell.descriptionAnimal.text
        
        AnimalDAO.sharedInstance().updateAnimal(self.currentAnimal)
    }
}
