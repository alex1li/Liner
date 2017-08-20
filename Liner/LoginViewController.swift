//
//  LoginViewController.swift
//  Liner
//
//  Created by Alexander Li on 8/7/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DLRadioButton

var switcher: UISegmentedControl!
var email: UITextField!
var password: UITextField!
var loginbutton: UIButton!
var managerButton: DLRadioButton!
var customerButton: DLRadioButton!
var otherButton: [DLRadioButton]! = []




var error = 2

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managerButton = createRadioButton(frame: CGRect(x: 30, y: 250, width: 100, height: 100), title: "Manager?", color: UIColor.white)
        managerButton.isMultipleSelectionEnabled = false
        
        view.addSubview(managerButton)
        customerButton = createRadioButton(frame: CGRect(x: 250, y: 250, width: 100, height: 100), title: "Customer?", color: UIColor.white)
        otherButton.append(customerButton)
        managerButton.otherButtons = otherButton
        
        managerButton.isHidden = true
        customerButton.isHidden = true
        
        view.backgroundColor = .blue
        
        let items = ["Login", "Signup"]
        
        switcher = UISegmentedControl(items: items)
        switcher.selectedSegmentIndex = 0
        switcher.frame = CGRect(x: 150, y: 70, width: 100, height: 50)
        switcher.backgroundColor = .white
        switcher.addTarget(self, action: #selector(switch2), for: .allEvents)

        view.addSubview(switcher)
        
        email = UITextField(frame: CGRect(x: 30, y: 150,width: 340, height: 40))
        email.backgroundColor = .white
        view.addSubview(email)
        
        password = UITextField(frame: CGRect(x: 30, y: 220,width: 340, height: 40))
        password.isSecureTextEntry = true
        password.backgroundColor = .white
        view.addSubview(password)
        
        loginbutton = UIButton(frame: CGRect(x: 150, y: 400, width: 100, height: 20))
        loginbutton.setTitle("Login", for: .normal)
        loginbutton.backgroundColor = .white
        loginbutton.setTitleColor(.black, for: .normal)
        loginbutton.addTarget(self, action:#selector(login), for: .touchUpInside)
        
        
        view.addSubview(loginbutton)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(switcher.selectedSegmentIndex == 1)
        { loginbutton.setTitle("Signup", for: .normal)
        }
        
    }
    
    
    func login() {
        
        if(email.text != "" && password.text != "") {
            
            if(switcher.selectedSegmentIndex == 0) // login
            {
                
                let username = email.text!
                let pass = password.text!
                Auth.auth().signIn(withEmail: username, password: pass) { (user, error) in
                    if let error = error {
                        self.createAlert(title: "Login Error", message: "Sorry you're not signed up!")
                  //      email.text = ""
                   //     password.text = ""
                        return
                    }
                    
                    let user = Auth.auth().currentUser
                    
                    print(user?.photoURL?.absoluteString)
                    if(user?.photoURL?.absoluteString == "file:///Manager")
                    {
                        email.text = ""
                        password.text = ""
                        self.navigationController?.pushViewController( ManagerViewController(), animated: true)

                        return
                        
                    }
                    //Store it so it can be accessed again later
                    //Queue.statusViewController = StatusViewController()
                    self.navigationController?.pushViewController( StatusViewController(), animated: true)
                    //self.createAlert(title: "Login Success", message: "You're Successfully Logged In")
                    email.text = ""
                    password.text = ""
                                       
        
                    //self.navigationController?.pushViewController(StatusViewController(), animated: true)
                    //self.createAlert(title: "Login Success", message: "You have successfully logged in")
                  //  email.text = ""
                   // password.text = ""
                }
                
                }
                
                
                
            
            else // signup
            {
                let username = email.text!
                let pass = password.text!
                
                Auth.auth().createUser(withEmail: username, password: pass) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                       // return
                    }
                    
                
                if(managerButton.isSelected)
                {
                    let user = Auth.auth().currentUser
                    let changeRequest = user?.createProfileChangeRequest()
                    let tempURL = URL(fileURLWithPath: "Manager")
                    changeRequest?.photoURL = tempURL
                    changeRequest?.commitChanges(completion: { (error) in
                        
                    })
                    
                    //email.text = ""
                    //password.text = ""
                    
                    self.createAlert(title: "Successful Signup Manager!", message: "Thanks for signing up!")

                    //self.navigationController?.pushViewController( ManagerViewController(), animated: true)
                }
                else
                {
                    let user = Auth.auth().currentUser
                    let changeRequest = user?.createProfileChangeRequest()
                    let tempURL = URL(fileURLWithPath: "Customer")
                    changeRequest?.photoURL = tempURL
                    
                    changeRequest?.commitChanges(completion: { (error) in
                        
                    })
                    
                    print("customer")


                self.createAlert(title: "Successful Signup Customer!", message: "Thanks for signing up!")
               // email.text = ""
               // password.text = ""
                
                
                
                }
                
                }
            
        }
        }
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
     func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        // from cocoa pod
        let radioButton = DLRadioButton(frame: frame);
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14);
        radioButton.setTitle(title, for: UIControlState.normal);
        radioButton.setTitleColor(color, for: UIControlState.normal);
        radioButton.iconColor = color;
        radioButton.indicatorColor = color;
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left;
        radioButton.isIconSquare = true
        self.view.addSubview(radioButton);
        
        return radioButton;
    }

    func switch2() {
        print("huh?")
        
        if(switcher.selectedSegmentIndex == 1)
        { loginbutton.setTitle("Signup", for: .normal)
            managerButton.isHidden = false
            customerButton.isHidden = false
        }
        if(switcher.selectedSegmentIndex == 0) {
            loginbutton.setTitle("Login", for: .normal)
            managerButton.isHidden = true
            customerButton.isHidden = true
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
