//
//  SignUpViewController.swift
//  Liner
//
//  Created by Ashley Yang on 9/16/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

//
//  SignInViewController.swift
//  Liner
//
//  Created by Ashley Yang on 9/16/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import DLRadioButton

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var email: UITextField!
    var password: UITextField!
    var signUpButton: UIButton!
    var managerButton: DLRadioButton!
    var customerButton: DLRadioButton!
    var otherButton: [DLRadioButton]! = []
    var loginButton: UIButton!

    var error = 2

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
    
    //MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if ((password.text != nil) && email.text != "") {
            signUp()
        }
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: LOGIN BUTTON
    
    func pressUp(_ sender:Any){
        signUpButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 230/255, alpha: 1)
    }
    
    func pressDown(_ sender:Any){
        signUpButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 130/255, alpha: 1)
    }
    
    func login(){
        self.navigationController?.pushViewController( LoginViewController(), animated: true)
        //self.createAlert(title: "Login Success", message: "You're Successfully Logged In")
        self.email.text = ""
        self.password.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managerButton = createRadioButton(frame: CGRect(x: 30, y: 270, width: 100, height: 100), title: "manager", color: UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 130/255, alpha: 1))
        managerButton.isMultipleSelectionEnabled = false
        
        view.addSubview(managerButton)
        customerButton = createRadioButton(frame: CGRect(x: view.frame.size.width-100, y: 270, width: 100, height: 100), title: "customer", color: UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 130/255, alpha: 1))
        otherButton.append(customerButton)
        managerButton.otherButtons = otherButton

        
        view.backgroundColor = .white
        
        
        email = UITextField(frame: CGRect(x: 30, y: 200,width: view.frame.size.width-60, height: 40))
        email.placeholder = "Email"
        email.borderStyle = UITextBorderStyle.roundedRect
        //email.backgroundColor = .white
        view.addSubview(email)
        
        password = UITextField(frame: CGRect(x: 30, y: 250,width: view.frame.size.width-60, height: 40))
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.borderStyle = UITextBorderStyle.roundedRect
        //password.backgroundColor = .white
        view.addSubview(password)
        
        signUpButton = UIButton(frame: CGRect(x: 100, y: 350, width: view.frame.size.width-200, height: 50))
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = .blue
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action:#selector(signUp), for: .touchUpInside)
        signUpButton.addTarget(self, action:#selector(pressUp), for: .touchUpOutside)
        signUpButton.addTarget(self, action:#selector(pressDown), for: .touchDown)
        signUpButton.backgroundColor = .white
        signUpButton.layer.cornerRadius = 25
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1).cgColor
        signUpButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1), for: .normal)
        
        view.addSubview(signUpButton)
        view.addSubview(managerButton)
        view.addSubview(customerButton)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    func createAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func signUp(){
        let username = email.text!
        let pass = password.text!
        
        signUpButton.backgroundColor = .white
        
        Auth.auth().createUser(withEmail: username, password: pass) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
                // create the alert
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                // return
            }
            
            if(self.managerButton.isSelected)
            {
                let user = Auth.auth().currentUser
                let changeRequest = user?.createProfileChangeRequest()
                let tempURL = URL(fileURLWithPath: "Manager")
                changeRequest?.photoURL = tempURL
                changeRequest?.commitChanges(completion: { (error) in
                    
                })
                
                //email.text = ""
                //password.text = ""
                user?.sendEmailVerification()
                // create the alert
                let alert = UIAlertController(title:  "Successful Signup Manager!", message: "Thanks for signing up! You have been sent a confirmation email", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)


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
                
                user?.sendEmailVerification()
                
                let alert = UIAlertController(title:   "Successful Signup Customer!", message: "Thanks for signing up! You have been sent a confirmation email", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                // email.text = ""
                // password.text = ""

            }
            

        }
    
    }
}
