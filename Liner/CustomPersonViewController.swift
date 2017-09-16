//
//  CustomPersonViewController.swift
//  Liner
//
//  Created by Rohan Patel on 9/4/17.
//  Copyright © 2017 Alexander Li. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CustomPersonViewController: UIViewController, UITextFieldDelegate {
    
    var Name: UITextField!
    var addButton: UIButton!
    var ref: DatabaseReference!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        view.backgroundColor = .white
        
        Name = UITextField(frame: CGRect(x: 30, y: 230,width: 320, height: 40))
        Name.borderStyle = UITextBorderStyle.roundedRect
        //email.backgroundColor = .white
        view.addSubview(Name)

        addButton = UIButton(frame: CGRect(x: 150, y: 400, width: 100, height: 50))
        addButton.setTitle("Add Person", for: .normal)
        addButton.backgroundColor = .blue
        addButton.setTitleColor(.white, for: .normal)
        addButton.addTarget(self, action:#selector(add), for: .touchUpInside)
        view.addSubview(addButton)

        
        
        
        // Do any additional setup after loading the view.
    }
    
    func add() {
        
        
        let user = Auth.auth().currentUser
        let currentDateTime = Date()
        
        ref?.child("Queues").child((user?.displayName)!).child(String(describing: currentDateTime)).setValue(Name.text)
        
                
        self.navigationController?.popViewController(animated: true)

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if (Name.text != nil) {
            add()
        }
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
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
