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


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var switcher: UISegmentedControl!
    var email: UITextField!
    var password: UITextField!
    var loginButton: UIButton!
    var forgotPassword: UIButton!
    var managerButton: DLRadioButton!
    var customerButton: DLRadioButton!
    var otherButton: [DLRadioButton]! = []
    
    
    var error = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        managerButton = createRadioButton(frame: CGRect(x: 30, y: 330, width: 100, height: 100), title: "Manager?", color: UIColor.black)
        managerButton.isMultipleSelectionEnabled = false
        
        view.addSubview(managerButton)
        customerButton = createRadioButton(frame: CGRect(x: 250, y: 330, width: 100, height: 100), title: "Customer?", color: UIColor.black)
        otherButton.append(customerButton)
        managerButton.otherButtons = otherButton
        
        managerButton.isHidden = true
        customerButton.isHidden = true
        
        view.backgroundColor = .white
        
        let items = ["Login", "Signup"]
        
        switcher = UISegmentedControl(items: items)
        switcher.selectedSegmentIndex = 0
        switcher.frame = CGRect(x: 150, y: 70, width: 100, height: 50)
        switcher.backgroundColor = .white
        switcher.addTarget(self, action: #selector(switch2), for: .allEvents)

        view.addSubview(switcher)
        
        email = UITextField(frame: CGRect(x: 30, y: 230,width: 320, height: 40))
        email.placeholder = "Email"
        email.borderStyle = UITextBorderStyle.roundedRect
        //email.backgroundColor = .white
        view.addSubview(email)
        
        password = UITextField(frame: CGRect(x: 30, y: 300,width: 320, height: 40))
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.borderStyle = UITextBorderStyle.roundedRect
        //password.backgroundColor = .white
        view.addSubview(password)
        
        loginButton = UIButton(frame: CGRect(x: 150, y: 400, width: 100, height: 50))
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action:#selector(login), for: .touchUpInside)
        loginButton.addTarget(self, action:#selector(pressUp), for: .touchUpOutside)
        loginButton.addTarget(self, action:#selector(pressDown), for: .touchDown)
        
        
        forgotPassword = UIButton(frame: CGRect(x: 100, y: 450, width: 200, height: 50))
        forgotPassword.setTitle("Forgot Password", for: .normal)
        forgotPassword.setTitleColor(.black, for: .normal)
        forgotPassword.addTarget(self, action:#selector(forgotPword), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(forgotPassword)
      
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(switcher.selectedSegmentIndex == 1)
        { loginButton.setTitle("Signup", for: .normal)
        }
        
    }
    
    
    func forgotPword(){
        let e = email.text!
        if (e == ""){
            
            
            // create the alert
            let alert = UIAlertController(title: "Error", message: "Please enter email in the email field", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
            }))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)        }
        else{
            
            Auth.auth().sendPasswordReset(withEmail: e){(error) in
                print(error?.localizedDescription)
            }
            
            
        }
    }
    
    func login() {
        pressUp(loginButton)
        if(email.text != "" && password.text != "") {
            
            if(switcher.selectedSegmentIndex == 0) // login
            {
                
                let username = email.text!
                let pass = password.text!
                Auth.auth().signIn(withEmail: username, password: pass) { (user, error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        // return
                    }
                    
                    let user = Auth.auth().currentUser
                    
                    /**********************************************/
                    if (!(user?.isEmailVerified)!){
                        let alert = UIAlertController(title: "Error", message: "Please verify your account first", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in alert.dismiss(animated: true, completion: nil)
                        }))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    /**********************************************/
                    
                    //print(user?.photoURL?.absoluteString)
                    if(user?.photoURL?.absoluteString == "file:///Manager")
                    {
                        self.email.text = ""
                        self.password.text = ""
                        self.navigationController?.pushViewController( ManagerViewController(), animated: true)
                        
                        return
                        
                    }
                    //Store it so it can be accessed again later
                    //Queue.statusViewController = StatusViewController()
                    self.navigationController?.pushViewController( StatusViewController(), animated: true)
                    //self.createAlert(title: "Login Success", message: "You're Successfully Logged In")
                    self.email.text = ""
                    self.password.text = ""
                    
                    
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
                        
                        user?.sendEmailVerification()
                        
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
        { loginButton.setTitle("Signup", for: .normal)
            managerButton.isHidden = false
            customerButton.isHidden = false
        }
        if(switcher.selectedSegmentIndex == 0) {
            loginButton.setTitle("Login", for: .normal)
            managerButton.isHidden = true
            customerButton.isHidden = true
        }
    }
    
    //MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if ((password.text != nil) && email.text != "") {
            login()
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
        loginButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 230/255, alpha: 1)
    }
    
    func pressDown(_ sender:Any){
        loginButton.backgroundColor = UIColor(colorLiteralRed: 40/255, green: 60/255, blue: 130/255, alpha: 1)
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
