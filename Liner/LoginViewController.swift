//
//  LoginViewController.swift
//  testfirebase8
//
//  Created by Rohan Patel on 7/29/17.
//  Copyright © 2017 Rohan Patel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var switcher: UISegmentedControl!
var email: UITextField!
var password: UITextField!
var loginbutton: UIButton!
var error = 2

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        let items = ["Login", "Signup"]
        
        switcher = UISegmentedControl(items: items)
        switcher.selectedSegmentIndex = 0
        switcher.frame = CGRect(x: 150, y: 70, width: 100, height: 50)
        switcher.backgroundColor = .white
        view.addSubview(switcher)
        
        email = UITextField(frame: CGRect(x: 30, y: 150,width: 340, height: 40))
        email.backgroundColor = .white
        view.addSubview(email)
        
        password = UITextField(frame: CGRect(x: 30, y: 220,width: 340, height: 40))
        password.isSecureTextEntry = true
        password.backgroundColor = .white
        view.addSubview(password)
        
        loginbutton = UIButton(frame: CGRect(x: 150, y: 270, width: 100, height: 20))
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
                        email.text = ""
                        password.text = ""
                        return
                    }
                    self.navigationController?.pushViewController( MainViewController(), animated: true)
                //    self.createAlert(title: "Login Success", message: "You're Successfully Logged In")
                    email.text = ""
                    password.text = ""


                }
                



                
            }
                
            else // signup
           {
            let username = email.text!
            let pass = password.text!

            Auth.auth().createUser(withEmail: username, password: pass) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            self.createAlert(title: "Successful Signup", message: "Thanks for signing up!")
            email.text = ""
            password.text = ""



            
            
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
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
