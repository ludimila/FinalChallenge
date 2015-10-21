//
//  RegisterVC.swift
//  SearchBuddy
//
//  Created by Matheus Godinho on 10/20/15.
//  Copyright © 2015 Gustavo Henrique. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    var stateArray: [String] = [String]()
    var cityArray: [String] = [String]()
    
    var selectedCity: String!
    var selectedState: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stateArray = ["DF","GO","MG","SP","BA","RJ"]
        cityArray = ["Cidade A","Cidade B","Cidade C","Cidade D","Cidade E"]
        
        statePicker.dataSource = self
        statePicker.delegate = self
        
        cityPicker.dataSource = self
        cityPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        
        if pickerView.tag == 0{
            count = stateArray.count
        }
        else{
            count = cityArray.count
        }
        
        return count
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var dataForRow = ""
        if pickerView.tag == 0{
            dataForRow = stateArray[row]
        }
        else{
            dataForRow = cityArray[row]
        }
        
        return dataForRow
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            selectedState = stateArray[row]
        }else{
            selectedCity = cityArray[row]
        }
    }
    
    
    @IBAction func doRegister(sender: AnyObject) {
        let user = User()
        user.name = nameField.text
        user.username = usernameField.text
        user.password = passwordField.text
        user.city = selectedCity
        user.state = selectedState
        
        UserDAO.signUpUser(user) { (sucessed,error) -> Void in
            if sucessed{
                print("FoI")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }else{
                let errorString = error!.userInfo["error"] as? NSString
                print("\(errorString)")
            }
        }
        
        
        
        
    }

}
