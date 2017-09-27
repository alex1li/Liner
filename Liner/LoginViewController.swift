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
    
    var email: UITextField!
    var password: UITextField!
    var loginButton: UIButton!
    var forgotPassword: UIButton!
    var signUpButton: UIButton!
    var otherButton: [DLRadioButton]! = []
    
    
    var error = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        loginButton = UIButton(frame: CGRect(x: 100, y: 350, width: view.frame.size.width-200, height: 50))
        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action:#selector(login), for: .touchUpInside)
        loginButton.addTarget(self, action:#selector(pressUp), for: .touchUpOutside)
        loginButton.addTarget(self, action:#selector(pressDown), for: .touchDown)
        loginButton.backgroundColor = .white
        loginButton.layer.cornerRadius = 25
        loginButton.layer.borderWidth = 1.5
        loginButton.layer.borderColor = UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1).cgColor
        loginButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 200/255, alpha: 1), for: .normal)
        
        signUpButton = UIButton(frame: CGRect(x: view.frame.size.width/2-30, y: 400, width: 60, height: 50))
        signUpButton.setTitle("sign up", for: .normal)
        signUpButton.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 255/255, alpha: 1), for: .normal)
        signUpButton.addTarget(self, action:#selector(signUp), for: .touchUpInside)

        
        forgotPassword = UIButton(frame: CGRect(x: 17, y: 300, width: 150, height: 20))
        forgotPassword.setTitle("forgot password", for: .normal)
        forgotPassword.setTitleColor(UIColor(colorLiteralRed: 50/255, green: 50/255, blue: 255/255, alpha: 1), for: .normal)
        forgotPassword.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Light", size: 17)!
        forgotPassword.addTarget(self, action:#selector(forgotPword), for: .touchUpInside)
        
        view.addSubview(loginButton)
        view.addSubview(forgotPassword)
        view.addSubview(signUpButton)
        
        let logo = UIImageView(frame: CGRect(x: 40, y: 70, width: view.frame.size.width-80, height: 100))
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named:"lynn.png")
        view.addSubview(logo)
      
        
        // Do any additional setup after loading the view.
    }
    

    func signUp(){
        self.navigationController?.pushViewController( SignUpViewController(), animated: true)
        return
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
        loginButton.backgroundColor = .white    }
    
    func pressDown(_ sender:Any){
        loginButton.backgroundColor = UIColor(colorLiteralRed: 5/255, green: 50/255, blue: 200/255, alpha: 1)
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
